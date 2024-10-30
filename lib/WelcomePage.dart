import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/HomePage.dart';
import 'package:taletalk/PermissionsPage.dart';
import 'CustomClasses/WaveEffect.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  double next_btn_width = 70;
  int btnCount = 0;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
              OnboardingPage(
                title: 'AI-Powered Reply Suggestions',
                description: 'Effortless communication with instant, personalized reply options for every conversation',
                widget: Lottie.asset("assets/Lottie/chat.json"),
              ),
              OnboardingPage(
                title: 'Generate Images from Text',
                description: 'Turn your messages into captivating visuals with a single tap for engaging conversations.',
                widget: Lottie.asset("assets/Lottie/image_generation.json", height: screenHeight*0.47),
              ),
              OnboardingPage(
                title: 'Create Application Letters',
                description: 'Automatically generate a tailored, professional letter to your boss in just seconds.',
                widget: Lottie.asset("assets/Lottie/pdf_generation.json", height: screenHeight*0.47),
              ),
            ],
          ),
          // Dots indicator
          Positioned(
            bottom: screenHeight * 0.03, // 3% from the bottom of the screen
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01), // 1% margin horizontally
                  height: screenHeight * 0.01, // 1% of screen height
                  width: screenHeight * 0.01, // 1% of screen height for width too
                  decoration: BoxDecoration(
                    color:
                    _currentPage == index ? ColorCodes.blue1 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              }),
            ),
          ),
          // Navigation Buttons

          // Left Arrow Button
          Positioned(
            bottom: screenHeight * 0.08, // 8% from the bottom
            left: screenWidth * 0.05,    // 5% padding from the left
            right: screenWidth * 0.05,   // 5% padding from the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    // if count is >0 then only count value will decrease
                    if(btnCount>0){
                      btnCount--;
                    }

                    // Change the width (decrease)
                    setState(() {
                      next_btn_width=70;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorCodes.lightBlue,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Icon(Icons.arrow_back_ios),
                ),

                InkWell(
                  onTap: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);

                    // if count is <2 then only count value will increase
                    if(btnCount<2) {
                      btnCount++;
                    }
                    // Increase the width
                     if(btnCount==2){
                       setState(() {
                         next_btn_width = 130;
                       });
                     }

                     if(_currentPage==2){
                           Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionPage(),));
                     }

                  },

                  // Right Nexr Button
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: next_btn_width,
                    height: 40,
                    decoration: BoxDecoration(
                      color: btnCount==2?Color.fromARGB(255, 28, 79, 1):ColorCodes.blue1,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: btnCount==2?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Confirm", style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),),
                        ],
                      )
                          :const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                    )
                  ),
                ),


              ],
            ),
          ),

          // App Logo
          Positioned(
              bottom: screenHeight * 0.2, // 8% from the bottom
              left: screenWidth * 0.6,    // 5% padding from the left
              right: screenWidth * 0.05,   // 5% padding from the right
              child: AnimatedContainer(
                duration: Duration(microseconds: 800),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // Shadow color with opacity
                      spreadRadius: 10,  // How far the shadow spreads
                      blurRadius: 20,   // The amount of blur
                      offset: Offset(0, 4),  // The offset of the shadow (x, y)
                    ),
                  ],
                ),
                  child: Image.asset("assets/Icons/app_logo_remove_bg.png"))
          )
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget widget;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen height and width for responsiveness
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorCodes.blue1, ColorCodes.lightBlue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.1), // 10% height
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                          fontSize: screenHeight * 0.026, // 3% of screen height
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% height
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                      child: Text(
                        description,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: screenHeight * 0.019 // 2% of screen height
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.1), // 10% from bottom
                      child: widget,
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
