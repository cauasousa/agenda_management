import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:Agenda_Management/model/events.dart';
import 'package:Agenda_Management/repository/repository.dart';
import 'package:Agenda_Management/views/caledar/body.dart';
import 'package:Agenda_Management/views/custom_drawer/custom_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class PageCalendario extends StatefulWidget {
  PageCalendario({super.key, required this.controller, required this.id, required this.todos});

  final PageController controller;
  final int id;

  DateTime focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Map<DateTime, List<Event>>> todos;

  @override
  State<PageCalendario> createState() => _PageCalendario();
}

class _PageCalendario extends State<PageCalendario> with SingleTickerProviderStateMixin {

  final TodoRepository todoreposiy = TodoRepository();
  List<Event> eventsForMonth = [];
  bool boolmonther = true;

  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);
  ValueNotifier<List<Event>> _selectedEventsSl = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  
  @override
  void initState() {
    super.initState();

    todoreposiy.getTodoList().then((value) {
      setState(() {
        widget.todos = value;

        widget._selectedDay = widget.focusedDay;

        var valuer = ValueNotifier(_getEventsForDay(widget._selectedDay));

        _selectedEvents = valuer;

        _selectedEventsSl = ValueNotifier(eventsForMonth);

        _selectedEventsSl.value = eventsForMonth;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: WidgetCustomDrawer(controller: widget.controller, id: widget.id),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Agenda',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  boolmonther = !boolmonther;

                  _selectedEvents.value = _getEventsForDay(widget.focusedDay);
                  if (boolmonther) {
                    _selectedEventsSl.value = eventsForMonth;
                  } else {
                    _selectedEventsSl.value = _selectedEvents.value;
                  }
                });
              },
              child: Text(
                boolmonther == true ? "Mês" : 'Dia',
                style: TextStyle(color: Color(0xFFF2CEF0)),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 252, 122, 194),
                ),
                shape: MaterialStatePropertyAll(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(8))
        ],
        backgroundColor: Color(0xFF730D62),
      ),
      body: Bodypage(
        todos: widget.todos,
        todoreposiy: todoreposiy,
        boolmonther: boolmonther,
        calendarFormat: _calendarFormat,
        eventsForMonth: eventsForMonth,
        focusedDay: widget.focusedDay,
        rangeEnd: _rangeEnd,
        rangeSelectionMode: _rangeSelectionMode,
        rangeStart: _rangeStart,
        selectedDay: widget._selectedDay,
        selectedEvents: _selectedEvents,
        selectedEventsSl: _selectedEventsSl,
        getEventsForDay: _getEventsForDay,
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    Map<DateTime, List<Event>> eventSource = {};

    for (var element in widget.todos) {
      eventSource.addAll(element);
    }

    var kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: (DateTime key) =>
          key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(eventSource);

    this.eventsForMonth = [];

    kEvents.forEach((key, value) {
      if (key.year == day.year && key.month == day.month) {
        this.eventsForMonth.addAll(value);
      }
    });

    return kEvents[day] ?? [];
  }
}
