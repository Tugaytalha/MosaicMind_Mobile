import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosaic_mind/camera.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  String _status1 = 'Offline';
  String _status2 = 'Offline';
  String _status3 = 'Offline';
  String _status4 = 'Offline';

  String ipA1 = '192.168.249.50';
  String ipA2 = '192.168.240.150';
  String ipA3 = '192.168.240.151';
  String ipA4 = '192.168.240.152';

  @override
  void initState() {
    super.initState();
    // Start the ping process
    Timer.periodic(const Duration(seconds: 3), (Timer t) {
      _pingAddress(ipA1, 1);
      _pingAddress(ipA2, 2);
      _pingAddress(ipA3, 3);
      _pingAddress(ipA4, 4);
    });
  }

  void _pingAddress(String ipAddress, int raspberryNumber) async {
    final result = await Process.run('ping', ['-c', '1', '-W', '3', ipAddress]);
    final stdout = result.stdout as String;
    print('Ping response for Raspberry $raspberryNumber: $stdout');
    if (stdout.contains('1 packets transmitted') &&
        stdout.contains('0 received')) {
      setState(() {
        if (raspberryNumber == 1) {
          _status1 = 'Online';
        } else if (raspberryNumber == 2) {
          _status2 = 'Online';
        } else if (raspberryNumber == 3) {
          _status3 = 'Online';
        } else if (raspberryNumber == 4) {
          _status4 = 'Online';
        }
      });
    } else {
      setState(() {
        if (raspberryNumber == 1) {
          _status1 = 'Offline';
        } else if (raspberryNumber == 2) {
          _status2 = 'Offline';
        } else if (raspberryNumber == 3) {
          _status3 = 'Offline';
        } else if (raspberryNumber == 4) {
          _status4 = 'Offline';
        }
      });
    }
  }

  void onClickedRasbperry(String _documentID, String _ipAddress) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraApp(documentID: _documentID, ipAddress: _ipAddress),
      ),
    );
  }

  Widget _buildRaspberry(
      String name, String status, String documentID, String ipA) {
    bool isOnline = status == 'Online';

    return Column(
      children: [
        GestureDetector(
          onTap: isOnline ? () => onClickedRasbperry(documentID, ipA) : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Image.asset(
                'assets/rasperry.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            color: isOnline ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF403948),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Text(
              'Choose a machine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRaspberry(
                        'Raspberry1', _status1, "raspberry_machine_1", ipA1),
                    _buildRaspberry(
                        'Raspberry2', _status2, "raspberry_machine_2", ipA2),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRaspberry(
                        'Raspberry3', _status3, "raspberry_machine_3", ipA3),
                    _buildRaspberry(
                        'Raspberry4', _status4, "raspberry_machine_4", ipA4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosaic_mind/camera.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  String _status1 = 'Offline';
  String _status2 = 'Offline';
  String _status3 = 'Offline';
  String _status4 = 'Offline';

  @override
  void initState() {
    super.initState();
    // Ping işlemini başlat
    Timer.periodic(const Duration(seconds: 3), (Timer t) {
      _pingAddress('192.168.249.50', 1);
      _pingAddress('192.168.240.150', 2);
      _pingAddress('192.168.240.151', 3);
      _pingAddress('192.168.240.152', 4);
    });
  }

  void _pingAddress(String ipAddress, int raspberryNumber) async {
    final result = await Process.run('ping', ['-c', '1', '-W', '3', ipAddress]);
    final stdout = result.stdout as String;
    print('Ping response for Raspberry $raspberryNumber: $stdout');
    if (stdout.contains('1 packets transmitted') &&
        stdout.contains('0 received')) {
      setState(() {
        if (raspberryNumber == 1) {
          _status1 = 'Online';
        } else if (raspberryNumber == 2) {
          _status2 = 'Online';
        } else if (raspberryNumber == 3) {
          _status3 = 'Online';
        } else if (raspberryNumber == 4) {
          _status4 = 'Online';
        }
      });
    } else {
      setState(() {
        if (raspberryNumber == 1) {
          _status1 = 'Offline';
        } else if (raspberryNumber == 2) {
          _status2 = 'Offline';
        } else if (raspberryNumber == 3) {
          _status3 = 'Offline';
        } else if (raspberryNumber == 4) {
          _status4 = 'Offline';
        }
      });
    }
  }

  void onClickedRasbperry(String _documentID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraApp(documentID: _documentID),
      ),
    );
  }

  //onClickedRasbperry("raspberry_machine_1")
  //onClickedRasbperry("raspberry_machine_2")
  //onClickedRasbperry("raspberry_machine_3")
  //onClickedRasbperry("raspberry_machine_4")

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF403948),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Text(
              'Choose a machine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRaspberry('Raspberry1', _status1),
                    _buildRaspberry('Raspberry2', _status2),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRaspberry('Raspberry3', _status3),
                    _buildRaspberry('Raspberry4', _status4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaspberry(String name, String status) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          child: Image.asset(
            'assets/rasperry.png',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            color: status == 'Online' ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
*/