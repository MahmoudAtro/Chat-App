import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ShowSnackbar(context , final text, final color){
  return SchedulerBinding.instance.addPostFrameCallback((_) {
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text) , backgroundColor: color,)
  );
});
}