import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/Model/MLM/checkoutToDetailModel.dart';
import 'package:n_fintech/Model/generalInsertId.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/productMlmDetailModel.dart';
import 'package:n_fintech/Model/productMlmModel.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';

class ProductMlmProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<ProductMlmModel> fetchProductMlm(var page,var limit) async{
		final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'product/mlm?page=$page&limit=$limit&category=kavling',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(productMlmModelFromJson, response.body);
    } else {
      throw Exception('Failed to load product mlm');
    }
	}

  Future<ProductMlmDetailModel> fetchProductDetailMlmSuplemen(var id) async{
		final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'product/mlm/get/'+id,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if(response.statusCode == 200){
      return compute(productMlmDetailModelFromJson, response.body);
    }else{
      throw Exception('failed to load product mlm by id');
    }
  }
  Future<ProductMlmDetailModel> fetchProductDetailMlmKavling(var id) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'product/mlm/get/'+id,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if(response.statusCode == 200){
      return compute(productMlmDetailModelFromJson, response.body);
    }else{
      throw Exception('failed to load product mlm by id');
    }
  }

  Future<General> fetchCheckout(String id,String price,String qty, String jasper, String ongkir) async {
		final pin = await userRepository.getPin();
		final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/checkout",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id_product":"$id",
          "price":"$price",
          "qty":"$qty",
          "jasper":"$jasper",
          "ongkir":"$ongkir",
          "pin":"$pin"
        }).then((Response response) {
          var results = General.fromJson(json.decode(response.body));
          return results;
    });
  }

  Future<CheckoutToDetailModel> fetchCheckoutCart(var total,var jasper,var ongkir, var alamat,var type_alamat,var voucher,var pembayaran) async {
    final pin = await userRepository.getPin();
    final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/checkoutcart",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "total":"$total",
          "jasper":"$jasper",
          "ongkir":"$ongkir",
          "alamat":"$alamat",
          "pin":"$pin",
          "type_alamat":"$type_alamat",
          "voucher":"$voucher",
          "pembayaran":"$pembayaran",
        }).then((Response response) {
      var results = CheckoutToDetailModel.fromJson(json.decode(response.body));
      print(results.result);
      return results;
    });
  }

}
