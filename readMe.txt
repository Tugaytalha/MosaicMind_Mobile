authantication dosyasını comple alıp kopyalayın hacı klasor olarak.
Sign ,register için gerreken butun filelar içinde...
-----------------------------------------------------------------------------
database.dart clasına şunu ekledim :
 void resetDatabase() {
    updateData(0, 0, 0);
  }

------------------------------------------------------------------------------
selection.dart clasına iki fonksiyon ve iki widget ekledim:

void onClickedReset() {
    DatabaseService("raspberry_machine_1").resetDatabase();
    DatabaseService("raspberry_machine_2").resetDatabase();
    DatabaseService("raspberry_machine_3").resetDatabase();
    DatabaseService("raspberry_machine_4").resetDatabase();
  }

  void quitApp() {
    AuthService _auth = AuthService();
    _auth.signOut();
  }

appbar kısmını bunla değiştirirseniz yukarıdaki fonksiyonlar çalışıcak:
appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF403948),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 40,
            ),
            onPressed: quitApp,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton.icon(
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text('Reset', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              onPressed: onClickedReset,
            ),
          ),
        ],
      ),
-------------------------------------------------------------------------------------------------
maini şunula değiştirin:

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final user = Provider.of<MyUser?>(context);
            if (user == null) {
              return const Authenticate();
            } else {
              return const Selection();
            }
          },
        ),
      ),
    );
  }
}
-------------------------------------------------------------------------------------------
1 resim eklendi ...
- assets/login.jpg

--------------------------------------------------------------------------------------------
dependencilerde bunlar :
    cupertino_icons: ^1.0.6
    cloud_firestore: ^4.17.2
    gallery_saver: ^2.3.2
    image_picker: ^1.1.1
    firebase_core: ^2.30.1
    firebase_auth: ^4.19.6
    localstorage: ^5.0.0
    shared_preferences: ^2.2.3
    flutter_spinkit: ^5.2.1
    provider: ^6.1.2

---------------------------------------------------------------------------------------------
database e isOnline statusu eklemek için:
1-database.dart a şu fonkşsyonu ekliyoruz:
 Future<void> updateRaspberryStatus(bool isOnline) async {
    return await usersCollection.doc(docID).update({
      'isOnline': isOnline ? 1 : 0,
    });
  }

2-selection.dart'taki void _pingAddress i bu fonksiyonla değiştirin...

  void _pingAddress(String ipAddress, int raspberryNumber) async {
    final result = await Process.run('ping', ['-c', '1', '-W', '3', ipAddress]);
    final stdout = result.stdout as String;
    print('Ping response for Raspberry $raspberryNumber: $stdout');

    bool isOnline = stdout.contains('1 packets transmitted') &&
        stdout.contains('0 received');

    setState(() {
      if (raspberryNumber == 1) {
        _status1 = isOnline ? 'Online' : 'Offline';
      } else if (raspberryNumber == 2) {
        _status2 = isOnline ? 'Online' : 'Offline';
      } else if (raspberryNumber == 3) {
        _status3 = isOnline ? 'Online' : 'Offline';
      } else if (raspberryNumber == 4) {
        _status4 = isOnline ? 'Online' : 'Offline';
      }
    });

    String documentID;
    if (raspberryNumber == 1) {
      documentID = "raspberry_machine_1";
    } else if (raspberryNumber == 2) {
      documentID = "raspberry_machine_2";
    } else if (raspberryNumber == 3) {
      documentID = "raspberry_machine_3";
    } else {
      documentID = "raspberry_machine_4";
    }

    DatabaseService(documentID).updateRaspberryStatus(isOnline);
  }