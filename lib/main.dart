// main.dart
import 'package:flutter/material.dart';
// import 'dart:ui';
import 'dart:async';
import 'package:csv/csv.dart';
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
        Container(
          color: Colors.transparent.withOpacity(0.5),
          child: Opacity(
            opacity: 1,
            child: Text(model.contentE),
          )
        ),
        Container(
          color: Colors.transparent.withOpacity(0.5),
          child: Opacity(
            opacity: model.active ? 1 : 0,
            child: Text(model.contentK),
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
  late List<List<dynamic>> ListData;

  Sentence(this.id, this.active , this.contentK, this.contentE);

  Sentence.fromJson(json){
    this.id = json['index'];
    this.active = false;
    this.contentE = json['contentE'];
    this.contentK = json['contentK'];
  }

  // LoadData() async {
  //   final _rawData = await rootBundle.loadString("assets/frog.csv");
  //   List<List<dynamic>> ListData =  const CsvToListConverter().convert(_rawData);
  //   return ListData;
  // }
  // LoadDataJson() async {
  //   final _rawData = await rootBundle.loadString("assets/frog.json");
  //   final Map<String, dynamic> jsonData = json.decode(_rawData);
  //   return jsonData;
  // }
} 



// class SentenceKorean extends Sentence{
//   @override
//   bool active = false;

//   SentenceKorean(int id, bool active, String content) : super(id, active, content);

//   // SentenceKorean.fromList(ListData) : super.(super.id = ListData[0][0] , super.active = false , super.content = ListData[2][2] );


//   @override
//   LoadData() async {
//     final _rawData = await rootBundle.loadString("assets/frog.csv");
//     List<List<dynamic>> _listData =  const CsvToListConverter().convert(_rawData);
//     return _listData;
//   }

// }

// class SentenceEnglish extends Sentence{
//   SentenceEnglish(int id, bool active, String content) : super(id, active, content);

// }

class Controller extends GetxController{

  List numberList = [];
  // late List<List<dynamic>> _data;
  late Future<List<List<dynamic>>> _data;
  var dataFromJson;
  var listSentence;
  late Future<dynamic> rawData;

  Future<List<List<dynamic>>> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/frog.csv");
    List<List<dynamic>> _listData =  const CsvToListConverter().convert(_rawData);
    // print('rawData $_rawData');
    return _listData;
  }
  Future LoadDataJson() async {
    final _rawData = await rootBundle.loadString("assets/frog.json");

    final List<dynamic> jsonData = json.decode(_rawData);
    // print(jsonData[0]["contentE"]);
    // listSentence = Sentence.fromJson(jsonData);
              // print(rawData);
              // print(jsonData);
              print(jsonData.runtimeType);
              print(jsonData[2]['contentK']);
              print("detail type : ${jsonData[2].runtimeType}");
              // print(jsonData[2][2]);
    
    return jsonData;
  }



  

  @override
  onInit() {

    _data = _loadCSV();
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
                    // for (var w in snap.data )
                    //   SentenceWidget(model : Sentence.fromJson(w)),
                  ]
                );
                }else{
              return Text("Wait some time..");
            }
          }
        )

        // FutureBuilder(
        //   future: c._data,
        //   builder: (BuildContext context , AsyncSnapshot snap) {
        //     if(snap.hasData){
        //       return GridView.builder(
        //         padding: const EdgeInsets.all(2),
        //         // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         //     childAspectRatio: 3 / 1,
        //         //     mainAxisSpacing: 10, 
        //         //     crossAxisCount: 1),
        //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400),

        //         itemBuilder: (BuildContext ctx, index){
        //           return Column(
        //             children: [
        //               Container(
        //                       color: Colors.amber,
        //                       alignment: Alignment.center,
        //                       child: Text(snap.data[index+1][1], textAlign: TextAlign.center,)
        //               ),
        //               Padding(padding: const EdgeInsets.all(2)),
        //               Container(
        //                       color: Colors.blueGrey,
        //                       alignment: Alignment.center,
        //                       child: Text(snap.data[index+1][2],textAlign: TextAlign.center,)
        //               )
        //             ],
        //           );}
        //       );
        //     }else{
        //       return Text("Wait some time..");
        //     }
        //   }
        // )

        );
  }
}