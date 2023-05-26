import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/amd_history_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_pending/amd_pending_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/main_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/profile_page.dart';
import 'package:geolocalizacionamd/app/pages/widgets/common_widgets.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPage = 0;
  final screens = [
    const MainPage(),
    const AmdPendingPage(),
    const AmdHistoryPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade700,
        //selectedLabelStyle: const TextStyle(color: Colors.black),
        //unselectedLabelStyle: TextStyle(color: Colors.grey.shade700),
        //backgroundColor: const Color(0xffD84835),
        items: [
          BottomNavigationBarItem(
              label: 'Inicio',
              icon: currentPage == 0
                  ? const Icon(
                      Icons.home,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.home_outlined,
                      color: Colors.grey.shade700,
                    )),
          BottomNavigationBarItem(
              icon: currentPage == 1
                  ? const Icon(Icons.work_history, color: Colors.black)
                  : Icon(Icons.work_history_outlined,
                      color: Colors.grey.shade700),
              label: 'Atención'),
          BottomNavigationBarItem(
              icon: currentPage == 2
                  ? const Icon(Icons.note_add, color: Colors.black)
                  : Icon(Icons.note_add_outlined, color: Colors.grey.shade700),
              label: 'Historial'),
          BottomNavigationBarItem(
              icon: currentPage == 3
                  ? const Icon(Icons.person_pin, color: Colors.black)
                  : Icon(Icons.person_pin_outlined,
                      color: Colors.grey.shade700),
              label: 'Perfil')
        ],
      ),
    );
  }
}
