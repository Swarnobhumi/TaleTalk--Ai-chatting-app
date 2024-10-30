import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';

import 'NavPages/CallPage.dart';
import 'NavPages/MessagePage.dart';
import 'NavPages/SettingsPage.dart';
import 'NavPages/StatusPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final _pageController = PageController();






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorCodes.blue1,
        title: ValueListenableBuilder(
          valueListenable: StaticVariables.title,
          builder: (context, value, child) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: Offset(1.0, 0.0), // Slide in from the right
                        end: Offset(0.0, 0.0), // End at the center
                      ).animate(animation);

                      final fadeAnimation =
                          animation; // Use the same animation for fading

                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      value,
                      key: ValueKey<String>(value),
                      style: value == "TaleTalk"
                          ? GoogleFonts.pacifico(
                              textStyle:
                                  TextStyle(fontSize: 22, color: Colors.white))
                          : GoogleFonts.poppins(
                              color: Colors.white, fontSize: 22),
                    ),
                  ),
                  Row(
                    children: [
                      // Search Button
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                        color: Colors.white,
                      ),

                      // Camera Button
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined),
                        color: Colors.white,
                      ),

                      //Three Dot
                      IconButton(
                        onPressed: (){},
                        icon: SvgPicture.asset("assets/Svg/three_dot_svg.svg",
                            colorFilter:
                                ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            semanticsLabel: 'A red up arrow'),
                      ),
                    ],
                  )
                ]);
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          MessagePage(),
          StatusPage(),
          CallPage(),
          SettingsPage(),
        ],
        onPageChanged: (index) {
          if (index == 0) {
            StaticVariables.title.value = "TaleTalk";
          } else if (index == 1) {
            StaticVariables.title.value = "Updates";
          } else if (index == 2) {
            StaticVariables.title.value = "Calls";
          } else if (index == 3) {
            StaticVariables.title.value = "Settings";
          }
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        backgroundColor: Color(0xffc1e7f8),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.message),
            title: Text('Chat'),
            activeColor: Color(0xff005784),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.bookOpen),
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Stories'),
            ),
            activeColor: Color(0xff005784),
          ),
          BottomBarItem(
            icon: Icon(Icons.call),
            title: Text('Calls'),
            activeColor: Color(0xff005784),
          ),
          BottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Color(0xff005784),
          ),
        ],
      ),
    );
  }
}
