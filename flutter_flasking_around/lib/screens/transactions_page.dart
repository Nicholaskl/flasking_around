import 'package:flutter/material.dart';
import 'package:flutter_flasking_around/providers/transaction_provider.dart';
import 'package:flutter_flasking_around/widgets/transactions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool selected = true;
  bool disable = false;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    // assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);

    TransactionsWidget table = TransactionsWidget();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions Screen'),
      ),
      body: Column(
        children: [
          Flexible(child: TextField(
            decoration: const InputDecoration(
              hintText: "Search string",
            ),
            onSubmitted: (String newText) {
              if (newText.isNotEmpty) {
                print("text");
              }
            }
            ),
          ),
          Flexible(child: table),
        ],
      )
    );
  }

  void Test(String value){
    print(value);
  }
}

class Stuff extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TransactionProvider(),
    );
  }
}