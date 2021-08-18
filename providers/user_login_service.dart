import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart';
import 'package:mobilePlayGround1/ShoppingApp/models/http_exception.dart';

class LoginAuthorization with ChangeNotifier {
  String _token;
  DateTime _expiryDate;

  String _userID;

  bool get isAuthorized {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signIn(String email, String password) async {
    const url = "";
    try {
      final response = await post(
        Uri.encodeFull(url),
        body: json.encode(
          {
            "UserName": email,
            "Password": password,
          },
        ),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['message'] != null) {
        throw Http_Exception(responseData['message']);
      }
      _token = responseData['token'];
      _userID = responseData['user']['id'];
      _expiryDate = DateTime.now().add(Duration(seconds: 180));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = null;
    _userID = null;
    _expiryDate = null;

    notifyListeners();
  }
}
