import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String docID = "";
  int _correctC = 0;
  int _failC = 0;
  int _updateC = 0;

  DatabaseService(String docID) {
    print(docID);
    this.docID = docID;
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('rasperryCounts');

  Future<void> updateData(int correctC, int failC, int updateC) async {
    try {
      await usersCollection.doc(docID).update({
        'r-correct-c': correctC,
        'r-fail-c': failC,
        'r-update-c': updateC,
      });
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rasperryCounts')
          .doc(docID)
          .get();

      _correctC = querySnapshot.data()?['r-correct-c'] ?? 0;
      _failC = querySnapshot.data()?['r-fail-c'] ?? 0;
      _updateC = querySnapshot.data()?['r-update-c'] ?? 0;
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  int get correctC => _correctC;
  int get failC => _failC;
  int get updateC => _updateC;
}
