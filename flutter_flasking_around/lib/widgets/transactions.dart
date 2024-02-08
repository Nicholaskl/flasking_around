import 'package:fluent_ui/fluent_ui.dart' hide Page, Colors;
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:flutter_flasking_around/providers/transaction_provider.dart";

class TransactionsWidget extends StatefulWidget{
  const TransactionsWidget({Key? key}) : super(key: key);

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  // Might not need this lols
  TextEditingController newTaskController = TextEditingController();

  DataRow _formatResults(index, data){
    return DataRow(
      color: data.cost > 0.0 
        ? MaterialStateColor.resolveWith((states) => Colors.green) 
        : MaterialStateColor.resolveWith((states) => Colors.red),
      cells: <DataCell>[
        DataCell(
          Text(
            data.date,
          ),
        ), //add name of your columns here
        DataCell(
          Text(
            data.cost.toString(),
          ),
        ),
        DataCell(
          Text(
            data.desc,
          ),
        ),
        DataCell(
          Text(
            data.balance.toString(),
          ),
        ),
      ],
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
            ? Center(child: ProgressRing())
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
                child: DataTable(
                columns: const [
                  DataColumn(
                  label: Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Cost',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Description',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Remaining balance',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
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
    );
  }
}