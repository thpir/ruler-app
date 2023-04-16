import 'package:flutter/material.dart';

class Sliders extends StatefulWidget {
  final double sliderHeight;
  final double sliderWidth;
  final double pixelCountInMm;
  final double width;
  final double height;
  const Sliders({
    Key? key,
    required this.sliderHeight,
    required this.sliderWidth,
    required this.pixelCountInMm,
    required this.width,
    required this.height,
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
        availableWidthInMm: (widget.width - 50) / widget.pixelCountInMm,
        sliderWidth: widget.sliderWidth,
        availableHeightInMm: (widget.height - 50) / widget.pixelCountInMm,
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  final ValueChanged<double>? valueChangedHorizontally;
  final ValueChanged<double>? valueChangedVertically;
  final double sliderHeight;
  final double sliderWidth;
  final double availableWidthInMm;
  final double availableHeightInMm;

  const CustomSlider(
      {Key? key,
      this.valueChangedHorizontally,
      this.valueChangedVertically,
      required this.sliderHeight,
      required this.sliderWidth,
      required this.availableWidthInMm,
      required this.availableHeightInMm})
      : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ValueNotifier<double> horizontalValueListener = ValueNotifier(0.5);
  ValueNotifier<double> verticalValueListener = ValueNotifier(0.5);

  @override
  void initState() {
    super.initState();
    horizontalValueListener.addListener(notifyParentForHorizontalMovement);
    verticalValueListener.addListener(notifyParentForVerticalMovement);
  }

  void notifyParentForHorizontalMovement() {
    if (widget.valueChangedHorizontally != null) {
      widget.valueChangedHorizontally!(horizontalValueListener.value);
    }
  }

  void notifyParentForVerticalMovement() {
    if (widget.valueChangedVertically != null) {
      widget.valueChangedVertically!(verticalValueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: widget.sliderHeight,
      width: widget.sliderWidth,
      child: Builder(
        builder: ((context) {
          final handleHorizontal = GestureDetector(
            onHorizontalDragUpdate: ((details) {
              double newValue = horizontalValueListener.value +
                  details.delta.dx / context.size!.width;
              newValue = newValue.clamp(0.0, 1.0);
              horizontalValueListener.value = newValue;
              notifyParentForHorizontalMovement();
            }),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: widget.sliderHeight,
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(0)} mm',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          final handleVertical = GestureDetector(
            onVerticalDragUpdate: ((details) {
              double newValue = verticalValueListener.value +
                  details.delta.dy / context.size!.height;
              newValue = newValue.clamp(0.0, 1.0);
              verticalValueListener.value = newValue;
              notifyParentForVerticalMovement();
            }),
            child: Container(
              alignment: Alignment.topRight,
              width: widget.sliderWidth,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(0)} mm',
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ),
          );

          return Stack(
            children: [
              AnimatedBuilder(
                animation: horizontalValueListener,
                builder: (context, child) {
                  return Align(
                    alignment:
                        Alignment(horizontalValueListener.value * 2 - 1, 0.5),
                    child: child!,
                  );
                },
                child: handleHorizontal,
              ),
              AnimatedBuilder(
                animation: verticalValueListener,
                builder: (context, child) {
                  return Align(
                    alignment:
                        Alignment(0.5, verticalValueListener.value * 2 - 1),
                    child: child!,
                  );
                },
                child: handleVertical,
              ),
            ],
          );
        }),
      ),
    );
  }
}
