import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Personal Information App',
      home: PersonalInfoPage(),
    );
  }
}

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _zoneAreaController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _gender = 'Male';
  String _smokingStatus = 'No';
  String _drugUsage = 'No';

  final NumberFormat _numberFormat = NumberFormat('###.0#');
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final CollectionReference _personalInfoCollection =
  FirebaseFirestore.instance.collection('personalinformation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}$'))],
                decoration: const InputDecoration(labelText: 'Height (cm)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}$'))],
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                items: ['Male', 'Female'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _governorateController,
                decoration: const InputDecoration(labelText: 'Governorate'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zoneAreaController,
                decoration: const InputDecoration(labelText: 'Zone/Area'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _smokingStatus,
                onChanged: (value) {
                  setState(() {
                    _smokingStatus = value!;
                  });
                },
                items: ['Yes', 'No'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Do you smoke?'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _drugUsage,
                onChanged: (value) {
                  setState(() {
                    _drugUsage = value!;
                  });
                },
                items: ['Yes', 'No'].map((usage) {
                  return DropdownMenuItem(
                    value: usage,
                    child: Text(usage),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Do you take drugs?'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Date of Birth (YYYYMMDD)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _savePersonalInfo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePersonalInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocument = _personalInfoCollection.doc(user.email);

      userDocument.set({
        'height': _numberFormat.format(double.parse(_heightController.text)),
        'weight': _numberFormat.format(double.parse(_weightController.text)),
        'gender': _gender,
        'country': _countryController.text,
        'governorate': _governorateController.text,
        'zoneArea': _zoneAreaController.text,
        'smokingStatus': _smokingStatus,
        'drugUsage': _drugUsage,
        'dob': _dateFormat.format(DateTime.parse(_dobController.text)),
      }).then((value) {
        print('Personal information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The data has been saved'),
          ),
        );
      }).catchError((error) {
        print('Error saving personal information: $error');
      });
    } else {
      print('User not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
        ),
      );
    }
  }
}
