import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './theme/my_themes.dart';
import './widgets/vertical_ruler.dart';
import './widgets/horizontal_ruler.dart';
import './widgets/sliders.dart';
import './widgets/ruler_origin.dart';
import './widgets/custom_drawer.dart';
import './providers/ui_theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UiThemeProvider uiThemeProvider = UiThemeProvider();

  ThemeData themeProvider(String value) {
    switch (value) {
      case 'dark':
        {
          return MyThemes.darkTheme;
        }
      default:
        {
          return MyThemes.lightTheme;
        }
    }
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UiThemeProvider(),
      child: Consumer<UiThemeProvider>(
          builder: ((context, uiMode, _) => MaterialApp(
                title: 'Ruler',
                theme: themeProvider(uiMode.uiMode),
                darkTheme: uiMode.uiMode == 'ui'
                    ? MyThemes.darkTheme
                    : null,
                home: const MyHomePage(title: 'Ruler'),
              ))),
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
    int numberOfVerticalRulerPins =
        ((height - appBarHeight - paddingBottom - paddingTop) / pixelCountInMm)
            .floor();

    // Now calculate available width for horizontal ruler
    double width = MediaQuery.of(context).size.width;
    double paddingLeft = MediaQuery.of(context).padding.left;
    double paddingRight = MediaQuery.of(context).padding.right;
    int numberOfHorizontalRulerPins =
        ((width - paddingLeft - paddingRight) / pixelCountInMm).floor();

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Ruler')),
      body: Stack(children: <Widget>[
        VerticalRuler(
          numberOfVerticalRulerPins: numberOfVerticalRulerPins,
          pixelCountInMm: pixelCountInMm,
        ),
        HorizontalRuler(
          numberOfHorizontalRulerPins: numberOfHorizontalRulerPins,
          pixelCountInMm: pixelCountInMm,
        ),
        RulerOrigin(pixelCountInMm: pixelCountInMm),
        Sliders(
            sliderHeight: height - appBarHeight - paddingBottom - paddingTop,
            sliderWidth: width - paddingLeft - paddingRight,
            pixelCountInMm: pixelCountInMm,
            width: width - paddingLeft - paddingRight,
            height: height - appBarHeight - paddingBottom - paddingTop)
      ]),
      drawer: const CustomDrawer(),
    );
  }
}
