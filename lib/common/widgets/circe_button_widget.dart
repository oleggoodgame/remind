
import 'package:flutter/material.dart';

class CircleButtonWidget extends StatelessWidget {
  const CircleButtonWidget({
    required this.color,
    required this.icon,
    required this.onPressed,
    super.key,
  });
  final Color color;
  final IconData icon;

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Center(child: Icon(icon)),
        ),
      ),
    );
  }
}
