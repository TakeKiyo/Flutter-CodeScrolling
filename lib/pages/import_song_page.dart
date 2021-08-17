import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ImportSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('曲をインポート'),
        actions: [],
      ),
      body: Center(child: ImportSongForm()),
    );
  }
}

class ImportSongForm extends StatefulWidget {
  @override
  _ImportSongFormState createState() => _ImportSongFormState();
}

class _ImportSongFormState extends State<ImportSongForm> {
  String copiedID = "";
  bool qrScanned = false;
  void _handleCopiedID(String inputText) {
    setState(() {
      copiedID = inputText;
    });
  }

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  void importButtonClicked() {
    if (copiedID == "") {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("エラー"),
                content: Text("コピーした曲のIDを入力してください"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("確認"),
                content: Text("曲のインポートを開始します"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("OK"),
                    onPressed: () async => importSong(copiedID),
                  ),
                ],
              ));
    }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      if (qrScanned == false) {
        showQRScannedDialog(scanData.code.toString());
      }
      qrScanned = true;
    });
  }

  void showQRScannedDialog(String docId) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("確認"),
              content: Text("QRコードを認識しました。\n曲のインポートを開始します"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => {qrScanned = false, Navigator.pop(context)},
                ),
                TextButton(
                    child: Text("OK"),
                    onPressed: () async => {importSong(docId)}),
              ],
            ));
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  void importSong(String docId) async {
    String udid = await FlutterUdid.udid;
    try {
      await FirebaseFirestore.instance
          .collection("Songs")
          .doc(docId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var document = documentSnapshot.data() as Map;
          List<String> memberIDList = document["memberID"].cast<String>();
          memberIDList.add(udid);
          memberIDList = memberIDList.toSet().toList();
          FirebaseFirestore.instance.collection("Songs").doc(docId).update({
            "memberID": memberIDList,
            "updatedAt": DateTime.now(),
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: const Text('曲が存在していません'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('エラーが発生しました'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50),
        child: Column(children: <Widget>[
          Expanded(child: _buildQrView(context)),
          Container(
              padding: const EdgeInsets.all(30),
              child: Column(children: <Widget>[
                Text(
                  "コピーしたIDをペーストしても\n追加することができます",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  enabled: true,
                  style: TextStyle(color: Colors.black),
                  obscureText: false,
                  maxLines: 1,
                  //パスワード
                  onChanged: _handleCopiedID,
                ),
                ElevatedButton(
                  child: const Text('曲をインポート',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  onPressed: () {
                    importButtonClicked();
                  },
                ),
              ])),
        ]));
  }
}
