class AccountModel{
  String accountType;
  String bankName;
  int id;
  String nickname;

  AccountModel({required this.accountType, required this.bankName, required this.id, required this.nickname});

  AccountModel.fromJson(Map<String, dynamic> json)
    : accountType = json['account_type'],
      bankName = json['bank_name'],
      id = json['id'],
      nickname = json['nickname'];
}