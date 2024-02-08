class TransactionItem{
  double balance;
  double cost;
  String date;
  String desc;

  TransactionItem({required this.balance, required this.cost, required this.date, required this.desc});

  @override
  String toString() {
    // TODO: implement toString
    return ("Transaction $desc on the $date cost $cost leaving a balance of $balance");
  }
}