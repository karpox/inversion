  
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {

  var status;
  var token;
  String serverUrlplanes = "http://192.168.0.14:8000/planes";

  //funciton getData
  Future<List> getData() async{

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrlplanes";
    http.Response response = await http.get(Uri.parse(myUrl),
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
    });
    return json.decode(response.body);
   // print(response.body);
  }

  Future<List> getPlan(String _id) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "http://192.168.0.14:8000/planes/$_id";
    http.Response response = await http.get(Uri.parse(myUrl),
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
    });
    

    return json.decode(response.body);
  }


  //function for register products
  void addDataPlan(String _nameController, String _invminController, String _invmaxController,
  String _tasaController, String _duracionController) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

   // String myUrl = "$serverUrl/api";
   String myUrl = "http://192.168.0.14:8000/planes/create";
   final response = await  http.post(Uri.parse(myUrl),
        headers: {
          'Accept':'application/json'
        },
        body: {
          "name":       "$_nameController",
          "invmin":      "$_invminController",        
          "invmax":      "$_invmaxController",
          "tasa":         "$_tasaController",
          "duracion":     "$_duracionController"
        } ) ;
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if(status){
      print('data : ${data["error"]}');
    }else{
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update or put
  void editarPlan(String _id, String _nameController, String _invminController, String _invmaxController,
  String _tasaController, String _duracionController) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    var myUrl = Uri.parse("http://192.168.0.14:8000/planes/$_id");
    http.put(myUrl,
        body: {
          "name":       "$_nameController",
          "invmin":      "$_invminController",        
          "invmax":      "$_invmaxController",
          "tasa":         "$_tasaController",
          "duracion":     "$_duracionController"
        }).then((response){
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }


  //function for delete
  Future<void> removeRegister(String _id) async {

  String myUrl = "http://192.168.0.14:8000/planes/$_id";

  Response res = await http.delete(Uri.parse("$myUrl"));

  if (res.statusCode == 200) {
    print("DELETED");
  } else {
    throw "Can't delete post.";
  }
}

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

//function read
 read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('read : $value');
  }
}
