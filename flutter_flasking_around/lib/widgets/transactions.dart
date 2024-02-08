import 'package:fluent_ui/fluent_ui.dart' hide Page;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), 
      child: Container(
        child: 
          FutureBuilder(
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: transactionProvider.items.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        // tileColor: Colors.black,
                        // title: Text(transactionProvider.items[i].desc),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              transactionProvider.items[i].date,
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              transactionProvider.items[i].desc,
                              textAlign: TextAlign.left,
                            )
                            ],
                          ),
                        onPressed: () {},
                      )
                      ),
                    ),
                )
              ),
              )
          )
      ),
    );
  }
}