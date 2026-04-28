import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget
{
  const SettingsScreen ({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text("Configuracion")),
      body: const Center
      (
        child: Text("Pantalla de configuracion (desarrollo)"),
      ),
    );
  }
}