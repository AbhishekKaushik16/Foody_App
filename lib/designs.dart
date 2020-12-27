import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buildTextTitleVariation1(String text){
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.breeSerif(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    ),
  );
}
buildRecipeTitle(String text){
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
buildTextSubTitleVariation1(String text){
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[400],
      ),
    ),
  );
}