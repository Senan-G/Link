import '../services/auth.dart';
import '../SharedParts/loadingScreen.dart';
import '../SharedParts/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String error = '';
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFFE8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        title: Text('Register'),
          actions: <Widget>[
          TextButton.icon(
              onPressed: () {widget.toggleView();},
              icon: Icon(Icons.person),
              label: Text("Sign In")
          )
        ]
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
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(_dateTime)),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                        child: Text(
                          'Select Birthday',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                        ),
                        onPressed: ()  {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2030)
                          ).then((date){
                            setState(() {
                              _dateTime = date!;
                            });
                          }
                          );
                        }
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, _dateTime);
                        if(result == null){
                          setState(() => error = "please supply a valid email");
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