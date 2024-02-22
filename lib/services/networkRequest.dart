import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jonk_lab/global/const.dart';
import 'package:jonk_lab/model/direction_detail_info.dart';

Future<dynamic> apiRequest(String apiUrl) async {
  var response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    var jsonDecoded = jsonDecode(response.body);
    try {
      if (jsonDecoded["status"] == "OK") {
        return jsonDecoded;
      } else {
        return "response error";
      }
    } catch (e) {
      return "response error";
    }
  } else {
    return;
  }
}

Future<LatLng?> apiRequestForLatLng(String apiUrl) async {
  var response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    var jsonDecoded = jsonDecode(response.body);
    LatLng result = LatLng(jsonDecoded["result"]["geometry"]["location"]["lat"],
        jsonDecoded["result"]["geometry"]["location"]["lng"]);
   return result;
  }
  return null;
}

Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(
    LatLng originPosition, LatLng destinationPosition) async {
  String obtainOriginToDestinationDirectionDetails =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
  var responseDirectionApi =
      await apiRequest(obtainOriginToDestinationDirectionDetails);
  if (responseDirectionApi == "response error") {
    return null;
  }
  return DirectionDetailsInfo.fromJson(responseDirectionApi);
}
