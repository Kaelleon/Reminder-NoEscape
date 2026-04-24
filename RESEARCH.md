# Investigacion sobre Aplicaciones y Funcionalidades.

## 📱 Aplicaciones similares.

A continuación, se presentan algunas aplicaciones de recordatorios y gestión de tareas similares:

- Google Keep: Permite crear notas rápidas y recordatorios basados en tiempo o ubicación de forma simple.
- Todoist: Aplicación de gestión de tareas que permite organizar proyectos, establecer fechas límite y recibir recordatorios inteligentes.
- Microsoft To Do: Permite crear listas de tareas, establecer recordatorios y sincronizar actividades entre dispositivos.
- Google Tasks: Herramienta sencilla para gestionar tareas personales con integración en el ecosistema de Google.
- TickTick: Aplicación que combina tareas, calendario y herramientas de productividad como temporizador y hábitos.

A diferencia de estas aplicaciones, Reminder: No Escape no se basa en recordatorios pasivos, sino en un sistema insistente e intrusivo que busca asegurar el cumplimiento de las tareas.  

## Detalle técnico de implementación.

### 📲 Implementación de notificaciones.

Las notificaciones se implementan utilizando el sistema de notificaciones del dispositivo:

- Se programa un conjunto de recordatorios al momento de crear la tarea.
- Estos recordatorios se almacenan con la fecha límite y el tiempo de anticipación.
- El sistema activa notificaciones automáticamente en los intervalos definidos.
- Si el usuario no interactúa, se generan nuevas notificaciones según la frecuencia configurada.

"En modo inactivo del dispositivo, estas notificaciones siguen funcionando en segundo plano."

### 🖥️ Implementación de alertas intrusivas.

Para mostrar alertas en pantalla completa:

- Se lanza una vista prioritaria sobre la pantalla actual del dispositivo.
- Esta vista bloquea parcialmente la interacción con otras aplicaciones.
- Permanece visible durante un tiempo mínimo. (por ejemplo, 10 segundos)
- Luego permite al usuario interactuar. (cerrar)

Esto simula la interrupcion obligatoria del flujo del usuario.

### ⏰ Implementación de la lógica de tiempo.

El sistema gestiona el tiempo mediante un controlador interno:

1. Al crear la tarea:
- Se guarda la fecha límite.
- Se calcula el inicio. (fecha límite - tiempo de anticipación)
2. Al llegar al inicio:
- Se activa el sistema de recordatorios.
3. Durante el proceso:
- Se recalcula el tiempo restante.
- Se ajusta la frecuencia. (en modo dinámico)

Esto permite aumentar la presion a medida que pasa el tiempo.

### 🔁 Implementación de repetición de recordatorios.
- Se utiliza un ciclo de ejecución en segundo plano.
- Cada intervalo (ej: 10 min → 5 min → 1 min) dispara un nuevo recordatorio.
- Si el usuario no completa la tarea, el ciclo continúa.

🚨El ciclo solo se detiene cuando:
- El usuario completa la tarea.
- Se alcanza la fecha límite.

### 📷 Implementación de captura de evidencia.
- Se activa el acceso a la cámara del dispositivo.
- El usuario captura una imagen.
- La imagen se asocia a la tarea como evidencia.
- Se guarda junto al estado de la tarea. (completada)

### 💾 Implementación del almacenamiento.
- Las tareas se guardan en almacenamiento local del dispositivo.
- Se registran:
  - Fecha límite.
  - Estado. (completada/incompleta)
  - Evidencia. (imagen)

Esto permite mantener un historial accesible dentro de la app.     

### Implementación de estímulos. (sonido/vibración)
- Cada recordatorio activa:
  - Sonido configurado.
  - Vibración del dispositivo.
- Estos parámetros pueden ser personalizados por el usuario.

Refuerzan la atención y reducen la posibilidad de ignorar el recordatorio.

