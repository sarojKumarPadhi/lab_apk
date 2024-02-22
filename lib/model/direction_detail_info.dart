class DirectionDetailsInfo {
  int? distance_value;
  int? duration_value;
  String? e_points;
  String? distance_text;
  String? duration_text;

  DirectionDetailsInfo(
      {this.distance_value,
      this.duration_value,
      this.e_points,
      this.duration_text,
      this.distance_text});

  factory DirectionDetailsInfo.fromJson(Map<String, dynamic> json) {
    return DirectionDetailsInfo(
        distance_text: json["routes"][0]["legs"][0]["distance"]["text"],
        distance_value: json["routes"][0]["legs"][0]["distance"]["value"],
        duration_text: json["routes"][0]["legs"][0]["duration"]["text"],
        duration_value: json["routes"][0]["legs"][0]["duration"]["value"],
        e_points: json["routes"][0]["overview_polyline"]["points"]);
  }
}
