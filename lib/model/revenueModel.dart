class revenueModel {
  final int profit;
  final int rideBooked;
  final int rideCancelled;
  final Map<String, dynamic> totalSamplesTested;

  revenueModel(
      {required this.profit,
        required this.rideBooked,
        required this.rideCancelled,
        required this.totalSamplesTested});

  factory revenueModel.fromJson(Map<String, dynamic> json) {
    return revenueModel(
        profit: json['profit'],
        rideBooked: json['rideBooked'],
        rideCancelled: json['rideCancelled'],
        totalSamplesTested: json['totalSamplesTested']);
  }
}