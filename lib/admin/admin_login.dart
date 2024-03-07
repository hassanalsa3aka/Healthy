import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatefulWidget {
  const AdminSignInPage({super.key});

  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _errorMessage != '' && _errorMessage.contains('email') ? _errorMessage : null,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _errorMessage != '' && _errorMessage.contains('password') ? _errorMessage : null,
                  ),
                ),
                const SizedBox(height: 20.0),
                if (_isLoading) const CircularProgressIndicator(),
                if (!_isLoading)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      await FirebaseFirestore.instance.collection('admin').doc('adminaccount').get().then((snapshot) {
                        if (snapshot.exists) {
                          var adminData = snapshot.data();
                          if (adminData?['adminemail'] == _emailController.text && adminData?['adminpassword'] == _passwordController.text) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(context, 'home_ad');
                          } else {
                            setState(() {
                              _isLoading = false;
                              _errorMessage = 'Invalid email or password.';
                            });
                          }
                        } else {
                          setState(() {
                            _isLoading = false;
                            _errorMessage = 'Invalid email or password.';
                          });
                        }
                      });
                    },
                    child: const Text('Sign In'),
                  ),
                if (_errorMessage != '') Text(_errorMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

