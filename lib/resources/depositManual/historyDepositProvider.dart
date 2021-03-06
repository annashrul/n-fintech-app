import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:n_fintech/Model/depositManual/historyDepositModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class HistoryDepositProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<HistoryDepositModel> fetchHistoryDeposit(var page,var limit,var from,var to) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'transaction/deposit/list?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(historyDepositModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history deposit');
    }
  }

}
