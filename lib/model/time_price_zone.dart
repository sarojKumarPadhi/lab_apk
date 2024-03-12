class TimePriceZone {
  int day;
  int night;

  TimePriceZone({required this.day, required this.night});

  factory TimePriceZone.fromJson(Map<String, dynamic> mapData) {
    return TimePriceZone(day: mapData["6AM-9PM"], night: mapData["9PM-6AM"]);
  }
}
