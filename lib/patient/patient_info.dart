import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PtInfo extends StatefulWidget {
  const PtInfo({super.key});

  @override
  _PtInfoState createState() => _PtInfoState();
}

class _PtInfoState extends State<PtInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dobController = TextEditingController();
  String? _gender;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadFromSharedPreferences();
  // }

  // Future<void> _loadFromSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _nameController.text = prefs.getString('name') ?? '';
  //     _emailController.text = prefs.getString('email') ?? '';
  //     _phoneController.text = prefs.getString('phone') ?? '';
  //     _heightController.text = prefs.getDouble('height')?.toString() ?? '';
  //     _weightController.text = prefs.getDouble('weight')?.toString() ?? '';
  //     _dobController.text = prefs.getString('dob') ?? '';
  //     _gender = prefs.getString('gender');
  //   });
  // }
  //
  // Future<void> _saveToSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('name', _nameController.text);
  //   prefs.setString('email', _emailController.text);
  //   prefs.setString('phone', _phoneController.text);
  //   prefs.setDouble('height', double.tryParse(_heightController.text) ?? 0);
  //   prefs.setDouble('weight', double.tryParse(_weightController.text) ?? 0);
  //   prefs.setString('dob', _dobController.text);
  //   prefs.setString('gender', _gender ?? '');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dobController,
                decoration:
                const InputDecoration(labelText: 'Date of Birth (dd/mm/yyyy)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Gender', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Male'),
                  const SizedBox(width: 16),
                  Radio<String>(
                    value: 'female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                  if (_formKey.currentState?.validate() == true) {
                    // Save the user's information to Firebase
                    setState(() {
                      // _saveToSharedPreferences;
                      _isLoading = true;
                    });
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        throw Exception('User is not authenticated');
                      }
                      final userId = user.uid;
                      final docRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('personal_information')
                          .doc();
                      final data = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'height': double.parse(_heightController.text),
                        'weight': double.parse(_weightController.text),
                        'dob': _dobController.text,
                        'gender': _gender,
                      };
                      await docRef.set(data);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Success!'),
                            content:
                            const Text('Your information has been saved.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'An error occurred while saving your information.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
