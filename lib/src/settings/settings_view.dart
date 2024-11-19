import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Muestra las diversas configuraciones que el usuario puede personalizar.
///
/// Cuando un usuario cambia una configuración, el SettingsController se actualiza y
/// los Widgets que escuchan al SettingsController se reconstruyen.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/configuraciones';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Configuraciones',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          // Vincula el SettingsController al DropdownButton de selección de tema.
          //
          // Cuando un usuario selecciona un tema de la lista desplegable, el
          // SettingsController se actualiza, lo que reconstruye el MaterialApp.
          child: DropdownButton<ThemeMode>(
            // Lee el themeMode seleccionado del controlador
            value: controller.themeMode,
            // Llama al método updateThemeMode cada vez que el usuario selecciona un tema.
            onChanged: controller.updateThemeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('Tema del Sistema'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Tema Claro'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Tema Oscuro'),
              )
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () => {controller.logout()},
            child: const Text('Cerrar sesión'))
      ],
    );
  }
}
