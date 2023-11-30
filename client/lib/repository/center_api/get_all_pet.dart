import 'dart:convert';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/repository/auth_api.dart';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<List<Pet>> getAllPet() async {
  //mở localstorage nếu currentClient là user
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');

  //mở localstorage nếu currentClient là center
  var centerBox = await Hive.openBox('centerBox');
  var currentCenter = centerBox.get('currentCenter');

  // Sử dụng dữ liệu của người dùng hiện tại dựa trên tình huống cụ thể
  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;

  //bắt đầu từ đoạn này, cẩn phải thay đổi currentClient là currentUser hay currentCenter cho phù hợp
  var accessToken = currentClient.accessToken;

  var responseData = {};

  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/pet");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $accessToken',
    });
    responseData = json.decode(response.body);
    // print('Response get ALL POST: $responseData');

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();

      currentClient.accessToken = newAccessToken;
      // userBox.put('currentUser', currentClient); //??????????

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      response = await http.post(apiUrl, headers: {
        'Authorization': 'Bearer $newAccessToken',
      });

      responseData = json.decode(response.body);
    }
  } catch (e) {
    print('Error in getAllPost: $e');
  }

  print('All Pet display here: ${responseData['data']}');

  var petList = responseData['data'] as List<dynamic>;

  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  print('testttt: $pets');

  return pets;
}