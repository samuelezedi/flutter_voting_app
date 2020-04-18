import 'dart:math';

class Utils {
  String generateUsername(String email) {
    String val = '';
    var rng = new Random();
    for (var i = 0; i < 6; i++) {
      val += rng.nextInt(9).toString();
    }
    return val;
  }
}