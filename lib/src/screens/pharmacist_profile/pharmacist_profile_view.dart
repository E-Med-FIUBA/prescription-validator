import 'package:flutter/material.dart';

import '../../services/pharmacist/pharmacist.service.dart';
import 'pharmacist_profile_controller.dart';

class PharmacistProfileView extends StatelessWidget {
  const PharmacistProfileView({super.key, required this.controller});

  static const routeName = '/perfil';

  final PharmacistProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: FutureBuilder<Pharmacist>(
        future: controller.getPharmacist(), // Fetch the pharmacist data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final pharmacist = snapshot.data!;
            return Center(
              child: Card(
                margin: const EdgeInsets.all(32), // Increased margin
                child: Padding(
                  padding: const EdgeInsets.all(32), // Increased padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?name=${pharmacist.name}+${pharmacist.lastName}'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${pharmacist.name} ${pharmacist.lastName}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pharmacist.email,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'DNI: ${pharmacist.dni}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'License: ${pharmacist.license}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.logout();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
