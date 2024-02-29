class GeoFireAssistant {
  static List<ActiveNearbyAvailableDrivers> activeNearbyAvailableDriversList =
      [];

  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverId);
    activeNearbyAvailableDriversList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriverLocation(
      ActiveNearbyAvailableDrivers driverWhoMove) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverWhoMove.driverId);
    activeNearbyAvailableDriversList[indexNumber].locationLatitude =
        driverWhoMove.locationLatitude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitude =
        driverWhoMove.locationLongitude;
  }
}

class ActiveNearbyAvailableDrivers {
  String? driverId;
  double? locationLatitude;
  double? locationLongitude;

  ActiveNearbyAvailableDrivers(
      {this.driverId, this.locationLatitude, this.locationLongitude});
}
