import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';

class AddTaskSheet extends StatefulWidget
{
  final Function(Task) onTaskAdded;

  const AddTaskSheet({super.key, required this.onTaskAdded});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet>
{
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  //fecha limite
  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  //tiempo de anticipacion
  DateTime? _anticipationDate;
  TimeOfDay? _anticipationTime;

  //intervalo del recordatorio
  int _intervalHours = 0;
  int _intervalMinutes = 5;
  int _intervalSeconds = 0;

  Future<void> _pickDate({required bool isDue}) async
  {
    final date = await showDatePicker
    (
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null)
    {
      setState(() 
      {
        if (isDue)
        {
          _dueDate = date;
        }

        else
        {
          _anticipationDate = date;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isDue}) async
  {
    final time = await showTimePicker
    (
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null)
    {
      setState(() 
      {
        if (isDue)
        {
          _dueTime = time;
        }

        else
        {
          _anticipationTime = time;
        }
      });
    }
  }

  String _formatDate(DateTime? date)
  {
    if (date == null) return "Fecha *";
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatTime(TimeOfDay? time) 
  {
    if (time == null) return "Hora *";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  void _submit() 
  {
    if (_titleController.text.trim().isEmpty ||
    _dueDate == null ||
    _dueTime == null ||
    _anticipationDate == null ||
    _anticipationTime == null) 
    {
        ScaffoldMessenger.of(context).showSnackBar
      (
        const SnackBar(content: Text("Completa todos los campos requeridos")),
      );
      return;
    }

    final dueDate = DateTime
    (
      _dueDate!.year,
      _dueDate!.month,
      _dueDate!.day,
      _dueTime!.hour,
      _dueTime!.minute,
    );

    final anticipationTime = DateTime
    (
      _anticipationDate!.year,
      _anticipationDate!.month,
      _anticipationDate!.day,
      _anticipationTime!.hour,
      _anticipationTime!.minute,
    );

    if (anticipationTime.isAfter(dueDate)) 
    {
      ScaffoldMessenger.of(context).showSnackBar
      (
        const SnackBar
        (
          content: Text("La anticipación no puede ser después de la fecha límite"),
        ),
      );
      return;
    }

    final reminderInterval = Duration
    (
      hours: _intervalHours,
      minutes: _intervalMinutes,
      seconds: _intervalSeconds,
    );

    if (reminderInterval.inSeconds == 0) 
    {
      ScaffoldMessenger.of(context).showSnackBar
      (
        const SnackBar(content: Text("El intervalo del recordatorio no puede ser 0")),
      );
      return;
    }

    widget.onTaskAdded(Task
    (
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dueDate: dueDate,
      anticipationTime: anticipationTime,
      reminderInterval: reminderInterval,
    ));

    Navigator.pop(context);
  }

  Widget _buildDateTimeRow
  ({
    required String sectionLabel,
    required DateTime? date,
    required TimeOfDay? time,
    required bool isDue,
  })

  {
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Text
        (
          sectionLabel,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 8),
        Row
        (
          children: 
          [
            Expanded
            (
              child: OutlinedButton.icon
              (
                onPressed: () => _pickDate(isDue: isDue),
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatDate(date)),
                style: OutlinedButton.styleFrom
                (
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),
            Expanded
            (
              child: OutlinedButton.icon
              (
                onPressed: () => _pickTime(isDue: isDue),
                icon: const Icon(Icons.access_time),
                label: Text(_formatTime(time)),
                style: OutlinedButton.styleFrom
                (
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntervalField
  ({
    required String label,
    required int value,
    required int max,
    required Function(int) onChanged,
  }) 

  {
    return Column
    (
      children: 
      [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container
        (
          width: double.infinity,
          decoration: BoxDecoration
          (
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: 
            [
              InkWell
              (
                onTap: value > 0 ? () => onChanged(value - 1) : null,
                borderRadius: BorderRadius.circular(12),
                child: const Padding
                (
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.remove, size: 18),
                ),
              ),

              Text
              (
                value.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              InkWell
              (
                onTap: value < max ? () => onChanged(value + 1) : null,
                borderRadius: BorderRadius.circular(12),
                child: const Padding
                (
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: EdgeInsets.only
      (
        left: 24,
        right: 24,
        top: 24,
        bottom: 24,
      ),

      child: Column
      (
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          Center
          (
            child: Container
            (
              width: 40, height: 4,
              decoration: BoxDecoration
              (
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text
          (
            "Nuevo recordatorio",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          //titulo
          TextField
          (
            controller: _titleController,
            decoration: InputDecoration
            (
              labelText: "Título *",
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          //descripcion
          TextField
          (
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration
            (
              labelText: "Descripción (opcional)",
              prefixIcon: const Icon(Icons.notes),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          //fecha limite
          _buildDateTimeRow
          (
            sectionLabel: "Fecha limite", 
            date: _dueDate, 
            time: _dueTime, 
            isDue: true,
          ),
          const SizedBox(height: 16),

          //tiempo de anticipacion
          _buildDateTimeRow
          (
            sectionLabel: "Inicio de recordatorios", 
            date: _anticipationDate, 
            time: _anticipationTime, 
            isDue: false,
          ),
          const SizedBox(height: 16),

          //intervalo del recordatorio
          const Text
          (
            "Intervalo del recordatorio",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),

          const Text
          (
            "¿Cada cuanto tiempo se mostrará el recordatorio en pantalla?",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: 
            [
              SizedBox
              (
                width: 90,
                child: _buildIntervalField
                (
                  label: "Horas",
                  value: _intervalHours,
                  max: 23,
                  onChanged: (v) => setState(() => _intervalHours = v),
                ),
              ),

              const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox
              (
                width: 90,
                child: _buildIntervalField
                (
                  label: "Minutos",
                  value: _intervalMinutes,
                  max: 59,
                  onChanged: (v) => setState(() => _intervalMinutes = v),
                ),
              ),

              const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox
              (
                width: 90,
                child: _buildIntervalField
                (
                  label: "Segundos",
                  value: _intervalSeconds,
                  max: 59,
                  onChanged: (v) => setState(() => _intervalSeconds = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          //boton guardar
          SizedBox
          (
            width: double.infinity,
            child: FilledButton.icon
            (
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text("Guardar recordatorio"),
              style: FilledButton.styleFrom
              (
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}