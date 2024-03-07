import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy/patient/patient_home.dart';
import 'package:healthy/snakbar.dart';

class PatientSignUpPage extends StatefulWidget {
  const PatientSignUpPage({super.key});

  @override
  _PatientSignUpPageState createState() => _PatientSignUpPageState();
}

class _PatientSignUpPageState extends State<PatientSignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/patient.png', // Replace with your image path
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'National ID',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
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
                  _signUp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.kellySlab(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signin_pt');
                },
                child: const Text('Have an account? Sign In',
                  style: TextStyle(color: Colors.black),),),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp(BuildContext context) async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();
    final String nationalId = _nationalIdController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || nationalId.isEmpty || password.isEmpty) {
      // Show an error message or Snackbar for missing fields
      return;
    }

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
      // Check if nationalId already exists in Firestore
      var collection = FirebaseFirestore.instance.collection('patients');
      var querySnapshot = await collection.where('nationalId', isEqualTo: nationalId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // National ID already exists
        Navigator.pop(context); // Close the loading dialog
        buildShowSnackBar(context, 'National ID already has an account');
        return;
      }

      // Create a user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the nationalId as User UID
      await userCredential.user!.updateDisplayName(nationalId);

      // Add user data to Firestore
      await FirebaseFirestore.instance.collection('patients').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'nationalId': nationalId,
        // Add more fields as needed
      });

      Navigator.pop(context); // Close the loading dialog

      // Navigate to PtHome() or any other page after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PtHome(),
        ),
      );
    } on FirebaseAuthException {
      Navigator.pop(context); // Close the loading dialog
      // Handle authentication exceptions
      // You can show appropriate error messages based on the exception code
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      // Handle other exceptions
    }
  }

}
