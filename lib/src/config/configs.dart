import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configs {
  static String get ggKEY2 => dotenv.env['GOOGLE_API_KEY'] ?? '';
}
