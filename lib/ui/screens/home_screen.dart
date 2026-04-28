import 'package:flutter/material.dart';
import 'package:reminder_noescape/ui/widgets/expandable_fab.dart';

class HomeScreen extends StatelessWidget
{
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(title: const Text("Reminder: No Escape"),),
      body: Center
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
              Image.asset
              (
                "assets/images/empty.png",
                height: 150,
              ),

              const SizedBox(height: 30,),

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
      ),

      floatingActionButton: ExpandableFab
      (
        distance: 110, 
        children: 
        [
          FloatingActionButton
          (
            heroTag: "create",
            mini: true,
            tooltip: "crear tareas",
            onPressed: ()
            {Navigator.pushNamed(context, '/createTask');},
            child: const Icon(Icons.edit),
          ),

          FloatingActionButton
          (
            heroTag: "history",
            mini: true,
            tooltip: "Historial",
            onPressed: ()
            {Navigator.pushNamed(context, '/history');},
            child: const Icon(Icons.history),
          ),

          FloatingActionButton
          (
            heroTag: "settings",
            mini: true,
            tooltip: "Configuracion",
            onPressed: ()
            {Navigator.pushNamed(context, '/settings');},
            child: const Icon(Icons.settings),
          ),

          FloatingActionButton
          (
            heroTag: "about",
            mini: true,
            tooltip: "Acerca de",
            onPressed: ()
            {Navigator.pushNamed(context, '/about');},
            child: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}