import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'themes/app_theme.dart';
import 'controllers/ui_mode_controller.dart';
import 'controllers/metrics_controller.dart';
import 'controllers/calibration_controller.dart';
import 'controllers/measurement_controller.dart';
import 'views/screens/calibration_screen.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/measurement_list_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    ThemeData themeProvider(String value) {
      if (value == 'dark') {
        return AppTheme.darkTheme;
      } else {
        return AppTheme.lightTheme;
      }
    }

    // set json file directory for languages
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiModeController>(
          create: (_) => UiModeController(),
        ),
        ChangeNotifierProvider<MetricsController>(
          create: (_) => MetricsController(),
        ),
        ChangeNotifierProvider<CalibrationController>(
          create: (_) => CalibrationController(),
        ),
        ChangeNotifierProvider<MeasurementController>(
          create: (_) => MeasurementController(),
        ),
      ],
      child: Consumer<UiModeController>(
        builder: (context, uiModeController, _) => MaterialApp(
          title: 'Ruler',
          color: Colors.amber,
          theme: themeProvider(uiModeController.uiMode),
          darkTheme:
              uiModeController.uiMode == 'ui' ? AppTheme.darkTheme : null,
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
          home: const HomeScreen(),
          routes: {
            CalibrationScreen.routeName: (ctx) => 
                const CalibrationScreen(),
            MeasurementListScreen.routeName: (context) =>
                const MeasurementListScreen(),
          },
        ),
      ),
    );
  }
}
