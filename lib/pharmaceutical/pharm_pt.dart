import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientReportsPage extends StatefulWidget {
  @override
  _PatientReportsPageState createState() => _PatientReportsPageState();
}

class _PatientReportsPageState extends State<PatientReportsPage> {
  TextEditingController _emailController = TextEditingController();
  List<String> reports = [];

  Future<void> searchReports() async {
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      try {
        // Fetch the patient by email
        QuerySnapshot<Map<String, dynamic>> patientSnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .where('email', isEqualTo: email)
            .get();

        if (patientSnapshot.docs.isNotEmpty) {
          // Retrieve the patient's reports
          DocumentSnapshot<Map<String, dynamic>> patientDoc = patientSnapshot.docs.first;
          List<dynamic> patientReports = patientDoc['reports'];

          // Update the UI with the reports
          setState(() {
            reports = List<String>.from(patientReports.map((report) => report.toString()));
          });
        } else {
          // No patient found with the given email
          setState(() {
            reports = [];
          });
          _showSnackBar('No patient found with the provided email.');
        }
      } catch (e) {
        // Handle errors
        print('Error: $e');
        _showSnackBar('Error retrieving reports. Please try again.');
      }
    } else {
      _showSnackBar('Please enter a valid email.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Patient Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Patient Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: searchReports,
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Set the button color to black
              ),
              child: Text(
                'Search Reports',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            if (reports.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Reports for ${_emailController.text}:'),
                  SizedBox(height: 10),
                  for (String report in reports)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(report),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


