import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/Model/generalInsertId.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/historyPenarikanModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class WithdrawProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future withdraw(var amount,var id_bank) async {
    final pin = await userRepository.getPin();
    final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/withdraw/create",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "amount":"$amount",
          "id_bank":"$id_bank",
          "pin":"$pin"
        }).then((Response response) {
          print(response.body);
      var results;
      if(response.statusCode==200){
        results = GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

  Future<HistoryPenarikanModel> fetchHistoryPenarikan(var page, var limit, var from, var to) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'transaction/withdraw/list?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("################################################ HISTORY PENARIKAN #######################################");
    print('transaction/withdraw/list?page=$page&limit=$limit&datefrom=$from&dateto=$to');
    if (response.statusCode == 200) {
      return compute(historyPenarikanModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Penarikan');
    }
  }


}
