import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class SNumPadButton extends StatelessWidget {
  late int digit;
  late bool isSelect, lockButton;
  late VoidCallback voidCallback;
  late Color textColor;

  SNumPadButton({required this.digit, required this.isSelect,
      required this.voidCallback, required this.lockButton,super.key});


  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100)
      ),
      child: AbsorbPointer(
        absorbing: lockButton,
        child: AnimatedButton(
          borderWidth: 2,
          borderColor: Color(0xff005784),
          borderRadius: 100,
          width: MediaQuery.of(context).size.height*0.08,
          height: MediaQuery.of(context).size.height*0.08,
          text: digit.toString(),
          selectedTextColor: Colors.white,
          animatedOn: AnimatedOn.onHover,
          animationDuration: Duration( milliseconds: 600),
          isReverse: true,
          isSelected: isSelect,
          selectedBackgroundColor: Color(0xff005784),
          backgroundColor: Color(0xffc1e7f8),
          transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
          textStyle: TextStyle(
              fontSize: 28,
              letterSpacing: 5,
              color: Color(0xff005784),
              fontWeight: FontWeight.w500), onPress: voidCallback,
        ),
      ),
    );
  }
}
