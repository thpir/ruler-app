import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';

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

class CustomSlider extends StatefulWidget {
  final ValueChanged<double>? valueChangedHorizontally;
  final ValueChanged<double>? valueChangedVertically;
  final double sliderHeight;
  final double sliderWidth;
  final double availableWidthInMm;
  final double availableHeightInMm;
  final bool isMm;

  const CustomSlider(
      {Key? key,
      this.valueChangedHorizontally,
      this.valueChangedVertically,
      required this.sliderHeight,
      required this.sliderWidth,
      required this.availableWidthInMm,
      required this.availableHeightInMm,
      required this.isMm})
      : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ValueNotifier<double> horizontalValueListener = ValueNotifier(0.5);
  ValueNotifier<double> verticalValueListener = ValueNotifier(0.5);
  var savedValue = '';

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

  void _addItem() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d, y');
    String formattedDate = formatter.format(now);
    Provider.of<DatabaseProvider>(context, listen: false).addMeasurement(
        savedValue,
        formattedDate);
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
              alignment: Alignment.bottomCenter,
              height: widget.sliderHeight,
              width: 50,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1,
                    //color: Theme.of(context).colorScheme.onSurface,
                    color: Colors.amber,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  //color: Theme.of(context).colorScheme.onSurface,
                  color: Colors.amber,
                  border: Border.all(
                    width: 1,
                    //color: Theme.of(context).colorScheme.onSurface,
                    color: Colors.amber,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.isMm
                              ? '${(horizontalValueListener.value * widget.availableWidthInMm + 0.2).toStringAsFixed(1)} mm'
                              : '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(2)} inch',
                          style: const TextStyle(
                            fontSize: 20,
                            //color: Theme.of(context).colorScheme.surface,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                            onPressed: (() {
                              savedValue = widget.isMm
                                  ? '${(horizontalValueListener.value * widget.availableWidthInMm + 0.2).toStringAsFixed(1)} mm'
                                  : '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(2)} inch';
                              _addItem();
                            }),
                            icon: const Icon(
                              Icons.save,
                              color: Colors.black,
                            )),
                      ],
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
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    //color: Theme.of(context).colorScheme.onSurface,
                    color: Colors.amber,
                  ),
                ),
              ),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  //color: Theme.of(context).colorScheme.onSurface,
                  color: Colors.amber,
                  border: Border.all(
                    width: 1,
                    //color: Theme.of(context).colorScheme.onSurface,
                    color: Colors.amber,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.isMm
                            ? '${(verticalValueListener.value * widget.availableHeightInMm + 0.2).toStringAsFixed(1)} mm'
                            : '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(2)} inch',
                        style: const TextStyle(
                          fontSize: 20,
                          //color: Theme.of(context).colorScheme.surface,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                            onPressed: (() {
                              savedValue = widget.isMm
                                ? '${(verticalValueListener.value * widget.availableHeightInMm + 0.2).toStringAsFixed(1)} mm'
                                : '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(2)} inch';
                              _addItem();
                            }),
                            icon: const Icon(
                              Icons.save,
                              color: Colors.black,
                            ))
                    ],
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
