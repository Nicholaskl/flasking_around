import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
  PlatformFile? path;
  static var dio = Dio();

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

  void pickFiles() async {
    print("hi");
    FilePickerResult? _path;
    try {
      _path = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ["csv"],
      ));
    } on PlatformException catch (e) {
      log("Unsupported operation" + e.toString());
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      if (_path != null) {
        path = _path.files[0];
      }
    });
  }

  static Future<int> uploadFile(Uint8List? file, int? _accountSelected) async {
    print(file as List<int>);
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file as List<int>,
        headers: {HttpHeaders.contentTypeHeader: ["application/csv"],},
      )
    });
    var response = 
      await dio.post("http://localhost:8000/api/upload", data:file as List<int>, queryParameters: {"account_id_query": _accountSelected});
    if (response.statusCode != 201){
      throw Exception('Error uploading data'); 
    }
    return Future.value(response.statusCode);
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  style: _appTheme.contentHeading,
                  "Select account to choose from"
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
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
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 16)),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  style: _appTheme.contentHeading,
                  "Please Select a file to upload"
                ),
              ),
              FilledButton(
                onPressed: () {
                  pickFiles();
                }, 
                style: _appTheme.buttonTheme,
                child: Row(
                  children: [
                    Icon(Icons.file_present_rounded),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Pick csv")
                    ),
                  ],)
              )
            ],
          ),
          Column(
            children: [
              FilledButton(
                onPressed: () {
                  // pickFiles();
                  uploadFile(path!.bytes, accountSelected);
                }, 
                style: _appTheme.buttonTheme,
                child: Row(
                  children: [
                    Icon(Icons.file_present_rounded),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Upload")
                    ),
                  ],)
              )
            ],
          )
        ],
      ),
    );
  }
}