import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './setting.dart';
import './team1.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});

  final String title;

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  int selectMapCount = 1;
  List<int> selectMapIndex = [];

  Map<String, List<int>> data = {"map": [], "team1": [], "team2": []};

  bool nextPageReady = false;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: nextPageReady ? nextPage : null,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            // Right Swipe
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
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Maps',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                    itemCount: valorantMaps.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, int index) {
                      return InkWell(
                        radius: 10,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (selectMapIndex.contains(index)) {
                            selectMapIndex.remove(index);
                          } else {
                            if (selectMapIndex.length >= selectMapCount) {
                              selectMapIndex.removeAt(0);
                            }
                            selectMapIndex.add(index);
                          }
                          setState(() {
                            nextPageReady =
                                selectMapIndex.length == selectMapCount;
                            data["map"] = selectMapIndex;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectMapIndex.contains(index)
                                ? primaryColor
                                : backgroundColor,
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                              child: Column(
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      "assets/maps/${valorantMaps[index]}.png")),
                              Text(valorantMaps[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: selectMapIndex.contains(index)
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
        _createRoute()
      );
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Team1Page(data: data),
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
