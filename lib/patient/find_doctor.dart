import 'package:flutter/material.dart';

class FindDoctor extends StatefulWidget {
  const FindDoctor({super.key});

  @override
  _FindDoctorState createState() => _FindDoctorState();
}

class _FindDoctorState extends State<FindDoctor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/4907157.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 10),
              child: const Text(
                'Find \nA Doctor',
                style: TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.14,
                  left: 35,
                  right: 35,
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Doctor username (ID)",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 350,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            //padding: EdgeInsets.only(top: 50),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, 'pt_chat');
                            },
                            icon: const Icon(
                              Icons.chat,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            //padding: EdgeInsets.only(top: 50),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, 'pt_home');
                            },
                            icon: const Icon(
                              Icons.home,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            //padding: EdgeInsets.only(top: 50),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, 'pt_profile');
                            },
                            icon: const Icon(
                              Icons.account_box,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            //padding: EdgeInsets.only(top: 50),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, 'pt_profile');
                            },
                            icon: const Icon(
                              Icons.alarm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
