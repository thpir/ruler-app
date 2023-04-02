import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
    double height = MediaQuery.of(context).size.width;
    double paddingTop = MediaQuery.of(context).padding.top;
    double paddingBottom = MediaQuery.of(context).padding.bottom;
    double appBarHeight = AppBar().preferredSize.height;
    int numberOfRulerPins =
        ((height - appBarHeight - paddingBottom - paddingTop) / pixelRatio)
            .floor();

    List<Container> rulerPin(int count) {
      return List.generate(count, (index) {
        return Container(
          height: pixelCountInMm,
          width: (index + 1) % 10 == 0
              ? (10 * pixelCountInMm)
              : (5 * pixelCountInMm),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black))),
        );
      }).toList();
    }

    List<SizedBox> rulerDigits(int count) {
      return List.generate(count, (index) {
        return SizedBox(
          height: index == 0 ? pixelCountInMm * 8 : pixelCountInMm * 10,
          child: index == 0 ? null : Text((index).toString(), style: const TextStyle(fontSize: 20),),
        );
      }).toList();
    }

    return Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Ruler')),
        body: Container(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rulerPin(numberOfRulerPins),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Column( 
                children: rulerDigits((numberOfRulerPins/10).ceil()),
              ),
            ],
          ),
        ));
  }
}
