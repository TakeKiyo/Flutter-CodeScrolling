import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ImportSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('曲をインポート'),
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
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("確認"),
              content: const Text("曲のインポートを開始します"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () async => importSong(copiedID),
                ),
              ],
            ));
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
          borderColor: Theme.of(context).colorScheme.error,
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
        qrScanned = true;
        showQRScannedDialog(scanData.code.toString());
      }
    });
  }

  void showQRScannedDialog(String docId) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("確認"),
              content: const Text("QRコードを認識しました。\n曲のインポートを開始します"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => {qrScanned = false, Navigator.pop(context)},
                ),
                TextButton(
                    child: const Text("OK"),
                    onPressed: () async => {importSong(docId)}),
              ],
            ));
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('no Permission')),
      );
    }
  }

  void importSong(String docId) async {
    String uid = Provider.of<AuthModel>(context, listen: false).user.uid;
    try {
      await FirebaseFirestore.instance
          .collection("Songs")
          .doc(docId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var document = documentSnapshot.data() as Map;
          List<String> memberIDList = document["memberID"].cast<String>();
          memberIDList.add(uid);
          memberIDList = memberIDList.toSet().toList();
          FirebaseFirestore.instance.collection("Songs").doc(docId).update({
            "type": "addMember",
            "memberID": memberIDList,
            "updatedAt": DateTime.now(),
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          qrScanned = false;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
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
      qrScanned = false;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
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
                const Text(
                  "QRコードをスキャンすると\nインポートが始まります。",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0),
                ),
              ]))
        ]));
  }
}
