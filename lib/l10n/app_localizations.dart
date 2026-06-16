import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get tituloApp => 'Reminder: No Escape';

  // Settings
  String get configuracion => locale.languageCode == 'en' ? 'Settings' : 'Configuración';
  String get tema => locale.languageCode == 'en' ? 'Theme' : 'Tema';
  String get oscuro => locale.languageCode == 'en' ? 'Dark' : 'Oscuro';
  String get claro => locale.languageCode == 'en' ? 'Light' : 'Claro';
  String get idioma => locale.languageCode == 'en' ? 'Language' : 'Idioma';
  String get espanol => locale.languageCode == 'en' ? 'Spanish' : 'Español';
  String get ingles => 'English';
  String get sonido => locale.languageCode == 'en' ? 'Sound' : 'Sonido';
  String get sonidoAlerta => locale.languageCode == 'en' ? 'Alert sound' : 'Sonido de alerta';
  String get alerta => locale.languageCode == 'en' ? 'Alert' : 'Alerta';
  String get duracionAlerta => locale.languageCode == 'en' ? 'Alert duration' : 'Duración de la alerta';
  String get ayuda => locale.languageCode == 'en' ? 'Help' : 'Ayuda';
  String get soporte => locale.languageCode == 'en' ? 'Support' : 'Soporte';
  String get reportar => locale.languageCode == 'en' ? 'Report a problem' : 'Reportar un problema';
  String get calificar => locale.languageCode == 'en' ? 'Rate the app' : 'Calificar la app';
  String get privacidad => locale.languageCode == 'en' ? 'Privacy policy' : 'Política de privacidad';
  String get sinSonido => locale.languageCode == 'en' ? 'No sound' : 'Sin sonido';
  String get silencioTotal => locale.languageCode == 'en' ? 'Total silence' : 'Silencio total';
  String get personalizado => locale.languageCode == 'en' ? 'Custom' : 'Personalizado';
  String get ningunArchivo => locale.languageCode == 'en' ? 'No file selected' : 'Ningún archivo seleccionado';
  String get elegir => locale.languageCode == 'en' ? 'Choose' : 'Elegir';
  String get vistaPrevia => locale.languageCode == 'en' ? 'Preview' : 'Vista previa';
  String get reproducir => locale.languageCode == 'en' ? 'Play' : 'Reproducir';
  String get segundos => locale.languageCode == 'en' ? 'seconds' : 'segundos';

  // Home
  String get pendientes => locale.languageCode == 'en' ? 'Pending' : 'Pendientes';
  String get historial => locale.languageCode == 'en' ? 'History' : 'Historial';
  String get compartir => locale.languageCode == 'en' ? 'Share pending tasks' : 'Compartir tareas pendientes';

  // Drawer
  String get perfil => locale.languageCode == 'en' ? 'Profile' : 'Perfil';

  // Profile
  String get nombre => locale.languageCode == 'en' ? 'Name' : 'Nombre';
  String get miembroDesde => locale.languageCode == 'en' ? 'Member since' : 'Miembro desde';
  String get estadisticas => locale.languageCode == 'en' ? 'Statistics' : 'Estadísticas';
  String get completadas => locale.languageCode == 'en' ? 'Completed' : 'Completadas';
  String get vencidas => locale.languageCode == 'en' ? 'Overdue' : 'Vencidas';
  String get totalEstadisticas => locale.languageCode == 'en' ? 'Total' : 'Total';
  String get cuenta => locale.languageCode == 'en' ? 'Account' : 'Cuenta';
  String get editarNombre => locale.languageCode == 'en' ? 'Edit name' : 'Editar nombre';
  String get escribeNombre => locale.languageCode == 'en' ? 'Write your name' : 'Escribe tu nombre';
  String get cancelar => locale.languageCode == 'en' ? 'Cancel' : 'Cancelar';
  String get guardar => locale.languageCode == 'en' ? 'Save' : 'Guardar';
  String get tuNombre => locale.languageCode == 'en' ? 'Your name' : 'Tu nombre';
  String get noDefinido => locale.languageCode == 'en' ? 'Not defined' : 'No definido';
  String get seleccionarImagen => locale.languageCode == 'en' ? 'Select image' : 'Seleccionar imagen';
  String get galeria => locale.languageCode == 'en' ? 'Gallery' : 'Galería';
  String get camara => locale.languageCode == 'en' ? 'Camera' : 'Cámara';
  String get usuario => locale.languageCode == 'en' ? 'User' : 'Usuario';

  // Alert screen
  String get recordatorioActivo => locale.languageCode == 'en' ? 'Active reminder' : 'Recordatorio activo';
  String get tiempoCumplido => locale.languageCode == 'en' ? 'Time completed!' : '¡Tiempo cumplido!';
  String get noPuedesSalir => locale.languageCode == 'en' ? "You can't leave until the counter ends" : 'No puedes salir hasta que termine el contador';
  String get yaPuedesSalir => locale.languageCode == 'en' ? 'You can now leave or take action' : 'Ya puedes salir o tomar acción';
  String get completarTarea => locale.languageCode == 'en' ? 'Complete task' : 'Completar tarea';
  String get realizandoTarea => locale.languageCode == 'en' ? "I'm doing the task" : 'Estoy realizando la tarea';
  String get posponer => locale.languageCode == 'en' ? 'Snooze' : 'Posponer';
  String get salidaDisponible => locale.languageCode == 'en' ? 'Exit available in' : 'Salida disponible en';
  String get espera => locale.languageCode == 'en' ? 'Wait' : 'Espera';
  String get paraSalir => locale.languageCode == 'en' ? 's to leave' : 's para poder salir';
  String get vencida => locale.languageCode == 'en' ? 'Overdue' : 'Vencida';
  String get venceEn => locale.languageCode == 'en' ? 'Due in' : 'Vence en';
  String get dias => locale.languageCode == 'en' ? 'days' : 'días';
  String get min => locale.languageCode == 'en' ? 'min' : 'min';
  String get cada => locale.languageCode == 'en' ? 'Every' : 'Cada';

  // About
  String get acercaDe => locale.languageCode == 'en' ? 'About' : 'Acerca de';
  String get version => locale.languageCode == 'en' ? 'Version' : 'Versión';
  String get descripcionApp => locale.languageCode == 'en' ? 'Reminder: No Escape is a reminder that refuses to be ignored. Alerts appear full screen relentlessly until you complete the task or the time runs out.' : 'Reminder: No Escape es un recordatorio que no acepta ser ignorado. Las alertas aparecen en pantalla completa de forma insistente hasta que completes la tarea o se agote el tiempo límite.';
  String get comoFunciona => locale.languageCode == 'en' ? 'How it works' : 'Cómo funciona';
  String get alertasPantalla => locale.languageCode == 'en' ? 'Full screen alerts' : 'Alertas en pantalla completa';
  String get alertasPantallaDesc => locale.languageCode == 'en' ? 'Each reminder takes full control of the screen for the time you set.' : 'Cada recordatorio toma control total de la pantalla por el tiempo que definas.';
  String get repeticion => locale.languageCode == 'en' ? 'Insistent repetition' : 'Repetición insistente';
  String get repeticionDesc => locale.languageCode == 'en' ? 'If you close the alert, it returns according to the interval you configured (30s, 1min, 5min…).' : 'Si cierras la alerta, vuelve según el intervalo que hayas configurado (30s, 1min, 5min…).';
  String get modoPausa => locale.languageCode == 'en' ? '"Doing task" mode' : 'Modo "Realizando tarea"';
  String get modoPausaDesc => locale.languageCode == 'en' ? 'Activates a temporary pause so it doesn\'t interrupt you while working on it.' : 'Activa una pausa temporal para que no te interrumpa mientras trabajas en ello.';
  String get unaSalida => locale.languageCode == 'en' ? 'Single exit' : 'Una sola salida';
  String get unaSalidaDesc => locale.languageCode == 'en' ? 'Only by completing the task or reaching the time limit do the alerts stop.' : 'Solo completando la tarea o al vencer el tiempo límite se detienen las alertas.';
  String get anticipacion => locale.languageCode == 'en' ? 'Anticipation' : 'Anticipación';
  String get anticipacionDesc => locale.languageCode == 'en' ? 'Set how far in advance you want reminders to start before each task\'s deadline.' : 'Configura con cuánta anticipación quieres que empiecen los recordatorios antes del tiempo límite de cada tarea.';
  String get hechoCon => locale.languageCode == 'en' ? 'Made with ♥ so you never forget anything' : 'Hecho con ♥ para que no olvides nada';
  String get sinHistorial => locale.languageCode == 'en' ? 'No history yet' : 'Sin historial aún';
  String get sinHistorialDesc => locale.languageCode == 'en' ? 'Completed or overdue tasks will appear here' : 'Las tareas completadas o vencidas aparecerán aquí';
  String get organizaAhora => locale.languageCode == 'en' ? 'Organize now, meet on time' : 'Organiza ahora, cumple a tiempo';
  String get organizaAhoraDesc => locale.languageCode == 'en' ? 'Add your tasks and receive constant reminders to ensure you complete them before the deadline.' : 'Añade tus tareas y recibe recordatorios constantes para asegurarte de completarlas antes del límite.';

  // Task detail
  String get detalleRecordatorio => locale.languageCode == 'en' ? 'Reminder detail' : 'Detalle del recordatorio';
  String get titulo => locale.languageCode == 'en' ? 'Title' : 'Título';
  String get descripcionTarea => locale.languageCode == 'en' ? 'Description' : 'Descripción';
  String get fechaLimite => locale.languageCode == 'en' ? 'Deadline' : 'Fecha límite';
  String get inicioRecordatorio => locale.languageCode == 'en' ? 'Reminder start' : 'Inicio de recordatorio';
  String get intervalo => locale.languageCode == 'en' ? 'Interval' : 'Intervalo';
  String get opcional => locale.languageCode == 'en' ? '(optional)' : '(opcional)';

  // Add task
  String get nuevoRecordatorio => locale.languageCode == 'en' ? 'New reminder' : 'Nuevo recordatorio';
  String get guardarRecordatorio => locale.languageCode == 'en' ? 'Save reminder' : 'Guardar recordatorio';
  String get completarCampos => locale.languageCode == 'en' ? 'Complete all required fields' : 'Completa todos los campos requeridos';
  String get anticipacionNoPuedeSer => locale.languageCode == 'en' ? 'Anticipation cannot be after the deadline' : 'La anticipación no puede ser después de la fecha límite';
  String get intervaloNoCero => locale.languageCode == 'en' ? 'Reminder interval cannot be 0' : 'El intervalo del recordatorio no puede ser 0';
  String get fechaDate => locale.languageCode == 'en' ? 'Date *' : 'Fecha *';
  String get horaTime => locale.languageCode == 'en' ? 'Time *' : 'Hora *';
  String get intervaloRecordatorio => locale.languageCode == 'en' ? 'Reminder interval' : 'Intervalo del recordatorio';
  String get intervaloDesc => locale.languageCode == 'en' ? 'How often will the reminder be shown on screen?' : '¿Cada cuanto tiempo se mostrará el recordatorio en pantalla?';
  String get horas => locale.languageCode == 'en' ? 'Hours' : 'Horas';
  String get minutos => locale.languageCode == 'en' ? 'Minutes' : 'Minutos';

  // Evaluation
  String get evaluacion => locale.languageCode == 'en' ? 'Evaluation' : 'Evaluación';
  String get instruccionesEval => locale.languageCode == 'en' ? 'Answer all questions with stars and then press Send to share your evaluation.' : 'Responde todas las preguntas con estrellas y luego presiona Enviar para compartir tu evaluación.';
  String get enviarEvaluacion => locale.languageCode == 'en' ? 'Send evaluation' : 'Enviar evaluación';
  String get responderTodas => locale.languageCode == 'en' ? 'Answer all questions to be able to send' : 'Responde todas las preguntas para poder enviar';
  String get cumplida => locale.languageCode == 'en' ? 'Completed' : 'Cumplida';
  String get noCumplida => locale.languageCode == 'en' ? 'Not completed' : 'No cumplida';

  // Empty state
  String get sinTareas => locale.languageCode == 'en' ? 'No pending tasks' : 'No tienes tareas pendientes';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}