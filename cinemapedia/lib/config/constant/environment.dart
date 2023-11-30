import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieKey =
      dotenv.env['THE_MOVIE_KEY'] ?? 'There is not api key';
}
