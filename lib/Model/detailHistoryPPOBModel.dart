// To parse this JSON data, do
//
//     final detailHistoryPpobModel = detailHistoryPpobModelFromJson(jsonString);

import 'dart:convert';

import 'base_model.dart';


DetailHistoryPpobModel detailHistoryPpobModelFromJson(String str) => DetailHistoryPpobModel.fromJson(json.decode(str));

String detailHistoryPpobModelToJson(DetailHistoryPpobModel data) => json.encode(data.toJson());

class DetailHistoryPpobModel extends BaseModel {
  Result result;
  String msg;
  String status;

  DetailHistoryPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  factory DetailHistoryPpobModel.fromJson(Map<String, dynamic> json) => DetailHistoryPpobModel(
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
  String produk;
  String target;
  String mtrpln;
  String note;
  String token;
  String status;

  Result({
    this.produk,
    this.target,
    this.mtrpln,
    this.note,
    this.token,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    produk: json["produk"],
    target: json["target"],
    mtrpln: json["mtrpln"],
    note: json["note"],
    token: json["token"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "produk": produk,
    "target": target,
    "mtrpln": mtrpln,
    "note": note,
    "token": token,
    "status": status,
  };
}
