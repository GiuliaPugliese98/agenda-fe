import 'package:flutter/widgets.dart';

class Logger{

  static void log(Object? message) {
     debugPrint(message?.toString());
  }

   static void logException(Exception ex) {
     debugPrint("*** EXCEPTION *** -> $ex");
   }

}