import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
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

    winChance = Random().nextDouble();

  }

  Future<void> _initTFLite() async {

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
