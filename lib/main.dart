import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_theme/system_theme.dart';

import './theme/color_schemes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // add this line
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruler',
      /*theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(title: 'Ruler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      // Show snackbar with message to inform that manual calibration is needed
    } catch (e) {
      dpi = 160;
      errorMessage = e.toString();
      // Show snacbar with message to inform that manual calibration is needed
    }
    setState(() {
      _dpi = dpi;
    });
  }

  @override
  void initState() {
    _getPhoneDpi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context)
        .devicePixelRatio; // = How many physical pixels for 1 logical pixel
    double dpiFixed =
        _dpi; // dpi = ackquired by android code if not returned we use 160 with devicePixelRatio = 1
    double pixelCountInMm =
        dpiFixed / pixelRatio / 25.4; // = How many logical pixels in 1 mm

    // Now calculate available height for vertical ruler
    double height = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    double paddingBottom = MediaQuery.of(context).padding.bottom;
    double appBarHeight = AppBar().preferredSize.height;
    int numberOfRulerPins =
        ((height - appBarHeight - paddingBottom - paddingTop) / pixelCountInMm)
            .floor();

    // Now calculate available width for horizontal ruler
    double width = MediaQuery.of(context).size.width;
    double paddingLeft = MediaQuery.of(context).padding.left;
    double paddingRight = MediaQuery.of(context).padding.right;
    int numberOfHorizontalRulerPins =
        ((width - paddingLeft - paddingRight) / pixelCountInMm).floor();

    double rulerPinWidth(int index) {
      if (index < 9) {
        return 0;
      } else if ((index + 1) % 10 == 0) {
        return pixelCountInMm * 6;
      } else {
        return pixelCountInMm * 3;
      }
    }

    List<Container> horizontalRulerPin(int count) {
      return List.generate(count, (index) {
        return Container(
          width: pixelCountInMm,
          height: rulerPinWidth(index),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList();
    }

    List<Container> rulerPin(int count) {
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

    List<SizedBox> rulerDigits(int count) {
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

    List<SizedBox> horizontalRulerDigits(int count) {
      return List.generate(count, (index) {
        return SizedBox(
          width: index == 0 ? pixelCountInMm * 11 : pixelCountInMm * 10,
          child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
        );
      }).toList();
    }

    return Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Ruler')),
        body: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rulerPin(numberOfRulerPins),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Column(
                  children: rulerDigits((numberOfRulerPins / 10).floor()),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: horizontalRulerPin(numberOfHorizontalRulerPins),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Row(
                  children: horizontalRulerDigits((numberOfHorizontalRulerPins / 10).floor()),
                ),
              ],
            ),
          ),
          Container(
            width: 3 * pixelCountInMm,
            height: 3 * pixelCountInMm,
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(
                  color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
                  width: 1,
                  style: BorderStyle.solid),
              left: BorderSide(
                  color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
                  width: 1,
                  style: BorderStyle.solid),
            )),
          )
        ]));
  }
}
