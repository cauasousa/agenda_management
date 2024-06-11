import 'package:flutter/material.dart';
import 'package:Agenda_Management/model/events.dart';
import 'package:Agenda_Management/views/avaliacion/page_avaliaction.dart';
import 'package:Agenda_Management/views/caledar/Page_Caledar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();

  List<Map<DateTime, List<Event>>> todos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Management',
      home: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        scrollBehavior: ScrollBehavior(),
        children: [
          PageCalendario(controller: _controller, id: 0, todos: todos),
          PageAvaliation(controller: _controller, id: 1),
        ],
      ),
    );
  }
}
