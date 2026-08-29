import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.roboto(color:Colors.black, fontSize: 16),);
  }
}
