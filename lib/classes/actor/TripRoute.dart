class TripRoute {
  final String source;
  final String destination;

  TripRoute({this.source, this.destination});

  @override
  String toString() {
    return '$source - $destination';
  }
}
