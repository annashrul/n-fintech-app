// To parse this JSON data, do
//
//     final promosiModel = promosiModelFromJson(jsonString);

import 'dart:convert';


import 'base_model.dart';

PromosiModel promosiModelFromJson(String str) => PromosiModel.fromJson(json.decode(str));

String promosiModelToJson(PromosiModel data) => json.encode(data.toJson());

class PromosiModel extends BaseModel {
    Result result;
    String msg;
    String status;

    PromosiModel({
        this.result,
        this.msg,
        this.status,
    });

    factory PromosiModel.fromJson(Map<String, dynamic> json) => PromosiModel(
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
    List<Datum> data;
    int count;
    int currentPage;
    String perpage;
    int lastPage;

    Result({
        this.data,
        this.count,
        this.currentPage,
        this.perpage,
        this.lastPage,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        count: json["count"],
        currentPage: json["current_page"],
        perpage: json["perpage"],
        lastPage: json["last_page"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
        "current_page": currentPage,
        "perpage": perpage,
        "last_page": lastPage,
    };
}

class Datum {
    String id;
    String idMember;
    dynamic idCategory;
    String penulis;
    String title;
    String slug;
    String link;
    String picture;
    String thumbnail;
    String caption;
    int type;
    dynamic category;
    String createdAt;
    DateTime updatedAt;

    Datum({
        this.id,
        this.idMember,
        this.idCategory,
        this.penulis,
        this.title,
        this.slug,
        this.link,
        this.picture,
        this.thumbnail,
        this.caption,
        this.type,
        this.category,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        idMember: json["id_member"],
        idCategory: json["id_category"],
        penulis: json["penulis"],
        title: json["title"],
        slug: json["slug"],
        link: json["link"],
        picture: json["picture"],
        thumbnail: json["thumbnail"],
        caption: json["caption"],
        type: json["type"],
        category: json["category"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_member": idMember,
        "id_category": idCategory,
        "penulis": penulis,
        "title": title,
        "slug": slug,
        "link": link,
        "picture": picture,
        "thumbnail": thumbnail,
        "caption": caption,
        "type": type,
        "category": category,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
    };
}
