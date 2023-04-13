import 'package:system_theme/system_theme.dart';
import 'package:flutter/material.dart';

class VerticalRuler extends StatelessWidget {
  const VerticalRuler({
    Key? key,
    required this.numberOfVerticalRulerPins,
    required this.pixelCountInMm,
  }) : super(key: key);

  final int numberOfVerticalRulerPins;
  final double pixelCountInMm;

  @override
  Widget build(BuildContext context) {

    // rulerPinWidth method returns the size of the ruler pin. If the ruler pin is a 
    //full cm/inch that pin will have to be larger that a ruler pin indicating 
    //a value in between two centimeters/inches
    double rulerPinWidth(int index) {
      if (index < 9) {
        return 0;
      } else if ((index + 1) % 10 == 0) {
        return pixelCountInMm * 6;
      } else {
        return pixelCountInMm * 3;
      }
    }

    // This method returns a list of ruler pins that are rendered across the 
    //vertical axis of the phone screen
    List<Container> verticalRulerPin(int count) {
      return List.generate(count, (index) {
        return Container(
          height: pixelCountInMm,
          width: rulerPinWidth(index),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList();
    }

    // This method returns a list of digits that acompany the ruler pins 
    //rendered along the vertical axis of the phone
    List<SizedBox> verticalRulerDigits(int count) {
      return List.generate(count, (index) {
        return SizedBox(
          height: index == 0 ? pixelCountInMm * 12 : pixelCountInMm * 10,
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                index > 0 ? (index + 1).toString() : '',
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
        );
      }).toList();
    }

    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: verticalRulerPin(numberOfVerticalRulerPins),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Column(
            children:
                verticalRulerDigits((numberOfVerticalRulerPins / 10).floor()),
          ),
        ],
      ),
    );
  }
}
