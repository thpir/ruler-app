import 'package:flutter/material.dart';

class VerticalRuler extends StatelessWidget {
  const VerticalRuler({
    Key? key,
    required this.numberOfVerticalRulerPins,
    required this.pixelCountInMm,
    required this.isMm,
  }) : super(key: key);

  final int numberOfVerticalRulerPins;
  final double pixelCountInMm;
  final bool isMm;

  @override
  Widget build(BuildContext context) {
    // rulerPinWidth method returns the size of the ruler pin. If the ruler pin is a
    //full cm/inch that pin will have to be larger that a ruler pin indicating
    //a value in between two centimeters/inches
    double rulerPinWidth(int index) {
      if (isMm) {
        if (index < 9) {
          return 0;
        } else if ((index + 1) % 10 == 0) {
          return pixelCountInMm * 6;
        } else {
          return pixelCountInMm * 3;
        }
      } else {
        if (index < 3) {
          return 0;
        } else if ((index + 1) % 8 == 0) {
          return (pixelCountInMm * 8 / 25.4) * 6;
        } else if ((index + 1) % 2 == 0) {
          return (pixelCountInMm * 8 / 25.4) * 4.5;
        } else {
          return (pixelCountInMm * 8 / 25.4) * 3;
        }
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
                color: Theme.of(context).focusColor,
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
          height: isMm 
            ? (index == 0 ? pixelCountInMm * 12 : pixelCountInMm * 10) 
            : (index == 0 ? pixelCountInMm * 8.6 : pixelCountInMm * 8),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                isMm ? (index > 0 ? (index + 1).toString() : '') : (index + 1).toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).focusColor,
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
                verticalRulerDigits((numberOfVerticalRulerPins / (isMm ? 10 : 8)).floor()),
          ),
        ],
      ),
    );
  }
}
