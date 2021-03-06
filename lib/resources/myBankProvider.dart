import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/Model/generalInsertId.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/myBankModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class MyBankProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<MyBankModel> fetchMyBank() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'member/bank/list',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(myBankModelFromJson,response.body);
    } else {
      throw Exception('Failed to load my bank');
    }
  }


  Future fetchCreateMyBank(var bankname,var bankcode,var acc_no, var acc_name) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"member/bank/create",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "bankname":"$bankname",
          "bankcode":"$bankcode",
          "acc_no":"$acc_no",
          "acc_name":"$acc_name",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

  Future fetchDeleteMyBank(var id) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"member/bank/delete",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id":"$id",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  General.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

}
