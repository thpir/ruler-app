import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './theme/my_themes.dart';
import './providers/ui_theme_provider.dart';
import './providers/metrics_provider.dart';
import './providers/calibration_provider.dart';
import './providers/database_provider.dart';
import './screens/calibration_screen.dart';
import './screens/home_screen.dart';
import './screens/measurement_list_screen.dart';

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
    // set json file directory for languages
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiThemeProvider>(
          create: (_) => UiThemeProvider(),
        ),
        ChangeNotifierProvider<MetricsProvider>(
          create: (_) => MetricsProvider(),
        ),
        ChangeNotifierProvider<CalibrationProvider>(
          create: (_) => CalibrationProvider(),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
      ],
      child: Consumer<UiThemeProvider>(
        builder: (context, uiMode, _) => MaterialApp(
          title: 'Ruler',
          theme: themeProvider(uiMode.uiMode),
          darkTheme: uiMode.uiMode == 'ui' ? MyThemes.darkTheme : null,
          localizationsDelegates: [
            // delegate from flutter_localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // delegate from localization package.
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('nl', 'BE'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }

              // default language
              return const Locale('en', 'US');
          },
          home: Consumer2<MetricsProvider, CalibrationProvider>(
            builder: (context, metrics, calibrationMode, _) => HomeScreen(
              title: 'app_name'.i18n(),
              isMm: isMm(metrics.metrics),
              isDefaultCalibration:
                  isDefaultCalibration(calibrationMode.calibrationMode),
              calibrationValue: calibrationMode.calibrationValue,
            ),
          ),
          routes: {
            CalibrationScreen.routeName: (ctx) => const CalibrationScreen(),
            MeasurementListScreen.routeName: (context) =>
                const MeasurementListScreen(),
          },
        ),
      ),
    );
  }

  /*
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
                      MeasurementListScreen.routeName:(context) => 
                        const MeasurementListScreen(),
                    },
                ),  
              ),
            ),
          ),
        ),
      ),
    );
  }
  */
}
