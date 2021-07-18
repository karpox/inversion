
import 'package:flutter/material.dart';
import 'package:mi_inversion_app/screens/add/add_screen.dart';
import 'package:mi_inversion_app/screens/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mi_inversion_app/screens/rendimiento/rendimiento_screen.dart';
import 'package:mi_inversion_app/screens/update/update_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_inversion_app/models/plan.dart';
import 'package:mi_inversion_app/controllers/databasehelpers.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;






void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Inventario',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {




  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DataBaseHelper databaseHelper = new DataBaseHelper();

  List colors = [Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.pink, Colors.black, Colors.grey];
  Random random = new Random();


  late SharedPreferences sharedPreferences;
  late Map data;
  late List planesData;
  late List ide;
  late List nombre, tasa, duracion, invemin, invemax;

  getPlanes() async {
    http.Response response = await http.get(Uri.parse('http://192.168.0.14:8000/planes'));
    data = json.decode(response.body);
    
    setState(() {
      planesData = data['planes'];
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getPlanes();
  }


  checkLoginStatus() async {

    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => 
      LoginPage()), (Route<dynamic> route) => false);

    }
  }

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(

      
      
      appBar: AppBar(
        title: Text("Planes", style:TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                content:Text('Logout'));
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => 
              LoginPage()), (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            },
            child:Text("Lagout", style: TextStyle(color: Colors.white),),
          )
        ]

      ),
      body:Container(

        


        child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            Expanded(
              child: ListView.builder(
              itemCount: planesData == null ? 0 : planesData.length,
              itemBuilder:(BuildContext context, int index){

                int numero = random.nextInt(7);


                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction){
                    setState(() async {
                      
                      await databaseHelper.removeRegister(planesData[index]["_id"]);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                  ),



                  child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: 220,
                  width: double.maxFinite,
                  child: Card(
                    elevation: 5,
                    child:Container(
                      decoration: BoxDecoration(
                        border:  Border(
                          top:BorderSide(
                            width:2.0, color: colors[numero]
                          )
                        )
                      ),
                      child: InkWell(splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => rendimientoPage(
                          nombre: planesData[index]['name'],
                          tasa: planesData[index]['tasa'],
                          duracion: planesData[index]['duracion'],
                          invmin: planesData[index]['invmin'],
                          invmax: planesData[index]['invmax'],
                        )),
                      );
                    }, 
                    onLongPress: (){
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => updatePage(
                          ide: planesData[index]["_id"],
                        )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Stack(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget> [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.insert_chart_outlined,
                                          color: colors[numero],
                                          size: 40,

                                        )
                                      )
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    cryptoNameSymbol(planesData[index]),
                                    Spacer(),
                                    cryptoChange(planesData[index]),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    changeIcon(),
                                    SizedBox(
                                      width:20,
                                    )
                                  ],
                                ),
                                Row(children: <Widget> [inverMin(planesData[index]),     
                                Spacer(),
                                inverMax(planesData[index])],),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget> [meses(planesData[index])],)
                              ]
                            )
                          )
                        ],
                      )
                    )
                  )
                    ),
                    
                  )
                  )
                );
              })
            )
          ]
        )
        
    ),
    
          floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addPage()),
          );        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),

    )
    );
  }



   Widget cryptoNameSymbol(data) {
   return Align(
     alignment: Alignment.centerLeft,
     child: RichText(
       text: TextSpan(
         text: "${data["name"]}",
         style: TextStyle(
             fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
         children: <TextSpan>[
           TextSpan(
               text: '\nPlan',
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 15,
                   fontWeight: FontWeight.bold)),
         ],
       ),
     ),
   );
  }
Widget cryptoChange(data) {
  return Align(
    alignment: Alignment.topRight,
    child: RichText(
      text: TextSpan(
        text: '+${data["tasa"]}%',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
        children: <TextSpan>[
        TextSpan(
            text: '\nTasa Mensual',
            style: TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.bold)),
      ],
    ),
  ),
);
}
Widget changeIcon() {
  return Align(
      alignment: Alignment.topRight,
      child: Icon(
        Icons.keyboard_arrow_up_sharp,
        color: Colors.green,
        size: 30,
      ));
}
Widget inverMin(data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '\n\$${data["invmin"]}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\nInversion Minima',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],

      ),
    ),
  );
 }

Widget inverMax(data) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              text: '\n\$${data["invmax"]}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\nInversion Maxima',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      
      ),
    ),
  );
 }

  Widget meses(data){
   return Align (
         alignment: Alignment.bottomCenter,
    child: Center(
      child: Row(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '\n${data["duracion"]} Meses',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '\nDuracion del plan',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      
      ),
    ),
   );
 }

}


