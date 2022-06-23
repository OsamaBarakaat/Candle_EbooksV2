import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class PdfViewerPage2 extends StatefulWidget {
  @override
  _PdfViewerPageState2 createState() => _PdfViewerPageState2();
}

class _PdfViewerPageState2 extends State<PdfViewerPage2> {
  String? localPath;
  String? localsound;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  final pdfBackend = Get.arguments! as String;
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    // TODO: implement initState
    super.initState();
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });
    loadSound().then((value) {
      setState(() {
        localsound = value;
        print(localsound);
        audioPlayer.setSourceDeviceFile(localsound!);
      });
    });
  }
  Future<String> loadSound() async {
    String Sound_URL = "https://candle-ebooks.herokuapp.com/api/books/audio/6";

    var response = await http.get(Uri.parse(Sound_URL));

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/Sound.mp3");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
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
              colors: [Colors.black45 , Colors.blue],
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
        body:InkWell(
          onTap: ()async {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.resume();
      }},
          child:localPath != null
              ? PDFView(
            filePath: localPath,

          ) : Center(child: CircularProgressIndicator()),
        )
    );
  }
}
// Timer(const Duration(seconds:2), () {
// Uploadfile(filename);
// });
