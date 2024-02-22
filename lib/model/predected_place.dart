class PredictedPlaces {
  String? place_id;
  String? main_text;
  String? secondary_id;

  PredictedPlaces({this.place_id, this.main_text, this.secondary_id});

  PredictedPlaces.fromJson(Map<String, dynamic> jsonData) {
    place_id = jsonData["place_id"];
    main_text = jsonData["structured_formatting"]["main_text"];
    secondary_id = jsonData["structured_formatting"]["secondary_text"];
  }
}
