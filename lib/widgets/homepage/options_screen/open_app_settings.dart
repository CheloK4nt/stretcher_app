import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenAppSettings extends StatefulWidget {
  const OpenAppSettings({super.key});

  @override
  State<OpenAppSettings> createState() => _OpenAppSettingsState();
}

class _OpenAppSettingsState extends State<OpenAppSettings> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        "Ir a ajustes",
        style: TextStyle(
        fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: const Text(
        "Configuración de la app. Puedes configurar los permisos, entre otras opciones.",
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: MediaQuery.of(context).size.height * 0.05,
      ),
      onTap: () => openAppSettings(),
    );
  }
}