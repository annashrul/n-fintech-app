// To parse this JSON data, do
//
//     final ppobPascaCheckoutModel = ppobPascaCheckoutModelFromJson(jsonString);

import 'dart:convert';


import '../base_model.dart';

PpobPascaCheckoutModel ppobPascaCheckoutModelFromJson(String str) => PpobPascaCheckoutModel.fromJson(json.decode(str));

String ppobPascaCheckoutModelToJson(PpobPascaCheckoutModel data) => json.encode(data.toJson());

class PpobPascaCheckoutModel extends BaseModel {
  Result result;
  String msg;
  String status;

  PpobPascaCheckoutModel({
    this.result,
    this.msg,
    this.status,
  });

  factory PpobPascaCheckoutModel.fromJson(Map<String, dynamic> json) => PpobPascaCheckoutModel(
    result: Result.fromJson(json["result"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "msg": msg,
    "status": status,
  };
}

class Result {
  var total;
  var nama;
  var target;
  var mtrpln;
  var token;
  var status;

  Result({
    this.total,
    this.nama,
    this.target,
    this.mtrpln,
    this.token,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    nama: json["nama"],
    target: json["target"],
    mtrpln: json["mtrpln"],
    token: json["token"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "nama": nama,
    "target": target,
    "mtrpln": mtrpln,
    "token": token,
    "status": status,
  };
}
