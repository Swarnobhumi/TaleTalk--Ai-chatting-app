import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taletalk/CustomClasses/UserContactModel.dart';
import 'package:taletalk/CustomClasses/UserDataModel.dart';
import 'package:taletalk/NavPages/ChattingPage.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> allContacts = [];
  Set<UserContactModel> registeredContacts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      // Reference to the Firestore collection where user data is stored
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Return the data as a Map
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User with ID $userId does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      var deviceContacts = (await FastContacts.getAllContacts())
          .where((contact) =>
      (contact.displayName?.isNotEmpty ?? false) && contact.phones.isNotEmpty)
          .toList();

      List<String> phoneNumbers = deviceContacts
          .expand((contact) => contact.phones.map((phone) => phone.number.replaceAll("+91", '').trim()))
          .toList();

      List<List<String>> chunks = [];
      for (int i = 0; i < phoneNumbers.length; i += 30) {
        chunks.add(phoneNumbers.sublist(i, i + 30 > phoneNumbers.length ? phoneNumbers.length : i + 30));
      }

      // Run Firestore queries concurrently for faster data retrieval
      List<Future<QuerySnapshot>> queries = chunks.map((chunk) {
        return FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber')
            .get();
      }).toList();

      Set<UserContactModel> registered = {};
      for (var future in queries) {
        registered.clear();
        QuerySnapshot snapshot = await future;
        for (var doc in snapshot.docs) {
          registered.add(UserContactModel(
            userId: doc["userId"],
            name: doc["name"],
            phoneNumber: doc["phoneNumber"].toString(),
            profilePic: doc["profilePic"],
            about: doc["about"],
          ));

        }
      }

      if(await Hive.boxExists("User")){
        var box = await Hive.openBox("User");
        fetchUserData(FirebaseAuth.instance.currentUser!.uid).then((value) async {
          await box.put("userInfo", value);
          UserDataModel userDataModel = UserDataModel.toUserDataModel(value!);
          // Remove current user from registered contacts
          registered.removeWhere((contact) => contact.phoneNumber == userDataModel.phoneNumber.toString());

        },);
      }else{
        var box = await Hive.openBox("User");
        Map<String, dynamic> map = box.get("userInfo");
        UserDataModel userDataModel = UserDataModel.toUserDataModel(map);
        // Remove current user from registered contacts
        registered.removeWhere((contact) => contact.phoneNumber == userDataModel.phoneNumber.toString());


      }

      // Sort device contacts
      deviceContacts.sort((a, b) => (a.displayName ?? '').compareTo(b.displayName ?? ''));

      setState(() {
        allContacts = deviceContacts;
        registeredContacts = registered;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts")),
      body: isLoading ? buildShimmer() : buildContactList(),
    );
  }



  // Shimmer loading effect
  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(width: 150.0, height: 15.0, color: Colors.white),
            subtitle: Container(width: 100.0, height: 15.0, color: Colors.white),
            leading: CircleAvatar(backgroundColor: Colors.white),
          ),
        );
      },
    );
  }

  // Display contact list with headers for registered and non-registered
  Widget buildContactList() {
    // Create a Set of registered phone numbers for quick lookup
    Set<String> registeredPhoneNumbers = registeredContacts
        .map((e) => e.phoneNumber.replaceAll("+91", '').trim())
        .toSet();

    // Filter allContacts to exclude registered contacts
    List<Contact> nonRegisteredContacts = allContacts.where((contact) {
      return !contact.phones.any((phone) {
        String formattedNumber = phone.number.replaceAll("+91", '').trim();
        return registeredPhoneNumbers.contains(formattedNumber);
      });
    }).toList();

    return ListView(
      children: [
        if (registeredContacts.isNotEmpty) ...[
          buildHeader("Registered Contacts"),
          ...registeredContacts.map((contact) {
            // Find the corresponding device contact with safe null handling
            Contact? deviceContact;
            try {
              deviceContact = allContacts.firstWhere(
                    (deviceContact) => deviceContact.phones.any(
                      (phone) => phone.number.replaceAll("+91", '').trim() == contact.phoneNumber,
                ),
              );
            } catch (e) {
              deviceContact = null; // Set to null if no match found
            }

            // If no matching contact is found, skip this iteration
            if (deviceContact == null) {
              return SizedBox.shrink();
            }
            return registredContactCards(contact, deviceContact);
          }).toList(), // Avoid nulls directly in the list
        ],
        if (nonRegisteredContacts.isNotEmpty) ...[
          buildHeader("Non-Registered Contacts"),
          ...nonRegisteredContacts.map((contact) =>
              buildContactTile(contact, false)).toList(),
        ],
      ],
    );
  }


  Widget buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildContactTile(Contact contact, bool isRegistered) {
    return ListTile(
      title: Text(contact.displayName ?? "Unknown"),
      subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number ?? "" : ""),
      trailing: isRegistered
          ? Icon(Icons.check_circle, color: Colors.green)
          : ElevatedButton(
        onPressed: () {
          print("Invite ${contact.displayName}");
        },
        child: Text("Invite"),
      ),
    );
  }

  Widget registredContactCards(UserContactModel userContactModel, Contact deviceContact ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingPage(userContactModel: userContactModel, contact: deviceContact,),));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: userContactModel.profilePic != null && userContactModel.profilePic.isNotEmpty
                ? NetworkImage(userContactModel.profilePic)
                : AssetImage("assets/default_profile_pic.png") as ImageProvider,
          ),
          title: Text(deviceContact?.displayName??"Unknown"),
          subtitle: Text(userContactModel.about),
        ),
      ),
    );
  }
}
