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
import './providers/metrics_provider.dart';

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
  MetricsProvider metricsProvider = MetricsProvider();

  ThemeData themeProvider(String value) {
    if (value == 'dark') {
      return MyThemes.darkTheme;
    } else {
      return MyThemes.lightTheme;
    }
  }

  bool isMm(String value) {
    if (value == 'mm') {
      return true;
    } else {
      return false;
    }
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UiThemeProvider(),
      child: Consumer<UiThemeProvider>(
        builder: ((context, uiMode, _) => ChangeNotifierProvider(
              create: (_) => MetricsProvider(),
              child: Consumer<MetricsProvider>(
                builder: (context, metrics, _) => MaterialApp(
                  title: 'Ruler',
                  theme: themeProvider(uiMode.uiMode),
                  darkTheme: uiMode.uiMode == 'ui' ? MyThemes.darkTheme : null,
                  home: MyHomePage(title: 'Ruler', isMm: isMm(metrics.metrics)),
                ),
              ),
            )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.isMm});

  final String title;
  final bool isMm;

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
    double pixelCountInInches =
        dpiFixed / pixelRatio / 8; // = How many logical pixels in 1/8 inch

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
      appBar: AppBar(elevation: 0, title: const Text('Ruler')),
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
