import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/Model/authModel.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class LoginProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<AuthModel> fetchLoginEmail(String email,String password) async {
    return await client.post(ApiService().baseUrl+"auth/login",
        body: {
          "email":"$email",
          "password":"$password",
        }).then((Response response) {
        var results = AuthModel.fromJson(json.decode(response.body));
        print(results.status);
        return results;
    });
  }

//  Future fetchCreateMember(var pin, var name,var ismobile,var no_hp, var referral, var ktp) async {
//    final token = await userRepository.getToken();
//    return await client.post(ApiService().baseUrl+"auth/register",
//        body: {
//          "pin":"$pin",
//          "name":"$name",
//          "ismobile":"$ismobile",
//          "no_hp":"$no_hp",
//          "referral":"$referral",
//          "ktp":"$ktp",
//        }).then((Response response) {
//      var results;
//      if(response.statusCode == 200){
//        results =  CreateMemberModel.fromJson(json.decode(response.body));
//      }else if(response.statusCode == 400){
//        results =  General.fromJson(json.decode(response.body));
//      }
//      print(results.status);
//      return results;
//    });
//  }

  Future fetchLoginNoHp(var nohp,var deviceid,var typeotp) async {
    return await client.post(ApiService().baseUrl+"auth/login",
      body: {
        "nohp":"$nohp",
        "deviceid":"$deviceid",
        "typeotp":"$typeotp",
      }).then((Response response) {
        print(response.body);
      var results;
      if(response.statusCode == 200){
        results = AuthModel.fromJson(jsonDecode(response.body));
      }else{
        results = General.fromJson(jsonDecode(response.body));
      }
      print(results);
      return results;
    });
  }


  


}
