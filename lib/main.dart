// main.dart
import 'dart:collection';

import 'package:flutter/material.dart';
// import 'dart:ui';
import 'dart:async';
// import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';//rootbundle
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'froggggg',
      home: MyHomePage(),
    );
  }
}

class SentenceWidget extends StatelessWidget{
  SentenceWidget({required this.model});

  Sentence model;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Center(
          // color: Colors.transparent.withOpacity(0.5),
          child: Opacity(
            opacity: 1,
            child: Text(model.contentE,
            textAlign: TextAlign.center,),
          )
        ),
        Center(
          // color: Colors.transparent.withOpacity(0.5),
          child: Opacity(
            opacity: model.active ? 1 : 0,
            child: Text(model.contentK, 
            textAlign: TextAlign.center,),
          )
        ),
      ],
    );
  }

}


class Sentence {
  late int id;
  late bool active;
  late String contentK;
  late String contentE;

  Sentence(this.id, this.active , this.contentK, this.contentE);

  Sentence.fromJson(Map<String, dynamic> json){
    this.id = int.parse(json['index']);
    this.active = false;
    this.contentE = json['contentE'];
    this.contentK = json['contentK'];
  }

} 


class Controller extends GetxController{

  var dataFromJson;
  var listSentence;
  var map;
  late Future<dynamic> rawData;

  Future LoadDataJson() async {
    final _rawData = await rootBundle.loadString("assets/frog.json");

    // final List<dynamic> jsonData = json.decode(_rawData);
    // print(jsonData[0]["contentE"]);
    // listSentence = Sentence.fromJson(jsonData);
    // List<Map<String, dynamic>> output = (json.decode(_rawData) as List).cast();
    List<Map<String, dynamic>> output = List.from(json.decode(_rawData) as List);

    // final map = HashMap.fromIterable(jsonData);

      // print(output.runtimeType);
      print(output.runtimeType);
      // var colorList = output2.map((element) => Sentence.fromJson(element)).toList();
      // for(var color in colorList){
      //   print('${color.id} ${color.contentK} ${color.contentE}');
      // }
      // print(output2[1]["contentK"]);
    
    return output;
  }



  

  @override
  onInit() {

    dataFromJson = LoadDataJson();
    // print(dataFromJson);
    print('onInit start');
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  // Generate a dummy list
  final Controller c = Get.put(Controller());
  // final List numbers = List.generate(30, (index) => "Item $index");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('개구리왕자'),
        ),
        // // Implement the GridView
        body: 


        FutureBuilder(
          future: c.dataFromJson,
          builder: (BuildContext context , AsyncSnapshot snap) {
            // var jsonData = json.decode(snap.data.toString());
            // print(c.rawData);
            // print(jsonData);
            // print(jsonData.runtimeType);

            if(snap.hasData){
                // print(snap.data);
                print("Snap : ${snap.data.runtimeType}");
                return Column(
                  children: [
                    for (var w in snap.data )
                      SentenceWidget(model : Sentence.fromJson(w)),
                  ]
                );
                }else{
              return Text("Wait some time..");
            }
          }
        )


        );
  }
}