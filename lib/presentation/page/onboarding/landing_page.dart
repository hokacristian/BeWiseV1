import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/presentation/page/auth/login_page.dart';


class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildPage(
                svgPath: 'assets/img/landingpage1.svg', // Path ke SVG untuk halaman pertama
                context: context,
              ),
              _buildPage(
                svgPath: 'assets/img/landingpage2.svg', // Path ke SVG untuk halaman kedua
                context: context,
              ),
              _buildPageWithButton(
                svgPath: 'assets/img/landingpage3.svg', // Path ke SVG untuk halaman ketiga
                buttonText: "Mulai Sekarang",
                onButtonPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          // Tombol Lewati yang muncul di halaman 1 dan 2
          if (_currentPage < 2)
            Positioned(
              top: 40.0,
              right: 20.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Lewati",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Indikator Halaman di bagian bawah
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentPage == index ? 16.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.teal : Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String svgPath,
    required BuildContext context,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildPageWithButton({
    required String svgPath,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 100.0,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Poppins', // Menggunakan font Poppins
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue, // Warna latar belakang tombol
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                textStyle: TextStyle(fontSize: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Membuat tombol berbentuk melengkung
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
