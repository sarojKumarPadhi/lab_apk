class ActiveDriverRealTimeDataBase {
  String currentLocation;
  String deviceToken;
  String name;
  String phoneNumber;
  String rideStatus;

  ActiveDriverRealTimeDataBase(
      {required this.name,
      required this.deviceToken,
      required this.phoneNumber,
      required this.rideStatus,
      required this.currentLocation});
}
