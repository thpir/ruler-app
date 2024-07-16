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
      width: 5 * pixelCountInMm,
      height: 5 * pixelCountInMm,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            color: Theme.of(context).focusColor,
            width: 1,
            style: BorderStyle.solid),
        left: BorderSide(
            color: Theme.of(context).focusColor,
            width: 1,
            style: BorderStyle.solid),
      )),
      child: Center(
        child: Text(
          '0',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).focusColor,
          ),
        ),
      ),
    );
  }
}