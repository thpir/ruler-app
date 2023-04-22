import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './theme/my_themes.dart';
import './providers/ui_theme_provider.dart';
import './providers/metrics_provider.dart';
import './providers/calibration_provider.dart';
import './screens/calibration_screen.dart';
import './screens/home_screen.dart';

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
  CalibrationProvider calibrationProvider = CalibrationProvider();

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

  bool isDefaultCalibration(String value) {
    if (value == 'default') {
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
        builder: (context, uiMode, _) => ChangeNotifierProvider(
          create: (_) => MetricsProvider(),
          child: Consumer<MetricsProvider>(
            builder: (context, metrics, _) => ChangeNotifierProvider(
              create: (_) => CalibrationProvider(),
              child: Consumer<CalibrationProvider>(
                builder: (context, calibrationMode, _) => MaterialApp(
                  title: 'Ruler',
                    theme: themeProvider(uiMode.uiMode),
                    darkTheme:
                      uiMode.uiMode == 'ui' ? MyThemes.darkTheme : null,
                    home: HomeScreen(
                      title: 'Ruler',
                      isMm: isMm(metrics.metrics),
                      isDefaultCalibration: isDefaultCalibration(calibrationMode.calibrationMode),
                      calibrationValue: calibrationMode.calibrationValue,
                    ),
                    routes: {
                      CalibrationScreen.routeName: (ctx) =>
                        const CalibrationScreen(),
                    },
                ),  
              ),
            ),
          ),
        ),
      ),
    );
  }
}

