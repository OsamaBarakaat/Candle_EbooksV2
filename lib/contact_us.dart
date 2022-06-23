import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);
  @override
  State<ContactUs> createState() => _RequestScreenState();
}
class request {
  final int id;
  final String name;

  request({
    required this.id,
    required this.name,
  });
}
class _RequestScreenState extends State<ContactUs> {
  var _email1 = TextEditingController();
  var _message1 = TextEditingController();
  var _problem1 = TextEditingController();
  late String _Problem = "";
  late String _email = "";
  late String _message = "";
  @override
  void initState() {
    _selectedAnimals5 = _request;
    super.initState();

  }
  void submit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        _email1.clear();
      });
      setState(() {
        _message1.clear();
      });

      _formKey.currentState!.save();
      Get.snackbar("Recevied sucsesfully", 'Candle Ebooks team will contact with you soon ',backgroundColor: Colors.green);
    }

  }
  static List<request> _request = [
    request(id: 1, name: "Request Book"),
    request(id: 2, name: "problem with signin"),
    request(id: 3, name: "add book to favourite"),
    request(id: 4, name: "problem with sound"),
    request(id: 5, name: "the app dosent work"),
    request(id: 6, name: "other"),
  ];
  final _items = _request
      .map((requestt) => MultiSelectItem<request>(requestt, requestt.name))
      .toList();
  List<request> _selectedAnimals2 = [];
  List<request> _selectedAnimals3 = [];
  List<request> _selectedAnimals5 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black45 , Colors.blue],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white70,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                MultiSelectDialogField(
                  items: _items,
                  title: Text("Problems"),
                  selectedColor: Colors.blue,

                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.report_problem_outlined,
                    color: Colors.blue,
                  ),
                  buttonText: Text(
                    "Selcet the problem",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                  },
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _email1,
                  autocorrect: true,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.words,
                  key: ValueKey('Email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')&& val.length<4) {
                      return "please enter a valid email address";
                    }
                    return null;
                  },

                  onSaved: (val) => _email = val!,
                  decoration: InputDecoration(
                    labelText: 'please enter your email ',
                    prefixIcon: Icon(
                      Icons.alternate_email_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _message1,
                  maxLength: 500,
                  maxLines: 5,
                  autocorrect: true,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.words,
                  key: ValueKey('Message'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "please Tell us what you need";
                    }
                    return null;
                  },
                  onSaved: (val) => _message = val!,
                  decoration: InputDecoration(
                    labelText: 'Tell us what you need',
                    prefixIcon: Icon(
                      Icons.message_outlined,
                      color: Colors.transparent,
                      size: 110.0,
                    ),
                    border: OutlineInputBorder(
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: Container(
                    height: 50,
                    width: 290,
                    child: ElevatedButton(
                      onPressed: () => submit(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue ,
                        elevation: 10.5,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      ),
                      child: Text('Submit', style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
