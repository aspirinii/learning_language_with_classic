// main.dart
// import 'dart:collection';
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
        GestureDetector(
          onTap:(){
            model.changeActivation();
            print('taptap');
          },
          child: Center(
            // color: Colors.transparent.withOpacity(0.5),
            child: Obx(() => AnimatedOpacity(
              opacity: model.active.value ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Text(model.contentK, 
              textAlign: TextAlign.center,),
            ))
          ),
        ),
      ],
    );
  }

}


class Sentence extends GetxController{
  late int id;
  RxBool active = false.obs;
  late String contentK;
  late String contentE;

  Sentence(this.id, this.active , this.contentK, this.contentE);

  Sentence.fromJson(Map<String, dynamic> json){
    id = int.parse(json['index']);
    active.value = false;
    contentE = json['contentE'];
    contentK = json['contentK'];
  }

  changeActivation(){
    active.value = !active.value;
  }

} 


class Controller extends GetxController{

  var dataFromJson;
  var listSentence;
  var map;
  late Future<dynamic> rawData;

  Future LoadDataJson() async {
    final _rawData = await rootBundle.loadString("assets/frog.json");

    List<Map<String, dynamic>> output = List.from(json.decode(_rawData) as List);

    print(output.runtimeType);

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

            if(snap.hasData){
                // print(snap.data);
                print("Snap : ${snap.data.runtimeType}");
                return ListView(
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