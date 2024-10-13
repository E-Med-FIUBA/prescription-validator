import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        BottomNavigationBar(
          backgroundColor: colorScheme.surfaceContainer,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Actividad',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 0), // Placeholder for QR code
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Beneficios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Más',
            ),
          ],
          currentIndex: selectedIndex, // Adjust for QR code
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            onItemTapped(index);
          },
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        Positioned(
          bottom: 10, // Adjust this value to position the QR code button
          child: GestureDetector(
            onTap: () => onItemTapped(2),
            child: Stack(alignment: Alignment.center, children: [
              Container(
                  width: 75, // Enlarged size
                  height: 75, // Enlarged size
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceDim,
                    shape: BoxShape.circle,
                  )),
              Container(
                width: 65, // Enlarged size
                height: 65, // Enlarged size
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Icon(Icons.qr_code_2,
                        color: colorScheme.onInverseSurface, size: 45)),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
