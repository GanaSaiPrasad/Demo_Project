import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart';
import 'package:mobilePlayGround1/ShoppingApp/models/http_exception.dart';

class UserAuthorization with ChangeNotifier {
  // String code;
  // String description;

  Future<void> signUP(String firstName, String lastName, String mobileNo,
      String email, String password) async {
    const url = "";

    Map userData = {
      "FirstName": firstName,
      "LastName": lastName,
      "PhoneNumber": mobileNo,
      "UserName": email,
      "Password": password,
    };
    try {
      final response = await post(
        Uri.encodeFull(url),
        body: json.encode(userData),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['code'] != null) {
        throw Http_Exception(responseData['description']);
      } else if (responseData['title'] != null) {
        throw Http_Exception(responseData['title']);
      }

      //  code = responseData['code'];
      //  description = responseData['description'];
    } catch (error) {
      throw error;
    }
  }
}
