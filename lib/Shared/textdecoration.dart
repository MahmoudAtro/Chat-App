import 'package:flutter/material.dart';

var userdecoration = InputDecoration(
  hintStyle: TextStyle(fontSize: 20.0, color: Colors.teal[300]),
  suffixIconColor: Colors.teal,
  prefixIconColor: Colors.teal,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.tealAccent)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.tealAccent)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.tealAccent)),
      
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.blue)),
);
