import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

class VerticalSlider extends StatefulWidget {
  final double sliderWidth;
  final double pixelCountInMm;
  final double height;
  const VerticalSlider({
    Key? key,
    required this.sliderWidth,
    required this.pixelCountInMm,
    required this.height,
  }) : super(key: key);

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  @override
  Widget build(BuildContext context) {
    return CustomSlider(
      valueChanged: (value) {
        setState(() {});
      },
      sliderWidth: widget.sliderWidth,
      availableHeightInMm: (widget.height - 50) / widget.pixelCountInMm,
    );
  }
}

class CustomSlider extends StatefulWidget {
  final ValueChanged<double>? valueChanged;
  final double sliderWidth;
  final double availableHeightInMm;

  const CustomSlider({Key? key, this.valueChanged, required this.sliderWidth, required this.availableHeightInMm})
      : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ValueNotifier<double> valueListener = ValueNotifier(0.5);

  @override
  void initState() {
    super.initState();
    valueListener.addListener(notifyParent);
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged!(valueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: Builder(
        builder: ((context) {
          final handle = GestureDetector(
            onVerticalDragUpdate: ((details) {
              double newValue =
                  valueListener.value + details.delta.dy / context.size!.height;
              newValue = newValue.clamp(0.0, 1.0);
              valueListener.value = newValue;
              notifyParent();
            }),
            child: Container(
              alignment: Alignment.topRight,
              width: widget.sliderWidth,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  //color: SystemTheme.isDarkMode ? Colors.black : Colors.white,
                  border: Border.all(
                    width: 1,
                    color: SystemTheme.isDarkMode ? Colors.white : Colors.black,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${(valueListener.value * widget.availableHeightInMm).toStringAsFixed(0)} mm',
                    style: TextStyle(
                      fontSize: 20,
                      color: SystemTheme.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
          return AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(valueListener.value * 2 - 1, 0.5),
                child: child!,
              );
            },
            child: handle,
          );
        }),
      ),
    );
  }
}
