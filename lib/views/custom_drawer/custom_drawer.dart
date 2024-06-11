import 'package:flutter/material.dart';
import 'package:Agenda_Management/views/caledar/add_Item/Page_add_item.dart';

class WidgetCustomDrawer extends StatefulWidget {
  WidgetCustomDrawer({super.key, required this.controller, required this.id});

  final PageController controller;
  final int id;

  @override
  State<WidgetCustomDrawer> createState() => _WidgetCustomDrawerState();
}

class _WidgetCustomDrawerState extends State<WidgetCustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          _buildBodyBack(),
          ListView(
            padding: EdgeInsets.only(left: 20.0, top: 30.0),
            children: [
              Container(
                height: 160,
                child: Stack(
                  children: [
                    Text(
                      "Gestão de Dindin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 65,
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeIn,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (widget.id ==
                            widget.controller.page!.ceilToDouble()) {
                          widget.controller.jumpToPage(0);
                        }
                      },
                      splashColor: cor1,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 30,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8)),
                            Text(
                              "Home",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(padding: EdgeInsets.all(8)),
              Container(
                height: 65,
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeIn,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (widget.id ==
                            widget.controller.page!.ceilToDouble()) {
                          widget.controller.jumpToPage(1);
                        }
                      },
                      splashColor: cor1,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_available_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8)),
                            Text(
                              "Desempenho",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildBodyBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Color(0xFF023535),
            // Color(0xFF0FC2C0),
            // Color(0xFF000B0D),
            Color(0xFF3F1A40),
            Color(0xFFD9328E),
            // Color(0xFFF2CEF0),
          ],
        ),
      ),
    );
  }
}
