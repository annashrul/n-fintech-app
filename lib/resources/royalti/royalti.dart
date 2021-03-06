import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/royalti/levelModel.dart';
import 'package:n_fintech/Model/royalti/royaltiMemberModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class RoyaltiLevelProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<LevelModel> fetchLevel() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'transaction/royalti/level',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################ROYALTI LEVEL###############################################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(levelModelFromJson,response.body);
    } else {
      throw Exception('Failed to load level');
    }
  }


  Future<RoyaltiMemberModel> fetchRoyaltiMember(var param) async{
    final token = await userRepository.getToken();
    var level = param == 'kosong' ? 'DIRHAM' : param;
    final response = await client.get(
      ApiService().baseUrl+'transaction/royalti/member/$level',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################ROYALTI MEMBER###############################################################");
    print(response.body);
    print(param);
    var results;
    if (response.statusCode == 200) {
      return compute(royaltiMemberModelFromJson,response.body);
    }else {
      throw Exception('Failed to load level');
    }
//    return results;

  }

}


