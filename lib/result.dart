import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';



import './setting.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.data}) : super(key: key);

  final Map<String, List<int>> data;
  final String title = "PREDICTION";

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double winChance = 0.0;

  @override
  void initState() {
    super.initState();

    // inference
    Future<double> output = prediction();
    output.then((value) => {
      print(value)
    }).catchError((error) => print(error));

    winChance = Random().nextDouble();

  }

  Future<double> prediction() async {
    final interpreter = await Interpreter.fromAsset('models/model_Bind.tflite');

    // For ex: if input tensor shape [1,5] and type is float32
    var input = [List<double>.generate(34, (i) => 0.0)];

    // if output tensor shape [1,2] and type is float32
    var output = List.filled(1*2, 0).reshape([1,2]);

    // inference
    interpreter.run(input, output);

    print(output);
    // process output


    // print the output
    return output[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        title: Text(widget.title),
        backgroundColor: clearColor,
        shadowColor: clearColor,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios), onPressed: previousPage),
      ),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            // Right Swipe
            previousPage();
          } else if (details.delta.dx < -sensitivity) {
            //Left Swipe
          }
        },
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 35,
              color: primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 25,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20, top: 5, right: 20, bottom: 5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: primaryColor),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 35,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Expanded(
                                child: Text(
                              ""
                              "Team 1\nWin Chance",
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                                child: Center(
                                    child: Text(
                              "${(winChance * 10000).toInt() / 100}%",
                              style: const TextStyle(fontSize: 70),
                              textAlign: TextAlign.center,
                            )))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 75,
                    child: Column(
                      children: [
                        Text(valorantMaps[widget.data["map"]![0]]),
                        Column(
                          children: [
                            const Text("Team 1: "),
                            for (var i in widget.data["team1"]!)
                              Text(
                                valorantAgents[i],
                                style: const TextStyle(fontSize: 25),
                              )
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Team 2: "),
                            for (var i in widget.data["team2"]!)
                              Text(
                                valorantAgents[i],
                                style: const TextStyle(fontSize: 25),
                              )
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void previousPage() {
    Navigator.pop(context);
  }
}
