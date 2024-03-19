import 'package:fluent_ui/fluent_ui.dart';
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
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Transactions Screen'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Link(
            uri: Uri.parse('https://github.com/bdlukaa/fluent_ui'),
            builder: (context, open) => Semantics(
              link: true,
              child: Tooltip(
                message: 'Source code',
                child: IconButton(
                  icon: const Icon(FluentIcons.open_source, size: 24.0),
                  onPressed: open,
                ),
              ),
            ),
          ),
        ]),
      ),
      children: const [
        Column(
          children: [
            Text("hello"),
            TransactionsWidget()
          ],
        )
      ],
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