import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bewise/presentation/page/home/home_page.dart';
import 'package:bewise/presentation/page/history/history_page.dart';
import 'package:bewise/presentation/page/information/information_page.dart';
import 'package:bewise/presentation/page/profile/profile_page.dart';
import 'package:bewise/presentation/page/scan/scan_product_page.dart';
import 'package:bewise/core/constans/colors.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    Container(), 
    InformationPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to ScanProductPage without bottom navbar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanProductPage()),
      );
    } else {
      // Normal navigation for other pages
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0), 
        child: FloatingActionButton(
          onPressed: () {
            _onItemTapped(2);
          },
          backgroundColor: AppColors.yellow,
          child: SvgPicture.asset(
            'assets/img/icon_scan.svg',
            color: AppColors.lightBlue,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                'assets/img/icon_home.svg',
                color: _selectedIndex == 0 ? AppColors.lightBlue: Color(0XFFBBC2CD),
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/img/icon_history.svg',
                color: _selectedIndex == 1 ? AppColors.lightBlue : Color(0XFFBBC2CD)),
              onPressed: () => _onItemTapped(1),
            ),
            SizedBox(
              width: 40), // This space is for the floating action button.
            IconButton(
              icon: SvgPicture.asset(
                'assets/img/icon_info.svg',
                color: _selectedIndex == 3 ? AppColors.lightBlue : Color(0XFFBBC2CD)),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/img/icon_person.svg',
                color: _selectedIndex == 4 ? AppColors.lightBlue : Color(0XFFBBC2CD)),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
