import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:found_adoption_application/repository/call_back_api.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> changeAvatar(BuildContext context, imageFile) async {
  var userBox = await Hive.openBox('userBox');
  var centerBox = await Hive.openBox('centerBox');

  var currentUser = userBox.get('currentUser');
  var currentCenter = centerBox.get('currentCenter');

  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;

  var accessToken = currentClient.accessToken;
  try {
    var responseData;
    var url;
    final apiUrl = Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/upload/single");

    var request = http.MultipartRequest('POST', apiUrl)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

    // Add headers to the request
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data',
    });

    var response = await request.send();
    // Handle success
    var responseBody = await response.stream.bytesToString();
    responseData = json.decode(responseBody);

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();
      // Add headers to the reques
      request.headers.addAll({
        'Authorization': 'Bearer $newAccessToken',
        'Content-Type': 'multipart/form-data',
      });

      var response = await request.send();
      // Handle success
      var responseBody = await response.stream.bytesToString();
      responseData = json.decode(responseBody);
    }

    if (response.statusCode == 200) {
      url = responseData['url'];
    } else {
      // Handle error
      print('Error uploading image: ${response.statusCode}');
      var errorBody = await response.stream.bytesToString();
      print('Error response: $errorBody');
      return;
    }

    //call api update avatar
    if (url != null) {
      final apiUrl2;
      if (currentClient.role == 'USER') {
        apiUrl2 = Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/user/${currentClient.id}");
      } else {
        apiUrl2 = Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/center/${currentClient.id}");
      }
      var body = jsonEncode(<String, String>{
        'avatar': url,
      });

      final response2 = await http.put(apiUrl2,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: body);

      responseData = json.decode(response2.body);

      if (responseData['message'] == 'jwt expired') {
        responseData = await callBackApi(apiUrl2, "put", body);
      }
      if (responseData['success']) {
        print('upload image success');
      }
    }
  } catch (e) {
    print(e);
  }
}