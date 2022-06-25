import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'micScreen.dart';
class PdfViewerPage extends StatefulWidget  {
  @override
  _PdfViewerPageState2 createState() => _PdfViewerPageState2();
}

class _PdfViewerPageState2 extends State<PdfViewerPage> {

  String? localPath;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final pdfBackend = Get.arguments! as String;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<String> loadSound() async {
    String Sound_URL = "https://candle-ebooks.herokuapp.com/api/books/audio/"+MyAppState.valueMap!["id"].toString();

    var response = await http.get(Uri.parse(Sound_URL));

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/Sound.mp3");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    loadSound().then((value) {
      setState(() {
        localPath = value;
        print(localPath);
        audioPlayer.setSourceDeviceFile(localPath!);
      });
    });
    // audioPlayer.resume();
  }

  Future<String> loadPDF() async {
    var response = await http.get(Uri.parse(pdfBackend));

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black45, Colors.blue],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        title: Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: localPath != null
            ? RaisedButton(
        colorBrightness:Brightness.light,
        onPressed:() {
          if (isPlaying) {
             audioPlayer.pause();
          } else {
             audioPlayer.resume();
          }
        },
      // Toggle light when tapped.

              child: PDFView(
                      filePath: localPath,
                    ),
            )



            : Center(child: CircularProgressIndicator()),

    );
  }
}

