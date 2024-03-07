import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminVerificationList(),
    const AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: const Duration(milliseconds: 800),
              tabBackgroundColor: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabActiveBorder: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminVerificationList extends StatelessWidget {
  const AdminVerificationList({Key? key}) : super(key: key);

  void _acceptVerification(String userType, String docId) {
    FirebaseFirestore.instance.collection(userType).doc(docId).update({'verified': '1'});
  }

  void _declineVerification() {
    // You can add specific logic for declining, if needed
  }

  Widget _buildVerificationList(QuerySnapshot<Map<String, dynamic>> snapshot, String userType) {
    final docs = snapshot.docs;

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Name: ${docs[index]['name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${docs[index]['email']}'),
                Text('Spec: ${docs[index]['spec']}'),
                Text('Card Url: ${docs[index]["cardUrl"]}'),
              ],
            ),
            onTap: () {
              // Navigate to CardPhotoPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardPhotoPage(
                    cardUrl: docs[index]["cardUrl"],
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _acceptVerification(userType, docs[index].id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _declineVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Doctors and Pharmacists Waiting for Verification',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('doctors').where('verified', isEqualTo: '0').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return _buildVerificationList(snapshot.data!, 'doctors');
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('pharmacist').where('verified', isEqualTo: '0').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return _buildVerificationList(snapshot.data!, 'pharmacist');
            },
          ),
        ),
      ],
    );
  }
}

class CardPhotoPage extends StatelessWidget {
  final String cardUrl;

  const CardPhotoPage({Key? key, required this.cardUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Card URL: $cardUrl');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Id Photo'),
      ),
      body: Center(
        child: cardUrl.isNotEmpty
            ? Image.network(
          cardUrl,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return const Icon(Icons.error);
          },
        )
            : const Text('Invalid card URL'),
      ),
    );
  }
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdminProfilePage();
  }
}

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/admin_profile_image.jpg'), // Replace with your image path
          ),
          const SizedBox(height: 20),
          const Text(
            'Admin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'start');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'analysis');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text(
              'Go to Analysis',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
