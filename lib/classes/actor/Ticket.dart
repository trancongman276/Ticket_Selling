class UserTicket {
  final int seatID;
  final String id;
  final String source;
  final String dest;
  final Map<String, DateTime> time;
  final String companyName;
  int rate;

  UserTicket(
      {this.id,
      this.seatID,
      this.source,
      this.dest,
      this.time,
      this.companyName,
      int rate}) {
    this.rate = rate ?? 0;
  }

  bool updateRate(int rate) {
    this.rate = rate;
    return true;
  }
}
