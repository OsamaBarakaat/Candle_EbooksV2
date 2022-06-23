import 'dart:convert';
import 'dart:io';
import 'dart:async' show Future, Timer;
import 'dart:async' show Future, ByteStream;
import 'package:candle_ebookv2/read_book_blind.dart';
import 'package:candle_ebookv2/search.dart';
import 'package:candle_ebookv2/welcom_speack/welcom_speak.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'book/view/home_book.dart';
import 'contact_us.dart';
class MicScreen1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MicScreen1> {
  File? _audio;
  FlutterAudioRecorder2? _recorder;
  Recording? _recording;
  bool isRecord = false;
  late String filename;
  Future startRecording() async {
    String customPath = '/candelrecords.wav';
    Directory? appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }
    customPath =appDocDirectory!.path.toString() + customPath.toString();
    filename= customPath ;
    _recorder = FlutterAudioRecorder2(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder!.initialized;
    _recorder!.start();
    setState(() {
      isRecord = true;
    });
  }
  Future stopRecording() async {
    var result = await _recorder?.stop();
    setState(() {
      _recording = result;
      isRecord = false;
      _audio = File (_recording!.path.toString());
      print("paath ${_audio?.path}");
      print(_recording?.path.toString());
      // this is what we need
    });
  }
  Future Uploadfile(String filename) async {
    var postUri =  Uri.parse("https://candle-ebooks.herokuapp.com/api/transcription/");

    http.MultipartRequest request =  http.MultipartRequest("POST", postUri);
    request.headers ['Content-Type']="multipart/form-data";
    request.headers ['Accept']="*/*";
    request.headers ['Accept-Encoding']="gzip, deflate, br";
    request.headers ['Connection']="keep-alive";
    http.MultipartFile multipartFile =  await http.MultipartFile.fromPath(
        'audio', filename);
     request.files.add (multipartFile);
    http.StreamedResponse response = await request.send();
    var responseData = await response.stream.toBytes();
       var result = String.fromCharCodes(responseData);
    if(response.statusCode >=400) {
         TextToSpeech().speak(
             "Book not found Please try again");
         Get.to(ContactUs());
       }
       else{
      Map valueMap = json.decode(result);
      print(valueMap["title"]);
      String pdf = "https://candle-ebooks.herokuapp.com/api/books/content/"+valueMap["id"].toString();
         Get.to(PdfViewerPage2(), arguments: pdf);
       }
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
          title: const Text(
            'Home',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => search_screen(),
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeBook(),
                  ),
                );
              },
              child: Icon(
                Icons.menu_book_outlined,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: InkWell(
          onTap: () {
            if (isRecord) {
              stopRecording();
              Timer(const Duration(seconds:2), () {
                Uploadfile(filename);
              });
            } else {
              final aaaa= Directory("/storage/emulated/0/Android/data/com.example.hn.candle_ebookv2/files/candelrecords.wav");
               aaaa.deleteSync(recursive: true);
              startRecording();
            }
          },
          child: Container(
            height: double.infinity,
            child: isRecord
                ? Lottie.asset('assets/images/2887-listen-state.json')
                : Center(
                    child: Icon(
                    Icons.mic,
                    color: Colors.blue,
                    size: 100,
                  )),
          ),
        ));
  }
}
