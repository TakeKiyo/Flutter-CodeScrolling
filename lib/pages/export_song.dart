import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ExportSong extends StatelessWidget {
  final String docId;

  ExportSong({Key key, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('曲を共有'),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: <Widget>[
                Center(
                  child: QrImage(
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText1.color,
                    data: docId,
                    size: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: const Text(
                    "IDをコピーして共有することも可能です。",
                    textAlign: TextAlign.center,
                  ),
                ),
                OutlinedButton(
                  child: const Text('IDをコピーする'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(),
                  ),
                  onPressed: () async {
                    final data = ClipboardData(text: docId);
                    await Clipboard.setData(data);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('曲のIDをコピーしました。\n友達に送って曲を共有しましょう。'),
                        duration: const Duration(seconds: 5),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
