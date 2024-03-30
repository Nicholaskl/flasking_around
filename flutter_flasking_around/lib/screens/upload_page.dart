import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_flasking_around/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_flasking_around/models/account.dart';

final _appTheme = AppTheme();

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool selected = true;
  String? comboboxValue;
  late Future<List<AccountModel>> _future;
  int? accountSelected;

  @override
  void initState() {
    super.initState();
    _future = _getAccounts();
  }

  Future<List<AccountModel>> _getAccounts() async {
    final response = await http.get(Uri.parse("http://localhost:8000/api/accounts"));
    final body = jsonDecode(response.body)as List;
    if (response.statusCode ==200) {
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return AccountModel(
          accountType: map['account_type'] as String,
          bankName: map['bank_name'] as String,
          id: map['id'] as int,
          nickname: map['nickname'] as String,
        );
      }).toList();
    }
    throw Exception('Error fetching data');
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.centerLeft,
      padding: _appTheme.screenPadding,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upload",
              style: _appTheme.pageHeading,
            ),
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 16)),
              Text(
                style: _appTheme.contentHeading,
                "Select account to choose from"
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: FutureBuilder<List<AccountModel>>(
                  future: _future, 
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownMenu(
                        dropdownMenuEntries: snapshot.data!.map((item){
                          return DropdownMenuEntry(
                            value: item.id,
                            label: item.nickname,
                          );
                        }).toList(),
                        onSelected: (value) {
                          setState(() {
                            accountSelected = value;
                          });
                        },
                        
                        
                      );
                    } else {
                      return Center(child: const CircularProgressIndicator());
                    }
                  }),
              )
            ],
          )
        ],
      ),
    );
  }
}