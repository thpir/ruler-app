import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:ruler_app/controllers/calibration_controller.dart';
import 'package:ruler_app/controllers/metrics_controller.dart';
import 'package:ruler_app/controllers/ui_mode_controller.dart';

import '../widgets/vertical_ruler.dart';
import '../widgets/horizontal_ruler.dart';
import '../widgets/sliders.dart';
import '../widgets/ruler_origin.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_about_dialog.dart';
import 'measurement_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _dpi = 160;
  String errorMessage = '';
  static const platform = MethodChannel('thpir/dpi');

  /// This method will use platform specific code to try to retrieve the phone's
  /// DPI from the Android OS. Normally every android phone should allow the app
  /// to access this. In case it doesn't work for some reason, we will use a
  /// default value and notify the user to advice him to calibrate the ruler.
  Future<void> _getPhoneDpi() async {
    double dpi;
    try {
      final double result = await platform.invokeMethod('getPhoneDpi');
      dpi = result;
    } on PlatformException catch (e) {
      dpi = 160;
      errorMessage = e.toString();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(showErrorMessage(errorMessage));
    } catch (e) {
      dpi = 160;
      errorMessage = e.toString();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(showErrorMessage(errorMessage));
    }
    setState(() {
      _dpi = dpi;
    });
  }

  SnackBar showErrorMessage(String message) {
    return SnackBar(
      content: Text(
        message + 'error_message_calibration'.i18n(),
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  Future<void> _showAboutDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          CustomAboutDialog customAboutDialog = CustomAboutDialog();
          return customAboutDialog.getDialog(context);
        });
  }

  @override
  void initState() {
    super.initState();
    _getPhoneDpi();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UiModeController, CalibrationController,
            MetricsController>(
        builder: (context, uiModeController, calibrationController,
            metricsController, _) {
      // Necessary calculations to render an actual mm or inch on the screen.
      double pixelRatio = MediaQuery.of(context)
          .devicePixelRatio; // = How many physical pixels for 1 logical pixel
      double dpiFixed =
          _dpi; // dpi = acquired by android code if not returned we use 160 with devicePixelRatio = 1
      double pixelCountInMm = calibrationController.calibrationMode ==
              'default' // widget.isDefaultCalibration
          ? dpiFixed / pixelRatio / 25.4
          : calibrationController
              .calibrationValue; // = How many logical pixels in 1 mm
      double pixelCountInInches =
          calibrationController.calibrationMode == 'default'
              ? dpiFixed / pixelRatio / 8
              : calibrationController.calibrationValue *
                  25.4 /
                  8; // = How many logical pixels in 1/8 inch

      // Now calculate available height for vertical ruler
      double height = MediaQuery.of(context).size.height;
      double paddingTop = MediaQuery.of(context).padding.top;
      double paddingBottom = MediaQuery.of(context).padding.bottom;
      double appBarHeight = AppBar().preferredSize.height;
      // We subtract 1 from the height to avoid the bottom overflow error
      int numberOfVerticalRulerPins =
          metricsController.metrics == 'mm' //widget.isMm
              ? ((height - appBarHeight - paddingBottom - paddingTop - 1) /
                      pixelCountInMm)
                  .floor()
              : ((height - appBarHeight - paddingBottom - paddingTop - 1) /
                      pixelCountInInches)
                  .floor();

      // Now calculate available width for horizontal ruler
      double width = MediaQuery.of(context).size.width;
      double paddingLeft = MediaQuery.of(context).padding.left;
      double paddingRight = MediaQuery.of(context).padding.right;
      // We subtract 1 from the width to avoid the right overflow error
      int numberOfHorizontalRulerPins = metricsController.metrics ==
              'mm' //widget.isMm
          ? ((width - paddingLeft - paddingRight - 1) / pixelCountInMm).floor()
          : ((width - paddingLeft - paddingRight - 1) / pixelCountInInches)
              .floor();

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('app_name'.i18n(),
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MeasurementListScreen.routeName);
              },
              icon: const Icon(
                Icons.history_sharp,
              ),
            ),
            IconButton(
              onPressed: _showAboutDialog,
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Consumer<UiModeController>(
              builder: (context, controller, _) => Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    image: DecorationImage(
                        image: AssetImage(controller.checkIfLightOrDark(context)
                            ? 'assets/images/background_toolbox_dark.png'
                            : 'assets/images/background_toolbox.png'),
                        fit: BoxFit.cover)),
              ),
            ),
            VerticalRuler(
              numberOfVerticalRulerPins: numberOfVerticalRulerPins,
              pixelCountInMm: metricsController.metrics == 'mm'
                  ? pixelCountInMm
                  : pixelCountInInches,
              isMm: metricsController.metrics == 'mm' ? true : false,
            ),
            HorizontalRuler(
              numberOfHorizontalRulerPins: numberOfHorizontalRulerPins,
              pixelCountInMm: metricsController.metrics == 'mm'
                  ? pixelCountInMm
                  : pixelCountInInches,
              isMm: metricsController.metrics == 'mm' ? true : false,
            ),
            RulerOrigin(pixelCountInMm: pixelCountInMm),
            Sliders(
              sliderHeight: height - appBarHeight - paddingBottom - paddingTop,
              sliderWidth: width - paddingLeft - paddingRight,
              pixelCountInMm: metricsController.metrics == 'mm'
                  ? pixelCountInMm
                  : pixelCountInInches,
              width: width - paddingLeft - paddingRight,
              height: height - appBarHeight - paddingBottom - paddingTop,
              isMm: metricsController.metrics == 'mm' ? true : false,
            ),
          ],
        ),
        drawer: const CustomDrawer(),
      );
    });
  }
}
