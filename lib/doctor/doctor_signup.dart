import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DoctorSignUpPage extends StatefulWidget {
  const DoctorSignUpPage({Key? key}) : super(key: key);

  @override
  _DoctorSignUpPageState createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State<DoctorSignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _specController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: getImage,
                child: _image == null
                    ? Image.asset(
                  'assets/images/doctorsigin.png', // Replace with your placeholder image
                  height: 150,
                )
                    : Image.file(
                  _image!,
                  height: 150,
                ),
              ),
              const SizedBox(height: 10),
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
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'National ID',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _specController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: getImage,
                child: TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Image',
                    prefixIcon: Icon(Icons.image),
                    suffixIcon: Icon(Icons.camera_alt),
                  ),
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
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signin_dr');
                },
                child: Text(
                  "I have an account",
                  style: GoogleFonts.lato(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: const Color.fromRGBO(83, 113, 136, 1),
                  ),
                ),
              ),
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
    final String spec = _specController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || nationalId.isEmpty || spec.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required.'),
        ),
      );
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image.'),
        ),
      );
      return;
    }

    // Check National ID before proceeding with sign-up
    bool isValidNationalId = await _checkNationalId(nationalId);

    if (isValidNationalId) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for verification'),
          ),
        );

        // Create a user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload the image to Firebase Storage
        String imageUrl = await _uploadImage(userCredential.user!.uid);

        // Add user data to Firestore
        await FirebaseFirestore.instance.collection('doctors').doc(userCredential.user!.uid).set({
          'cardUrl': imageUrl,
          'name': name,
          'email': email,
          'phone': phone,
          'nationalId': nationalId,
          'spec': spec,
          'verified': '0',
          // Add more fields as needed
        });

        // Close the loading dialog
        Navigator.pop(context);

        // Navigate to the 'start' page or any other page after successful sign-up
        Navigator.pushReplacementNamed(context, 'start');
      } on FirebaseAuthException catch (e) {
        // Close the loading dialog
        Navigator.pop(context);

        // Handle authentication exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
          ),
        );
      } catch (e) {
        // Close the loading dialog
        Navigator.pop(context);

        // Handle other exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred.'),
          ),
        );
      }
    } else {
      // National ID is not valid, show appropriate message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This National ID already has an account.'),
        ),
      );
    }
  }

  Future<bool> _checkNationalId(String nationalId) async {
    try {
      // Check if the National ID exists in the 'doctors' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('nationalId', isEqualTo: nationalId)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      // Handle exceptions, if any
      print(e.toString());
      // You may want to show an error message to the user
      return false;
    }
  }

  Future<String> _uploadImage(String userId) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('Media/$userId');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() => null); // Add await here
      return await storageReference.getDownloadURL();
    } catch (e) {
      // Handle image upload errors
      return '';
    }
  }
}
