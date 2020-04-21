import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:n_fintech/Model/plnModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class PlnProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<PlnModel> fetchPln() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ppob/pasca/get/PLN',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(plnModelFromJson, response.body);
    } else {
      throw Exception('Failed to load PLN');
    }
  }

}
