import '../SharedParts/loadingScreen.dart';
import '../SharedParts/constants.dart';
import '../services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFFE8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        title: Text('Sign In'),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {widget.toggleView();},
              icon: Icon(Icons.person),
              label: Text("Register")
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 6 ? 'Enter password 6+ characters' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.signInEmail(email, password);
                        if(result == null){
                          setState(() => error = "invalid email or password");
                          loading = false;
                        }
                      }
                    }
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}