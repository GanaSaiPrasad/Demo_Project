import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobilePlayGround1/ShoppingApp/models/http_exception.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_login_service.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_register_screen.dart';
import 'package:provider/provider.dart';

class UserLoginScreen extends StatefulWidget {
  static const routeName = '/user_login';
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  Map<String, dynamic> _userData = {
    "UserName": "",
    "Password": "",
  };
  bool isLoading = false;
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

  bool hidePassword = false;

  Future<void> _signIn() async {
    _loginFormKey.currentState.validate();

    _loginFormKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<LoginAuthorization>(context, listen: false)
          .signIn(_userData["UserName"], _userData["Password"]);
    } on Http_Exception catch (error) {
      var errorMessage = 'Authentication Failed';

      if (error.toString().contains(' confirm your email')) {
        errorMessage = error.toString();
      } else if (error.toString().contains(' Account does Not Exist')) {
        errorMessage = error.toString();
      } else if (error.toString().contains(' incorrect password')) {
        errorMessage = error.toString();
      }
      displayErrorMessage(errorMessage);
    } catch (error) {
      var errorMessage = 'Unknown Error Ocurred.Please Try Again Later';

      displayErrorMessage(errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User SignIn"),
      ),
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
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.done,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator:
                        RequiredValidator(errorText: "Please Enter Password"),
                    onSaved: (value) {
                      _userData["Password"] = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (isLoading)
                        CircularProgressIndicator()
                      else
                        RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: _signIn,
                            child: Text(
                              "Sign In",
                            ),
                            shape: StadiumBorder()),
                      Spacer(),
                      Text('New User ?  '),
                      RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                UserRegisterScreen.routeName);
                          },
                          child: Text(
                            "Sign Up",
                          ),
                          shape: StadiumBorder()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
