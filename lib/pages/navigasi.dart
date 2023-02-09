import 'package:absensi/common/my_color.dart';
import 'package:absensi/pages/about_page.dart';
import 'package:absensi/pages/profile_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:absensi/pages/home_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class Navigasi extends StatefulWidget {
  const Navigasi({Key? key}) : super(key: key);

  @override
  State<Navigasi> createState() => _NavigasiState();
}

class _NavigasiState extends State<Navigasi> {
  bool ActiveConnection = false;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AboutPage(),
    ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: MyColor.orange1,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: MyColor.orange1,
              hoverColor: MyColor.orange1,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: MyColor.orange1,
              color: Colors.white,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Beranda',
                ),
                GButton(
                  icon: FluentIcons.alert_20_regular,
                  text: 'Tentang',
                ),
                GButton(
                  icon: FluentIcons.person_20_regular,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
