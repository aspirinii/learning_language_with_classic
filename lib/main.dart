// main.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';//rootbundle

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

class Controller extends GetxController{

  List numberList = [];
  // late List<List<dynamic>> _data;
  late Future<List<List<dynamic>>> _data;

  Future<List<List<dynamic>>> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/frog.csv");
    List<List<dynamic>> _listData =  const CsvToListConverter().convert(_rawData);
    print('rawData $_rawData');




    return _listData;
  }

  @override
  onInit() {

    _data = _loadCSV();
    print(_data);
    print('onInit start');
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  // Generate a dummy list
  final Controller c = Get.put(Controller());
  final List numbers = List.generate(30, (index) => "Item $index");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('개구리왕자'),
        ),
        // // Implement the GridView
        body: FutureBuilder(
          future: c._data,
          builder: (BuildContext context , AsyncSnapshot snap) {
            if(snap.hasData){
              return GridView.builder(
                padding: const EdgeInsets.all(2),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     childAspectRatio: 3 / 1,
                //     mainAxisSpacing: 10, 
                //     crossAxisCount: 1),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400),

                itemBuilder: (BuildContext ctx, index){
                  return Column(
                    children: [
                      Container(
                              color: Colors.amber,
                              alignment: Alignment.center,
                              child: Text(snap.data[index+1][1], textAlign: TextAlign.center,)
                      ),
                      Padding(padding: const EdgeInsets.all(2)),
                      Container(
                              color: Colors.blueGrey,
                              alignment: Alignment.center,
                              child: Text(snap.data[index+1][2],textAlign: TextAlign.center,)
                      )
                    ],
                  );}
              );
            }else{
              return Text("Wait some time..");
            }
          }
        ));
  }
}