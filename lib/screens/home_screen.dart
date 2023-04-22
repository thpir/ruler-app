import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/vertical_ruler.dart';
import '../widgets/horizontal_ruler.dart';
import '../widgets/sliders.dart';
import '../widgets/ruler_origin.dart';
import '../widgets/custom_drawer.dart';
import '../shared_prefs/calibration_preference.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
    required this.isMm,
    required this.isDefaultCalibration,
    required this.calibrationValue,
  });

  final String title;
  final bool isMm;
  final bool isDefaultCalibration;
  final double calibrationValue;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _dpi = 160;
  String errorMessage = '';
  static const platform = MethodChannel('thpir/dpi');

  Future<void> _getPhoneDpi() async {
    double dpi;
    try {
      final double result = await platform.invokeMethod('getPhoneDpi');
      dpi = result;
    } on PlatformException catch (e) {
      dpi = 160;
      errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(showErrorMessage(errorMessage));
    } catch (e) {
      dpi = 160;
      errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(showErrorMessage(errorMessage));
    }
    setState(() {
      _dpi = dpi;
    });
  }

  SnackBar showErrorMessage(String message) {
    return SnackBar(
      content: Text(
        '$message. We advice to use a custom calibration...',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).errorColor,
    );
  }

  Future<double> getCalibrationValue() async {
    CalibrationPreference calibrationPreference = CalibrationPreference();
    return calibrationPreference.getCalibrationValue();
  }

  @override
  void initState() {
    super.initState();
    _getPhoneDpi();
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context)
        .devicePixelRatio; // = How many physical pixels for 1 logical pixel
    double dpiFixed =
        _dpi; // dpi = ackquired by android code if not returned we use 160 with devicePixelRatio = 1
    double pixelCountInMm = widget.isDefaultCalibration
        ? dpiFixed / pixelRatio / 25.4
        : widget.calibrationValue; // = How many logical pixels in 1 mm
    double pixelCountInInches = widget.isDefaultCalibration
        ? dpiFixed / pixelRatio / 8
        : widget.calibrationValue *
            25.4 /
            8; // = How many logical pixels in 1/8 inch

    // Now calculate available height for vertical ruler
    double height = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    double paddingBottom = MediaQuery.of(context).padding.bottom;
    double appBarHeight = AppBar().preferredSize.height;
    int numberOfVerticalRulerPins = widget.isMm
        ? ((height - appBarHeight - paddingBottom - paddingTop) /
                pixelCountInMm)
            .floor()
        : ((height - appBarHeight - paddingBottom - paddingTop) /
                pixelCountInInches)
            .floor();

    // Now calculate available width for horizontal ruler
    double width = MediaQuery.of(context).size.width;
    double paddingLeft = MediaQuery.of(context).padding.left;
    double paddingRight = MediaQuery.of(context).padding.right;
    int numberOfHorizontalRulerPins = widget.isMm
        ? ((width - paddingLeft - paddingRight) / pixelCountInMm).floor()
        : ((width - paddingLeft - paddingRight) / pixelCountInInches).floor();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Ruler',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Stack(children: <Widget>[
        VerticalRuler(
          numberOfVerticalRulerPins: numberOfVerticalRulerPins,
          pixelCountInMm: widget.isMm ? pixelCountInMm : pixelCountInInches,
          isMm: widget.isMm,
        ),
        HorizontalRuler(
          numberOfHorizontalRulerPins: numberOfHorizontalRulerPins,
          pixelCountInMm: widget.isMm ? pixelCountInMm : pixelCountInInches,
          isMm: widget.isMm,
        ),
        RulerOrigin(pixelCountInMm: pixelCountInMm),
        Sliders(
          sliderHeight: height - appBarHeight - paddingBottom - paddingTop,
          sliderWidth: width - paddingLeft - paddingRight,
          pixelCountInMm: widget.isMm ? pixelCountInMm : pixelCountInInches,
          width: width - paddingLeft - paddingRight,
          height: height - appBarHeight - paddingBottom - paddingTop,
          isMm: widget.isMm,
        )
      ]),
      drawer: const CustomDrawer(),
    );
  }
}