import 'dart:math';

import 'package:flutter/material.dart';



class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController trestbpsController = TextEditingController();
  final TextEditingController cholController = TextEditingController();
  final TextEditingController fbsController = TextEditingController();
  final TextEditingController restecgController = TextEditingController();
  final TextEditingController thalachController = TextEditingController();
  final TextEditingController exangController = TextEditingController();
  final TextEditingController oldpeakController = TextEditingController();
  final TextEditingController slopeController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController thalController = TextEditingController();

  int predictionResult = -1;

  void _makePrediction() {
    final List<double> inputInstance = [
      double.parse(ageController.text),
      double.parse(sexController.text),
      double.parse(cpController.text),
      double.parse(trestbpsController.text),
      double.parse(cholController.text),
      double.parse(fbsController.text),
      double.parse(restecgController.text),
      double.parse(thalachController.text),
      double.parse(exangController.text),
      double.parse(oldpeakController.text),
      double.parse(slopeController.text),
      double.parse(caController.text),
      double.parse(thalController.text),
    ];

    final int prediction = predict(model, inputInstance);

    setState(() {
      predictionResult = prediction;
    });

    // Display the prediction
    if (prediction == 0) {
      print('The Person does not have a Heart Disease');
    } else {
      print('The Person has Heart Disease');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Disease Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter values for prediction:'),
            // Create input fields for each feature
            Expanded(
              child: ListView(
                children: [
                  buildInputField('Age', ageController),
                  buildInputField('Sex', sexController),
                  buildInputField('Chest Pain Type (cp)', cpController),
                  buildInputField('Resting Blood Pressure (trestbps)', trestbpsController),
                  buildInputField('Serum Cholesterol (chol)', cholController),
                  buildInputField('Fasting Blood Sugar (fbs)', fbsController),
                  buildInputField('Resting Electrocardiographic Results (restecg)', restecgController),
                  buildInputField('Maximum Heart Rate Achieved (thalach)', thalachController),
                  buildInputField('Exercise Induced Angina (exang)', exangController),
                  buildInputField('Oldpeak', oldpeakController),
                  buildInputField('Slope of the Peak Exercise ST Segment (slope)', slopeController),
                  buildInputField('Number of Major Vessels (0-3) Colored by Flourosopy (ca)', caController),
                  buildInputField('Thalassemia (thal)', thalController),
                ],
              ),
            ),
            const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _makePrediction,
                child: const Text('Make Prediction'),
              ),

            const SizedBox(height: 16),
            if (predictionResult != -1)
              Text(
                'Prediction Result: ${predictionResult == 0 ? "No Heart Disease" : "Heart Disease"}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: predictionResult == 0 ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Logistic Regression Model
  LogisticRegressionModel model = LogisticRegressionModel();

  // Function to make a prediction
  int predict(LogisticRegressionModel model, List<double> inputInstance) {
    return (model.predict(inputInstance) >= 0.5) ? 1 : 0;
  }
}

// Logistic Regression Model
class LogisticRegressionModel {
  List<double> coefficients = [];
  double intercept = 0.0;

  LogisticRegressionModel() {
    // Initialize coefficients based on your trained model
    // Replace the following coefficients with your trained model coefficients
    coefficients = [-0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 1.1, -1.2, 1.3];
    intercept = 0.4;
  }

  double predict(List<double> features) {
    double linearModel = intercept;
    for (int i = 0; i < coefficients.length; i++) {
      linearModel += coefficients[i] * features[i];
    }
    return sigmoid(linearModel);
  }

  double sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }
}
