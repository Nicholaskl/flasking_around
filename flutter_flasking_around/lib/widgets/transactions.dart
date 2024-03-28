// import 'package:fluent_ui/fluent_ui.dart' hide Page, Colors;
import "package:provider/provider.dart";
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter/material.dart';
import "package:flutter_flasking_around/providers/transaction_provider.dart";

class TransactionsWidget extends StatefulWidget{
  const TransactionsWidget({Key? key}) : super(key: key);

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();

  void submit(String text){
    print(text);
  }
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  // Might not need this lols
  TextEditingController newTaskController = TextEditingController();

  PlutoRow _formatResults(index, data){
    return PlutoRow(
      // color: data.cost > 0.0 
      //   ? MaterialStateColor.resolveWith((states) => Colors.green) 
      //   : MaterialStateColor.resolveWith((states) => Colors.red),
      cells: {
        'date_field': PlutoCell(value: data.date),
        'cost_field': PlutoCell(value: data.cost),
        'desc_field': PlutoCell(value: data.desc),
        'balance_field': PlutoCell(value: data.balance),
      }

      //   DataCell(
      //     Text(
      //       data.date,
      //     ),
      //   ), //add name of your columns here
      //   DataCell(
      //     Text(
      //       data.cost.toString(),
      //     ),
      //   ),
      //   DataCell(
      //     Text(
      //       data.desc,
      //     ),
      //   ),
      //   DataCell(
      //     Text(
      //       data.balance.toString(),
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), 
      child: Container(
        child: FutureBuilder(
          future: Provider.of<TransactionProvider>(context, listen: false).getTransactions, 
            builder: (ctx, snapshot) => 
            snapshot.connectionState == ConnectionState.waiting 
            ? const Center(child: CircularProgressIndicator())
            : 
            Consumer<TransactionProvider>(
              child: Center(
                heightFactor:  MediaQuery.of(context).size.height * 0.03,
                child: const Text("You have no Transactions added.", style: TextStyle(fontSize: 18))
              ),
              builder: (ctx, transactionProvider, child) => transactionProvider.items.isEmpty
              ? child as Widget
              : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  child: PlutoGrid(
                  columns:  [
                    PlutoColumn(title: 'Date', field: 'date_field', type: PlutoColumnType.date()),
                    PlutoColumn(title: 'Cost', field: 'cost_field', type: PlutoColumnType.number()),
                    PlutoColumn(title: 'Description', field: 'desc_field', type: PlutoColumnType.text()),
                    PlutoColumn(title: 'Balance', field: 'balance_field', type: PlutoColumnType.number()),
                  ],
                  // ignore: avoid_print
                  rows: List.generate(
                    transactionProvider.items.length,
                    (index) => _formatResults(
                      index,
                      transactionProvider.items[index],
                    ),
                  ),
                )
              )
            )
          )
        )
      )
    );
  }
}