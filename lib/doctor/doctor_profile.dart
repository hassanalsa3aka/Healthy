import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:provider/provider.dart';

class DrProfile extends StatefulWidget {
  const DrProfile({Key? key});

  @override
  _DrProfileState createState() => _DrProfileState();
}

class _DrProfileState extends State<DrProfile> {
  // show the dialog

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.lato(
            color:  Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Colors.black, Colors.black87],
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: -60,
                  left: 40,
                  child: Image(image: AssetImage('assets/images/12.png')),
                ),
                Positioned(
                  top: 140,
                  left: 50,
                  child: Text(
                    'Dr:  ${Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName}',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Colors.black, Colors.black87],
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Text(
                        'Delete My Account',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Widget cancelButton = TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        );
                        Widget continueButton = TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.pushNamed(context, 'start');
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: const Text("Your account will be deleted"),
                          content: const Text(
                            "Are you sure you want to delete your account?",
                          ),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Log out logic here
                  Navigator.pushNamed(context, 'start');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
