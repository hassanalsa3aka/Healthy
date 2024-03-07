import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int numberOfDoctors = 0;
  int numberOfPatients = 0;
  int numberOfPharmacists = 0;
  int totalHealthyUsersCount = 0;
  int falseAnswersUsersCount = 0;
  int anemiaTrueCount = 0;
  int cancerTrueCount = 0;
  int diabetesTrueCount = 0;
  int heartAttackTrueCount = 0;
  int heartProblemsTrueCount = 0;
  int highBloodPressureTrueCount = 0;
  int highCholesterolTrueCount = 0;
  int kidneyDiseaseTrueCount = 0;
  int liverDiseaseTrueCount = 0;
  int otherMedicalIssuesTrueCount = 0;
  int strokeTrueCount = 0;
  int egyptUsersCount = 0;
  int gizaUsersCount = 0;
  int cairoUsersCount = 0;
  int maleUsersCount = 0;
  int femaleUsersCount = 0;
  int maleCairoUsersCount = 0;
  int femaleCairoUsersCount = 0;
  int maleGizaUsersCount = 0;
  int femaleGizaUsersCount = 0;

  Future<void> fetchData() async {
    // Fetch data from Cloud Firestore 'doctors' collection
    QuerySnapshot<Map<String, dynamic>> doctorsSnapshot =
    await FirebaseFirestore.instance.collection('doctors').get();
    setState(() {
      numberOfDoctors = doctorsSnapshot.size;
    });

    // Fetch data from Cloud Firestore 'patients' collection
    QuerySnapshot<Map<String, dynamic>> patientsSnapshot =
    await FirebaseFirestore.instance.collection('patients').get();
    setState(() {
      numberOfPatients = patientsSnapshot.size;
    });

    // Fetch data from Cloud Firestore 'pharmacist' collection
    QuerySnapshot<Map<String, dynamic>> pharmacistsSnapshot =
    await FirebaseFirestore.instance.collection('pharmacist').get();
    setState(() {
      numberOfPharmacists = pharmacistsSnapshot.size;
    });

    // Fetch data from Cloud Firestore 'healthConditions' collection
    QuerySnapshot<Map<String, dynamic>> healthConditionsSnapshot =
    await FirebaseFirestore.instance.collection('healthConditions').get();
    setState(() {
      totalHealthyUsersCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['allFalse'] == true)
          .length;

      falseAnswersUsersCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['allFalse'] == true)
          .length;

      anemiaTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Anemia'] == true)
          .length;

      cancerTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Cancer'] == true)
          .length;

      diabetesTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Diabetes'] == true)
          .length;

      heartAttackTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Heart Attack'] == true)
          .length;

      heartProblemsTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Heart Problems'] == true)
          .length;

      highBloodPressureTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['High Blood Pressure'] == true)
          .length;

      highCholesterolTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['High Cholesterol'] == true)
          .length;

      kidneyDiseaseTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Kidney Disease'] == true)
          .length;

      liverDiseaseTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Liver Disease'] == true)
          .length;

      otherMedicalIssuesTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Other Medical Issues'] == true)
          .length;

      strokeTrueCount = healthConditionsSnapshot.docs
          .where((doc) => doc.data()['Stroke'] == true)
          .length;
    });

    // Fetch data from Cloud Firestore 'personalinformation' collection
    QuerySnapshot<Map<String, dynamic>> personalInfoSnapshot =
    await FirebaseFirestore.instance.collection('personalinformation').get();
    setState(() {
      egyptUsersCount = personalInfoSnapshot.docs
          .where((doc) => doc.data()['country'] == 'egypt')
          .length;

      gizaUsersCount = personalInfoSnapshot.docs
          .where((doc) => doc.data()['governorate'] == 'giza')
          .length;

      cairoUsersCount = personalInfoSnapshot.docs
          .where((doc) => doc.data()['governorate'] == 'cairo')
          .length;

      maleUsersCount = personalInfoSnapshot.docs
          .where((doc) => doc.data()['gender'] == 'Male')
          .length;

      femaleUsersCount = personalInfoSnapshot.docs
          .where((doc) => doc.data()['gender'] == 'Female')
          .length;

      maleCairoUsersCount = personalInfoSnapshot.docs
          .where((doc) =>
      doc.data()['gender'] == 'Male' &&
          doc.data()['governorate'] == 'cairo')
          .length;

      femaleCairoUsersCount = personalInfoSnapshot.docs
          .where((doc) =>
      doc.data()['gender'] == 'Female' &&
          doc.data()['governorate'] == 'cairo')
          .length;

      maleGizaUsersCount = personalInfoSnapshot.docs
          .where((doc) =>
      doc.data()['gender'] == 'Male' &&
          doc.data()['governorate'] == 'giza')
          .length;

      femaleGizaUsersCount = personalInfoSnapshot.docs
          .where((doc) =>
      doc.data()['gender'] == 'Female' &&
          doc.data()['governorate'] == 'giza')
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildText('Number of Doctors: $numberOfDoctors'),
              buildText('Number of Patients: $numberOfPatients'),
              buildText('Number of Pharmacists: $numberOfPharmacists'),
              SizedBox(height: 20),
              buildText('Total Healthy Users: $totalHealthyUsersCount'),
              buildText('False Answers Users: $falseAnswersUsersCount'),
              buildText('Anemia True Count: $anemiaTrueCount'),
              buildText('Cancer True Count: $cancerTrueCount'),
              buildText('Diabetes True Count: $diabetesTrueCount'),
              buildText('Heart Attack True Count: $heartAttackTrueCount'),
              buildText('Heart Problems True Count: $heartProblemsTrueCount'),
              buildText(
                  'High Blood Pressure True Count: $highBloodPressureTrueCount'),
              buildText('High Cholesterol True Count: $highCholesterolTrueCount'),
              buildText('Kidney Disease True Count: $kidneyDiseaseTrueCount'),
              buildText('Liver Disease True Count: $liverDiseaseTrueCount'),
              buildText(
                  'Other Medical Issues True Count: $otherMedicalIssuesTrueCount'),
              buildText('Stroke True Count: $strokeTrueCount'),
              SizedBox(height: 20),
              buildText('Users in Egypt: $egyptUsersCount'),
              buildText('Users in Giza: $gizaUsersCount'),
              buildText('Users in Cairo: $cairoUsersCount'),
              buildText('Male Users: $maleUsersCount'),
              buildText('Female Users: $femaleUsersCount'),
              buildText('Male Users in Cairo: $maleCairoUsersCount'),
              buildText('Female Users in Cairo: $femaleCairoUsersCount'),
              buildText('Male Users in Giza: $maleGizaUsersCount'),
              buildText('Female Users in Giza: $femaleGizaUsersCount'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  fetchData();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Text('Generate', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'chatbot');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Text('Chatbot', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}


