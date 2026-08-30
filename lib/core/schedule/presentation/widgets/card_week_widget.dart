import 'package:flutter/material.dart';

class CardWeekWidget extends StatelessWidget {
  const CardWeekWidget(this.name, this.dateTime, this.color, {super.key});

  final Color color;
  final DateTime dateTime;
  final String name;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.5),
        border: isDark
            ? Border.all(color: Colors.white, width: 1.5)
            : Border.all(color: Colors.black, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateTime.day.toString(),
            style: isDark
                ? const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                : const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          isDark
              ? Text(name.substring(0,4), style: const TextStyle(color: Colors.white))
              : Text(name.substring(0,4), style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
