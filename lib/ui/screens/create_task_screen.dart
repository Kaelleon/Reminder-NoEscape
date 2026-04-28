import 'package:flutter/material.dart';

class CreateTaskScreen extends StatelessWidget
{
  const CreateTaskScreen ({super.key});

  @override
  Widget build (BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text("Tareas")),
      body: const Center
      (
        child: Text("Pantalla de creacion de tareas (desarrollo)"),
      ),
    );
  }
}