class GPSValue {
  final double gX;
  final double gY;
  final double gZ;
  final String gStatus;
  final double hour;
  final int minute;
  final int second;
  final String latDirection;
  final double lat;
  final String lngDirection;
  final double lng;
  final double speed;
  final double direction;
  final double altitude;
  final int year;
  final int month;
  final int day;

  const GPSValue({
    required this.gX,
    required this.gY,
    required this.gZ,
    required this.gStatus,
    required this.hour,
    required this.minute,
    required this.second,
    required this.latDirection,
    required this.lat,
    required this.lngDirection,
    required this.lng,
    required this.speed,
    required this.direction,
    required this.altitude,
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  String toString() {
    return 'GPSValue{gX: $gX, gY: $gY, gZ: $gZ, gStatus: $gStatus, hour: $hour, minute: $minute, second: $second, latDirection: $latDirection, lat: $lat, lngDirection: $lngDirection, lng: $lng, speed: $speed, direction: $direction, altitude: $altitude, year: $year, month: $month, day: $day}';
  }
}
