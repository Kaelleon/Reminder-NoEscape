import 'package:flutter/material.dart';

class PendingTasksScreen extends StatelessWidget 
{
  const PendingTasksScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Center
    (
      child: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            //imagen central
            Image.asset("assets/images/empty.png", height: 150),
            const SizedBox(height: 30),
            //texto principal
            const Text
            (
              "Organiza ahora, cumple a tiempo",
              textAlign: TextAlign.center,
              style: TextStyle
              (
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 15),

            //texto secundario
            const Text
            (
              "Añade tus tareas y recibe recordatorios constantes para asegurarte de completarlas antes del límite.",
              textAlign: TextAlign.center,
              style: TextStyle
              (
                fontSize: 16,
                color: Color.fromARGB(179, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}