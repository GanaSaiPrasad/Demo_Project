import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobilePlayGround1/ShoppingApp/models/http_exception.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/auth.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_login_screen.dart';
import 'package:provider/provider.dart';

class UserRegisterScreen extends StatefulWidget {
  static const routeName = '/user_register';

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void displayErrorMessage(String errorText) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Html(data: errorText),
          actions: [
            FlatButton(
                onPressed: Navigator.of(context).pop, child: Text('Okay'))
          ],
        ),
      );

  Map<String, dynamic> _userData = {
    "FirstName": "",
    "LastName": "",
    "PhoneNumber": "",
    "UserName": "",
    "Password": "",
  };

  bool hidePassword = true;
  //bool hidepassword = true;

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // _formKey.currentState.reset();

    }
    try {
      await Provider.of<UserAuthorization>(context, listen: false).signUP(
          _userData["FirstName"],
          _userData["LastName"],
          _userData["PhoneNumber"],
          _userData["UserName"],
          _userData["Password"]);
    } on Http_Exception catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('One or more validation errors occurred')) {
        errorMessage = error.toString();
      } else if (error.toString().contains('successfully completed')) {
        errorMessage = error.toString();
      } else if (error.toString().contains('Username')) {
        errorMessage = error.toString();
      }
      displayErrorMessage(errorMessage);
    } catch (error) {
      var errorMessage = "Unknown Error Occured,Please Try Again Later";

      displayErrorMessage(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Page"),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(40),
            children: <Widget>[
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter First Name"),
                onSaved: (value) {
                  _userData["FirstName"] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Last Name"),
                onSaved: (value) {
                  _userData["LastName"] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Mobile No',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Mobile Number"),
                onSaved: (value) {
                  _userData["PhoneNumber"] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  hintText: 'you@example.com',
                  labelText: 'Email Id',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Please Enter Email"),
                  EmailValidator(errorText: "Please Enter Valid Email")
                ]),
                onSaved: (value) {
                  _userData["UserName"] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.done,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open),
                  suffixIcon: IconButton(
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please Enter Password";
                  } else if (!value.contains(new RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])'))) {
                    return "Password Should Contain Atleast One Special Character";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _userData["Password"] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              //  TextFormField(
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   textInputAction: TextInputAction.done,
              //    obscureText: hidepassword,
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(Icons.lock_open),
              //     suffixIcon: IconButton(
              //      icon: Icon(
              //          hidepassword ? Icons.visibility_off : Icons.visibility),
              //     onPressed: () {
              //      setState(() {
              //         hidepassword = !hidepassword;
              //      });
              //    },
              // ),
              //    border: OutlineInputBorder(),
              //    labelText: 'Confirm Password',
              //  ),
              //   validator: (value) {
              //   if (value.isEmpty) {
              //     return "Please Enter Password Again";
              //   } else if (value != _passwordController.text) {
              //     return 'Passwords do not match!';
              //   }
//
              //    return null;
              //  },
              //   ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: _submit,
                      child: Text(
                        "Sign Up",
                      ),
                      shape: StadiumBorder()),
                  Spacer(),
                  Text('Already a User ?  '),
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(UserLoginScreen.routeName);
                      },
                      child: Text(
                        "Sign In",
                      ),
                      shape: StadiumBorder()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
