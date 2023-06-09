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
    output.then((value) {
      print(value);
      winChance = value;
      setState(() {});
    }).catchError((error) {
      print(error);
    });
  }

  Future<double> prediction() async {
    var data = widget.data;
    // process input
    final map = valorantMaps[data["map"]![0]];
    var input = [List<double>.generate(34, (i) => 0.0)];

    for (int i = 0; i < 5; i++) {
      input[0][data["team1"]![i]] += 1.0;
      input[0][data["team2"]![i] + 17] += 1.0;
    }

    // check if same team comp, if true, return 0.5
    bool match = true;
    for (int num in data["team1"]!) {
      List<int> team2 = data["team2"]!;
      if (!(team2.contains(num))) {
        match = false;
        break;
      }
    }
    if (match) {
      return 0.5;
    }

    final interpreter = await Interpreter.fromAsset('models/model_$map.tflite');

    // if output tensor shape [1,2] and type is float32
    var output = List.filled(1 * 2, 0).reshape([1, 2]);

    // inference
    interpreter.run(input, output);

    // return win chance
    return output[0][0];
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
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, top: 5, right: 20, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/maps/${valorantMaps[widget.data["map"]![0]]}.png"),
                              fit: BoxFit.cover)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 45,
                            child: showTeamComp(widget.data['team1']!),
                          ),
                          const Expanded(
                              flex: 10,
                              child: Text(
                                  "VS",
                                 style: TextStyle(
                                   color: backgroundColor,
                                   fontWeight: FontWeight.w900
                                 ),
                              )),
                          Expanded(
                            flex: 45,
                            child: showTeamComp(widget.data['team2']!),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column showTeamComp(List<int> teamComp) {
    teamComp.sort();

    return Column(
      children: [
        Expanded(
          flex:50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                agentContainer("assets/agents/${valorantAgents[teamComp[0]]}_icon.webp"),
                agentContainer("assets/agents/${valorantAgents[teamComp[1]]}_icon.webp"),
                agentContainer("assets/agents/${valorantAgents[teamComp[2]]}_icon.webp"),

              ],
            ),
          ),
        ),
        Expanded(
          flex: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              agentContainer("assets/agents/${valorantAgents[teamComp[3]]}_icon.webp"),
              agentContainer("assets/agents/${valorantAgents[teamComp[4]]}_icon.webp"),
            ],
          ),
        ),
      ],
    );
  }

  Container agentContainer(String asset) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(
          color: primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(1),
      child: Center(
          child: Column(
        children: [Expanded(child: Image.asset(asset))],
      )),
    );
  }

  void previousPage() {
    Navigator.pop(context);
  }
}
