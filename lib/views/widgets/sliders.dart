import 'package:flutter/material.dart';
import 'package:ruler_app/views/widgets/custom_slider.dart';

class Sliders extends StatefulWidget {
  final double sliderHeight;
  final double sliderWidth;
  final double pixelCountInMm;
  final double width;
  final double height;
  final bool isMm;
  const Sliders({
    Key? key,
    required this.sliderHeight,
    required this.sliderWidth,
    required this.pixelCountInMm,
    required this.width,
    required this.height,
    required this.isMm,
  }) : super(key: key);

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomSlider(
        valueChangedHorizontally: (value) {
          setState(() {});
        },
        valueChangedVertically: (value) {
          setState(() {});
        },
        sliderHeight: widget.sliderHeight,
        availableWidthInMm: (widget.width - 50) /
            (widget.isMm ? widget.pixelCountInMm : widget.pixelCountInMm * 8),
        sliderWidth: widget.sliderWidth,
        availableHeightInMm: (widget.height - 50) /
            (widget.isMm ? widget.pixelCountInMm : widget.pixelCountInMm * 8),
        isMm: widget.isMm,
      ),
    );
  }
}

