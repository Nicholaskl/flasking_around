import 'package:flutter/material.dart';
import 'package:flutter_flasking_around/providers/transaction_provider.dart';
import 'package:flutter_flasking_around/widgets/transactions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_flasking_around/theme.dart';
import 'package:go_router/go_router.dart';

final _appTheme = AppTheme();

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

    return Container(
      padding: _appTheme.screenPadding,
      child: Column(
        children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transactions",
                  style: _appTheme.pageHeading,
                  textAlign: TextAlign.left,
                )
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton(
                onPressed: () {
                  context.go("/upload");
                }, 
                style: _appTheme.buttonTheme,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Upload csv")
                    ),
                  ],
                ),
                // style: ,
              ),
            ),
            Flexible(child: table),
          ],
      ),
    );
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