import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flasking_around/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_flasking_around/theme.dart';
import 'package:go_router/go_router.dart';

final _appTheme = AppTheme();

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool selected = true;
  bool disable = false;
  String? comboboxValue;
  static var dio = Dio();

  static Future<int> clearTransactions() async {
    var response = 
      await dio.get("http://localhost:8000/api/transactions/clear");
    if (response.statusCode != 200){
      throw Exception('Error clearing data'); 
    }
    return Future.value(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    // assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);


    return Container(
      padding: _appTheme.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: _appTheme.pageHeading,
                  textAlign: TextAlign.left,
                )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                    FilledButton(
                      onPressed: () {
                        var printText = "";
                        var status = clearTransactions();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: FutureBuilder(
                              future: status,
                              builder: (context, snapshot) {
                                if (snapshot.hasData){
                                  log(snapshot.data.toString());
                                  if (snapshot.data.toString() == "200") {
                                    printText = "Successfully Deleted";
                                  }
                                }
                                return snapshot.hasData
                                  ? Text(printText)
                                  : const Text("Something went wrong. Try again");
                              },
                            )
                          ),
                        );
                        
                      }, 
                      style: _appTheme.buttonTheme.copyWith(backgroundColor: MaterialStatePropertyAll(_appTheme.colorScheme.error)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.file_present_rounded),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: const Text("Clear Database")
                          ),
                        ],)
                    )
                  ],
                )
              ],
            ),
          ],
      ),
    );
  }
}