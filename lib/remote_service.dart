import 'dart:convert';
import 'package:candle_ebookv2/login&register.dart';
import 'package:http/http.dart' as http;
import 'json.dart';
class RemoteService {
  var username;
  var search_word;
  var api_link = "https://candle-ebooks.herokuapp.com/api/";

  var client = http.Client();

  Future<Books?> getBooks() async {
    var uri = Uri.parse(api_link + "books");
    var response = await client.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var json = response.body;
      return booksFromJson(json);
    }
  }

  Future<Bookid?> getBook() async {
    var uri = Uri.parse(api_link + "books");
    var response = await client.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var json = response.body;
      return bookidFromJson(json);
    }
  }

  Future<Msg?> postRegisteration(String username, String email, String password,
      String phone) async {
    final response = await http.post(
      Uri.parse(api_link + 'users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "/",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
        'phone': phone
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      var json = response.body;
      return msgFromJson(json);
    }
    return null;
  }

  Future<LoginValid?> postLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse(api_link + 'validate/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "/",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 400) {
      var json = response.body;
      print(json);
      return loginValidFromJson(json);
    }
    return null;
  }

  Future<Msg?> putLogin() async {
    var uri = Uri.parse(api_link + "fact");
    var response = await client.put(uri, headers: {
      "email": '',
      "password": '',
      "username": ''
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var json = response.body;
      return msgFromJson(json);
    }
  }
  Future<Msg?> delLogin() async {
    var uri = Uri.parse(api_link + "fact");
    var response = await client.delete(uri, headers: {
      "username": ''
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var json = response.body;
      return msgFromJson(json);
    }
  }

  Future<Books?> getSearch() async {
    var uri = Uri.parse(api_link + search_word);
    var response = await client.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var json = response.body;
      return booksFromJson(json);
    }
  }
}
