import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_flasking_around/models/transaction_item.dart';
import "package:http/http.dart" as http;

class TransactionProvider with ChangeNotifier{
  List<TransactionItem> _items = [];
  final url = "http://localhost:8000/api/transactions";

  List<TransactionItem> get items {
    return [..._items];
  }

  Future<void> get getTransactions async {
    var response;

    try {
      // response = await http.get(Uri.parse(url));
      response = await http.get(Uri.http("localhost:8000", "/api/transactions"));
      List<dynamic> body = json.decode(response.body);
      _items = body.map((e) => TransactionItem(balance: e["balance"], cost: e["cost"], date: e["date"], desc: e["desc"])).toList();
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  Future<void> getFilteredTransactions(String searchTerm) async {
    var response;

    try {
      // response = await http.get(Uri.parse(url));
      response = await http.get(Uri.http("localhost:8000", "/api/transactions/search/$searchTerm"));
      List<dynamic> body = json.decode(response.body);
      _items = body.map((e) => TransactionItem(balance: e["balance"], cost: e["cost"], date: e["date"], desc: e["desc"])).toList();
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }
}