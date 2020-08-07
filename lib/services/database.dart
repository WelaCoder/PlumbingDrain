// import 'package:brew_crew/models/User.dart';
// import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plumbing_drain/models/User.dart';

class DatabaseService {
  final String uid;
  final String currentCustomer;

  //Constructor
  DatabaseService({this.uid, this.currentCustomer});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  //  Brews Stream
  // Stream<List<Brew>> get brews {
  //   return userCollection.snapshots().map(_brewsfromQuerySnapshot);
  // }

  UserData _userDataFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        username: snapshot.data['username'],
        image: snapshot.data['image'],
        balance: snapshot.data['balance'],
        role: snapshot.data['role']);
  }

// UserData Stream
  Stream<UserData> get userData {
    return userCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromDocumentSnapshot);
  }

  Stream get customers {
    return userCollection
        .where('role', isEqualTo: 'customer')
        .snapshots()
        .map((event) => event.documents);
  }

  Stream get leads {
    return userCollection
        .document(currentCustomer)
        .collection('leads')
        .snapshots()
        .map((event) => event.documents);
  }

  // List<Brew> _brewsfromQuerySnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     return Brew(
  //         name: doc.data['name'] ?? '',
  //         sugars: doc.data['sugars'] ?? '0',
  //         strength: doc.data['strength'] ?? 100);
  //   }).toList();
  // }

  Future<void> initiateData(
    String username,
  ) async {
    return await userCollection
        .document(uid)
        .setData({'username': username, 'balance': 0, 'role': 'customer'});
  }

  Future<void> updateAdminData(
    String username,
    String image,
    int balance,
  ) async {
    return await userCollection.document(uid).updateData(
      {
        'username': username,
        'balance': balance,
        'image': image,
      },
    );
  }

  Future<void> updateCustomerBalance(
    String customerID,
    int balance,
  ) async {
    print(customerID);
    return await userCollection.document(customerID).updateData(
      {
        'balance': balance,
      },
    );
  }

  Future<void> addLead(String customerID, String type, String address,
      String phone, String email, int price) async {
    print(customerID);
    var customer = await userCollection.document(customerID).get();
    await userCollection
        .document(customerID)
        .updateData({'balance': customer.data['balance'] - price});
    return await userCollection.document(customerID).collection('leads').add(
      {
        'type': type,
        'address': address,
        'phone': phone,
        'email': email,
        'price': price,
        'time': Timestamp.now()
      },
    );
  }
}
