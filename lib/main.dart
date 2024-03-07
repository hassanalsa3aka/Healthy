import 'package:flutter/material.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/admin/ad_home.dart';
import 'package:healthy/admin/admin_login.dart';
import 'package:healthy/admin/anylsis.dart';
import 'package:healthy/ai_model/heart_disease.dart';
import 'package:healthy/chatbot/MProvider.dart';
import 'package:healthy/chatbot/chatbot.dart';
import 'package:healthy/chatbot/chathelper.dart';
import 'package:healthy/clander/clander.dart';
import 'package:healthy/doctor/add_patient.dart';
import 'package:healthy/doctor/doctor_chat.dart';
import 'package:healthy/doctor/doctor_home.dart';
import 'package:healthy/doctor/doctor_profile.dart';
import 'package:healthy/doctor/doctor_signin.dart';
import 'package:healthy/doctor/doctor_signup.dart';
import 'package:healthy/doctor/patient%20of%20doctor.dart';
import 'package:healthy/google_map/add%20location.dart';
import 'package:healthy/google_map/view_map.dart';
import 'package:healthy/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthy/patient/doctor%20of%20patient.dart';
import 'package:healthy/patient/find_doctor.dart';
import 'package:healthy/patient/patient_chat.dart';
import 'package:healthy/patient/patient_home.dart';
import 'package:healthy/patient/patient_med.dart';
import 'package:healthy/patient/patient_profile.dart';
import 'package:healthy/patient/patient_signin.dart';
import 'package:healthy/patient/patient_signup.dart';
import 'package:healthy/patient/personal_information.dart';
import 'package:healthy/pharmaceutical/Pharm_signin.dart';
import 'package:healthy/pharmaceutical/pharm_home.dart';
import 'package:healthy/pharmaceutical/pharm_profile.dart';
import 'package:healthy/pharmaceutical/pharm_pt.dart';
import 'package:healthy/pharmaceutical/pharm_signup.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (_) => Localprovider(), child: const MyApp()));
}


class  MyApp  extends StatelessWidget {
  const  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'start',
        routes: {
          //routes refers to pages/screens
          'start': (context) =>  const Mainpage(),
          'dr_register': (context) => const DoctorSignUpPage(),
          'dr_home': (context) => const Doctorhome(),
          'add_patient': (context) => const AddPatient(),
          'dr_patients': (context) => const DrPatients(),
          'dr_chats': (context) => const DrChats(),
          'dr_profile': (context) => const DrProfile(),
          'ad_login': (context) =>  const AdminSignInPage(),
          'pt_chat': (context) =>  PtChat(),
          'pt_profile': (context) => const PtProfile(),
          'pt_home': (context) => const PtHome(),
          'pt_doctors': (context) => const PtDoctors(),
          'find_doctor': (context) => const FindDoctor(),
          'pt_med_his': (context) => const PtMedHis(),
          'pharm_signup':(context) =>  const PharmSignUpPage(),
          'pharm_home':(context) => const  Pharmhome(),
          'chatbot':(context) => const  Healthybot(),
          'heart':(context) =>   const Heart(),
          'signin_dr': (context) =>  const DoctorSignInPage(),
          'signin_pt': (context) =>  const PatientSignInPage(),
          'signin_ph': (context) =>  const PharmacistSignInPage(),
          'home_ad': (context) =>  const AdminHomePage(),
          'signup_pt': (context) =>  const PatientSignUpPage(),
          'calendar': (context) =>  CalendarPage(),
          'addmap': (context) =>  const LocationsPage(),
          'map': (context) =>  const ViewMapPage(),
          'personal': (context) =>  const PersonalInfoPage(),
          'analysis': (context) => AnalysisPage(),
          'pt_report': (context) => PatientReportsPage(),
          'ph_profile': (context) => Pharm(),
        },
      ),
    );
  }
}








