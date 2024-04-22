import 'dart:math';

extension XString on String {
  double get fromHexToDouble {
    List<String> hexStrings = [];
    for (int i = 0; i < length; i += 2) {
      hexStrings.add(substring(i, i + 2));
    }
    String hexString2 = hexStrings.reversed.join('');
    String binaryString = '';
    hexString2.split('').forEach((element) {
      binaryString += int.parse(
        element,
        radix: 16,
      ).toRadixString(2).padLeft(4, '0');
    });
    final sign = binaryString[0];
    final exponent = binaryToExponent(binaryString.substring(1, 9));
    final mantissa = binaryToMantissa(binaryString.substring(9));
    final doubleValue =
        (1 + mantissa) * pow(2, exponent) * (sign == '1' ? -1 : 1);
    return doubleValue;
  }
}

double binaryToExponent(String binary) {
  double exponent = 0;
  for (int i = 0; i < binary.length; i++) {
    exponent += int.parse(binary[i]) * pow(2, 7 - i);
  }
  return exponent - 127;
}

double binaryToMantissa(String binary) {
  double mantissa = 0;
  for (int i = 0; i < binary.length; i++) {
    mantissa += int.parse(binary[i]) * pow(2, -i - 1);
  }
  return mantissa;
}
