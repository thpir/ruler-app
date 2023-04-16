import 'package:flutter/material.dart';

class RulerOrigin extends StatelessWidget {
  const RulerOrigin({
    Key? key,
    required this.pixelCountInMm,
  }) : super(key: key);

  final double pixelCountInMm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3 * pixelCountInMm,
      height: 3 * pixelCountInMm,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
            style: BorderStyle.solid),
        left: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
            style: BorderStyle.solid),
      )),
    );
  }
}