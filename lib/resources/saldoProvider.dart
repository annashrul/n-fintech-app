import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/Model/saldoUIModel.dart';

import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class SaldoProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<SaldoResponse> fetchSaldo(String saldo,String pin) async {
		final pin = await userRepository.getPin();
		final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/deposit",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "saldo":"$saldo",
          "pin":"$pin"
        }).then((Response response) {
          var results = SaldoResponse.fromJson(json.decode(response.body));

          return results;
    });
  }
}
