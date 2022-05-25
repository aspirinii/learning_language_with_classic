// main.dart
// import 'dart:collection';
import 'package:flutter/material.dart';
// import 'dart:ui';
import 'dart:async';
// import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; //rootbundle
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

class SentenceWidget extends StatelessWidget {
  SentenceWidget({Key? key, required this.model}) : super(key: key);

  Sentence model;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            model.changeActivation();
            print('taptap');
          },
          child: Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                    Color(0xFFFAEBEF),
                    Color(0xFFFAEBEF),
                ]),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Opacity(
                opacity: 1,
                child: Text(
                  model.contentE,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xFF333D79))
                ),
              )),
        ),
          GestureDetector(
          onTap: () {
            model.changeActivation();
            print('taptap');
          },
          child: Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFFFAEBEF),
                  Color(0xFFFAEBEF),
                ]),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Obx(() => AnimatedOpacity(
                    opacity: model.active.value ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: KoreanParagraph(model: model)
                  )
                )
              ),
            ),
      ],
    );
  }
}
class KoreanParagraph extends StatelessWidget{
  KoreanParagraph({Key? key, required this.model}) : super(key: key);

  Sentence model;
  @override
  Widget build(BuildContext context) {
    if(model.active.value){
      return Text(
        model.contentK,
        textAlign: TextAlign.left,
        style: TextStyle(color: Color(0xFF333D79))
      );
    }else{ return SizedBox.shrink();}
    

  }
}

class Sentence extends GetxController {
  late int id;
  RxBool active = false.obs;
  late String contentK;
  late String contentE;

  Sentence(this.id, this.active, this.contentK, this.contentE);

  Sentence.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['index']);
    active.value = false;
    contentE = json['contentE'];
    contentK = json['contentK'];
  }

  changeActivation() {
    active.value = !active.value;
  }
}

class Controller extends GetxController {
  var dataFromJson;
  var listSentence;
  var map;
  late Future<dynamic> rawData;

  Future LoadDataJson() async {
    final _rawData = await rootBundle.loadString("assets/frog.json");

    List<Map<String, dynamic>> output =
        List.from(json.decode(_rawData) as List);

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
    return FutureBuilder(
      future: c.dataFromJson,
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
        print("Snap : ${snap.data.runtimeType}");
      
          return Scaffold (
            appBar: AppBar(
              backgroundColor: Color(0xFF333D79),
              title: Text(snap.data[0]['contentE'],
                      style: TextStyle(color:  Color(0xAAFAEBEF),),
            ),
            ),
            // // Implement the GridView
            body: ListView(children: [
              for (var w in snap.data)
                SentenceWidget(model: Sentence.fromJson(w)),
              ])
            );
          } else {
            return Text("Wait some time..");
          }
      }

    );
  }
}
