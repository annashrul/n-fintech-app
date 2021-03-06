import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:n_fintech/Model/profileModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class ProfileProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future fetchProfile() async{
    final token = await userRepository.getToken();
    try{
      final response = await client.get(
          ApiService().baseUrl+'member/myprofile',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (response.statusCode == 200) {
        return compute(profileModelFromJson,response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch(e){
      return 'gagal';
    }
  }
}
