# ADR-001 — Validación de Persistencia de Notificaciones Background
---
## 1. Contexto del Riesgo Técnico Evaluado

### Descripción del Problema
El proyecto requiere que las notificaciones de recordatorios sean entregadas de 
forma confiable e intrusiva al usuario, incluso cuando la aplicación se encuentra en segundo plano, 
ha sido eliminada de memoria por el sistema operativo, o el dispositivo se encuentra en modo de ahorro de energía.

Este comportamiento representa el **riesgo técnico más crítico** del proyecto, dado que el valor central de la solución
(recordatorios insistentes que no pueden ignorarse) depende completamente de la capacidad del sistema para disparar 
notificaciones bajo condiciones adversas del entorno móvil.

### Restricciones Técnicas Identificadas

Las versiones modernas de Android imponen restricciones progresivamente más estrictas sobre la ejecución en background:

- **Android 12+ (API 31+):** Restricciones sobre `SCHEDULE_EXACT_ALARM` — las alarmas exactas requieren permiso explícito del usuario desde Configuración del sistema.
- **Doze Mode (Android 6+):** El sistema suspende tareas en background cuando el dispositivo lleva tiempo inactivo, postergando o descartando ejecuciones programadas.
- **App Standby Buckets (Android 9+):** Las aplicaciones inactivas son clasificadas en cubetas de prioridad que limitan la frecuencia de ejecución en background.
- **Fabricantes con capas personalizadas (MIUI, One UI, OxygenOS):** Aplican capas adicionales de optimización de batería que pueden matar procesos en background incluso con permisos concedidos.
- **Terminación del proceso por el SO:** Cuando el sistema libera memoria, el proceso Flutter puede ser eliminado, invalidando los listeners de notificaciones activos.

### Pregunta central de la PoC

> ¿Es posible maximizar la entrega confiable de notificaciones locales persistentes en Android moderno,
> sin depender de servicios cloud, utilizando exclusivamente `flutter_local_notifications` combinado con `workmanager`?

---
## 2. Decisiones de Estrategias y Librerías Adoptadas

### Decisión principal

Se adopta una arquitectura de **doble mecanismo de disparo** para maximizar la probabilidad de entrega de notificaciones:

| Mecanismo | Librería | Rol |
|---|---|---|
| Notificaciones exactas programadas | `flutter_local_notifications ^18.0.1` | Disparo primario por `AndroidFlutterLocalNotificationsPlugin.zonedSchedule()` |
| Reintento en background vía WorkManager | `workmanager ^0.5.2` | Tarea periódica de rescate cuando el proceso principal es eliminado |
| Gestión de zonas horarias | `flutter_timezone ^1.0.9` + `timezone ^0.9.4` | Mantener consistencia horaria en zonas horarias locales |
| Persistencia del estado de tareas | `shared_preferences ^2.3.2` | Registro local de tareas pendientes accesible desde el worker de background |
| Gestión de permisos en runtime | `permission_handler ^11.3.1` | Solicitar `SCHEDULE_EXACT_ALARM`, `POST_NOTIFICATIONS` y `IGNORE_BATTERY_OPTIMIZATIONS` |
| Intent del sistema Android | `android_intent_plus ^5.0.2` | Redirigir al usuario a la pantalla de permisos especiales del sistema cuando se detecta restricción de batería |

### Justificación técnica por librería

**`flutter_local_notifications ^18.0.1`**  
Es el paquete con mayor madurez y adopción en pub.dev para notificaciones locales en Flutter. 
Provee acceso a `AndroidNotificationDetails` con configuración de `importance: Importance.max`, 
`priority: Priority.high` y `fullScreenIntent: true`, parámetros necesarios para notificaciones intrusivas. 
A partir de la versión 14+ incluye soporte nativo para Android 13 (`POST_NOTIFICATIONS`).

**`workmanager ^0.5.2`**  
Wrapper Flutter de la API WorkManager de Android Jetpack. WorkManager es el mecanismo oficial recomendado por Google 
para tareas confiables en background, con soporte para restricciones, reintentos con backoff exponencial y persistencia 
de tareas ante reinicios del dispositivo. A diferencia de `AlarmManager` puro, WorkManager respeta Doze Mode pero maximiza la probabilidad de ejecución.

**`timezone` + `flutter_timezone`**  
`zonedSchedule()` requiere objetos `TZDateTime` en lugar de `DateTime` estándar. Sin estas librerías, los recordatorios programados pueden dispararse 
a la hora incorrecta en cambios de horario de verano o en dispositivos con zona horaria configurada de forma no estándar.

**`permission_handler ^11.3.1`**  
Abstracción multiplataforma para solicitar permisos en runtime. Necesario para gestionar el flujo de permisos especiales de Android 12+ sin implementar 
código nativo.

**`android_intent_plus ^5.0.2`**  
Permite lanzar intents específicos de Android desde Dart, incluyendo `Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` para solicitar 
que el usuario exima la app de las restricciones de batería del sistema.

**`provider ^6.1.2`**  
Gestión de estado reactivo mediante `ChangeNotifier`. Se utiliza para propagar el estado de las tareas entre capas sin acoplamiento 
directo entre la UI y la lógica de negocio.

---

## 3. Resultados Esperados, Limitaciones y Plan de Integración

### 3.1 Resultados esperados al validar la PoC

La PoC implementa un experimento mínimo con los siguientes escenarios de prueba:

1. **Escenario nominal:** Notificación programada a 30 segundos con app en foreground → se espera entrega inmediata y correcta.
2. **Escenario background:** App enviada al background tras programar la notificación → se evalúa si el trigger de `flutter_local_notifications` es respetado.
3. **Escenario proceso eliminado:** App cerrada forzosamente desde el gestor de tareas → se evalúa si WorkManager reprograma o reintenta el disparo de la notificación pendiente.
4. **Escenario Doze Mode:** Dispositivo en reposo durante el tiempo programado → se evalúa si WorkManager garantiza ejecución eventual post-Doze.
5. **Escenario permiso denegado:** `SCHEDULE_EXACT_ALARM` denegado → se evalúa la degradación graceful hacia `inexactAlarm` como fallback.

### 3.2 Limitaciones conocidas del enfoque adoptado

- **WorkManager no garantiza exactitud temporal:** Las tareas periódicas de WorkManager tienen un margen mínimo de 15 minutos entre ejecuciones. Para recordatorios con precisión de minutos se requiere combinar con `flutter_local_notifications` como mecanismo primario.
- **Inexact Alarms como fallback:** En dispositivos con Android 12+ donde el usuario no conceda `SCHEDULE_EXACT_ALARM`, las notificaciones pueden retrasarse hasta varios minutos respecto a la hora exacta configurada. Esto es aceptable para el contexto del proyecto pero debe comunicarse al usuario.
- **Restricciones por fabricante no son gestionables programáticamente:** En MIUI (Xiaomi) y capas similares, la app puede ser silenciada independientemente de los permisos de Android estándar. La única mitigación es guiar al usuario mediante `android_intent_plus` a la pantalla de configuración específica del fabricante.
- **`fullScreenIntent` requiere permiso adicional en Android 14+:** Para mostrar la app por encima del lockscreen se necesita `USE_FULL_SCREEN_INTENT`, concedido automáticamente solo a apps de comunicaciones; para otras apps requiere solicitud explícita.

### 3.3 Plan de integración a la rama principal

Una vez validada la PoC, la integración a `main` o `develop` seguirá el siguiente plan:

1. **Refactorización del `NotificationManager`:** Encapsular toda la lógica de `flutter_local_notifications` en el servicio `NotificationService` de la capa de infraestructura, respetando la arquitectura por capas documentada en el diagrama C4.
2. **Implementación del `BackgroundService`:** Registrar el callback de WorkManager en `main.dart` mediante `Workmanager().initialize()` con `isInDebugMode: false` para producción, y definir el `callbackDispatcher` como función de nivel superior (`@pragma('vm:entry-point')`).
3. **Flujo de solicitud de permisos:** Integrar en el `onboarding` inicial de la app una secuencia de solicitud de permisos orquestada por `permission_handler`, con pantallas explicativas previas a cada solicitud para maximizar la tasa de aceptación.
4. **Persistencia del estado de tareas:** Garantizar que `shared_preferences` persista el mapa de tareas pendientes en un formato accesible para el `callbackDispatcher` de WorkManager desde el contexto background del worker, sin necesidad de inicializar el árbol de widgets de Flutter.
5. **Pruebas de regresión:** Ejecutar los 5 escenarios de la PoC sobre la integración refactorizada antes de realizar el merge a la rama principal.

---


