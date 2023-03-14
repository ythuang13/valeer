import 'package:flutter/material.dart';

import './setting.dart';
import './team2.dart';

class Team1Page extends StatefulWidget {
  const Team1Page({Key? key, required this.data}) : super(key: key);

  final Map<String, List<int>> data;
  final String title = "TEAM 1";

  @override
  State<Team1Page> createState() => _Team1PageState();
}

class _Team1PageState extends State<Team1Page> {
  int selectAgentCount = 5;
  List<int> selectAgentIndex = [];

  bool nextPageReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        title: Text(widget.title),
        backgroundColor: clearColor,
        shadowColor: clearColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: nextPageReady ? nextPage : null,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: previousPage,
        ),
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
            // Left Swipe
            nextPage();
          }
        },
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 35,
              color: primaryColor,
            ),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Agents',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                    itemCount: valorantAgents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, int index) {
                      return InkWell(
                        radius: 10,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (selectAgentIndex.contains(index)) {
                            selectAgentIndex.remove(index);
                          } else {
                            if (selectAgentIndex.length >= selectAgentCount) {
                              selectAgentIndex.removeAt(0);
                            }
                            selectAgentIndex.add(index);
                          }
                          setState(() {
                            nextPageReady =
                                selectAgentIndex.length == selectAgentCount;
                            widget.data["team1"] = selectAgentIndex;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectAgentIndex.contains(index)
                                ? primaryColor
                                : backgroundColor,
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          child: Center(
                              child: Column(
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      "assets/${valorantAgents[index]}_icon.webp")),
                              Text(valorantAgents[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: selectAgentIndex.contains(index)
                                          ? backgroundColor
                                          : primaryColor))
                            ],
                          )),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void nextPage() {
    if (nextPageReady) {
      Navigator.push(
          context,
          _createRoute());
    }
  }

  void previousPage() {
    Navigator.pop(context);
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Team2Page(data: widget.data),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
