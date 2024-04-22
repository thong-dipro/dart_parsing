import 'dart:io';
import 'dart:typed_data';

import 'package:dart_parsing/gps_value.dart';
import 'package:dart_parsing/string_extensions.dart';

Future<List<GPSValue>> getGPSs(String filePath) async {
  final List<String> buffers = await _readFileAsString(filePath);
  List<GPSValue> gpsValues = [];
  for (int i = 0; i < buffers.length; i++) {
    if (_checkGPS(buffers, i)) {
      print("-------------------");
      try {
        gpsValues.add(_getGPSValue(buffers, i));
      } catch (e) {
        print(e);
      }
    }
  }
  return gpsValues;
}

Future<List<String>> _readFileAsString(String filePath) async {
  final result = await File(filePath).readAsBytes();
  List<String> data = [];
  for (int i = 0; i < result.length; i++) {
    data.add(result[i].toRadixString(16).toUpperCase());
  }
  return data;
}

bool _checkGPS(
  List<String> data,
  int index,
) {
  return data[index] == '59' &&
      data[index + 1] == '57' &&
      data[index + 2] == '4B' &&
      data[index + 3] == '4A' &&
      data[index + 4] == '47' &&
      data[index + 5] == '50' &&
      data[index + 6] == '53';
}

GPSValue _getGPSValue(List<String> buffers, int index) {
  return GPSValue(
    gX: (getIntValue(buffers, index + 8, 'gX') / 128),
    gY: (getIntValue(buffers, index + 12, 'gY') / 128),
    gZ: (getIntValue(buffers, index + 16, 'gZ') / 128),
    gStatus: String.fromCharCode(getIntValue(buffers, index + 20, 'gStatus')),
    hour: (getIntValue(buffers, index + 24, 'Hour') + 9) % 24,
    minute: getIntValue(buffers, index + 28, 'minute'),
    second: getIntValue(buffers, index + 32, 'second'),
    latDirection:
        String.fromCharCode(getIntValue(buffers, index + 36, 'latDirection')),
    lat: getLatLngValue(getDoubleValue(buffers, index + 40, 4, 'lat')),
    lngDirection:
        String.fromCharCode(getIntValue(buffers, index + 44, 'lngDirection')),
    lng: getLatLngValue(getDoubleValue(buffers, index + 48, 4, 'lng')),
    speed: getDoubleValue(buffers, index + 52, 4, 'speed') * 1.852,
    direction: getDoubleValue(buffers, index + 56, 4, 'direction'),
    altitude: getDoubleValue(buffers, index + 60, 4, 'altitude'),
    year: getIntValue(buffers, index + 64, 'year') + 2000,
    month: getIntValue(buffers, index + 68, 'month'),
    day: getIntValue(buffers, index + 72, 'day'),
  );
}

int getIntValue(List<String> digits, int index, String debugCode) {
  try {
    String value = digits[index];
    return int.parse(digits[index + 1]) == 0
        ? int.parse(value, radix: 16)
        : int.parse(value, radix: 16) - 255;
  } catch (e) {
    print(debugCode);
    print(e);
    print('--------------');
    return 0;
  }
}

double getDoubleValue(
    List<String> digits, int index, int shiftCount, String debugCode) {
  try {
    String value = '';
    for (int i = index; i < index + shiftCount; i++) {
      value += digits[i];
    }
    return value.fromHexToDouble;
  } catch (e) {
    String value = '';
    for (int i = index; i < index + shiftCount; i++) {
      value = '${toHex(digits[index])}$value';
    }
    print("error  ${digits[index]}");
    print(value);
    print(debugCode);
    print(e);
    return 0.0;
  }
}

double getLatLngValue(double value) {
  try {
    final degree = value % 100;
    return (value / 100) + (degree / 60);
  } catch (e) {
    return 0.0;
  }
}

String toHex(String data) {
  int number = 0;
  try {
    number = int.parse(
      data,
    );
  } catch (e) {
    return '';
  }
  final result = number.toRadixString(16).toUpperCase();
  return result.length == 1 ? '0$result' : result;
}

double hexToDouble(String hexString) => (ByteData(8)
          ..setUint64(
            0,
            int.parse(
              hexString,
              radix: 16,
            ),
          ))
        .getFloat64(
      0,
    );
