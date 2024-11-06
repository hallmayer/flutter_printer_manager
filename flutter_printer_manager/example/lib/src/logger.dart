import 'package:logger/logger.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super();
  static final instance = Log._();
}