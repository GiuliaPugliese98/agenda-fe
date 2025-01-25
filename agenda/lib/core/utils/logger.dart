import 'package:flutter/widgets.dart';

class Logger{

  static void log(String message) {
     debugPrint(message);
  }

   static void logException(Object ex) {
     debugPrint("*** EXCEPTION *** -> $ex");
   }

}