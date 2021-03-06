import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:n_fintech/Model/depositManual/listAvailableBank.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class ListAvailableBankProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ListAvailableBankModel> fetchListAvailableBank() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'transaction/deposit/availablebank',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listAvailableBankModelFromJson,response.body);
    } else {
      throw Exception('Failed to load bank');
    }
  }

}
