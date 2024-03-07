import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/patient/patient_home.dart';
import 'package:healthy/snakbar.dart';

class PatientSignInPage extends StatefulWidget {
  const PatientSignInPage({super.key});

  @override
  _PatientSignInPageState createState() => _PatientSignInPageState();
}

class _PatientSignInPageState extends State<PatientSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'start');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/patient.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signIn(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.kellySlab(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signup_pt');

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      buildShowSnackBar(context, "You forgot something");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if the user exists in the Firestore patients collection
        var collection = FirebaseFirestore.instance.collection('patients');
        var docSnapshot = await collection.doc(userCredential.user!.uid).get();

        if (!docSnapshot.exists) {
          Navigator.pop(context);
          buildShowSnackBar(context, "User doesn't exist as a patient");
          return;
        }

        Navigator.pop(context); // Close the loading dialog

        // Navigate to PtHome()
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PtHome(),
          ),
        );

      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
          buildShowSnackBar(context, "User doesn't exist as a patient");
        } else if (e.code == 'wrong-password') {
          buildShowSnackBar(context, "Wrong password");
        } else {
          buildShowSnackBar(context, "User doesn't exist as a patient");
        }
      } catch (e) {
        Navigator.pop(context);
        buildShowSnackBar(context, "An error occurred, please try again.");
      }
    }
  }

}
