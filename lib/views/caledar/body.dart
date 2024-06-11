import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Agenda_Management/model/events.dart';
import 'package:Agenda_Management/repository/keygerator.dart';
import 'package:Agenda_Management/repository/notification.dart';
import 'package:Agenda_Management/repository/repository.dart';
import 'package:Agenda_Management/views/caledar/add_Item/Page_add_item.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class Bodypage extends StatefulWidget {
  Bodypage({
    super.key,
    required this.todos,
    required this.todoreposiy,
    required this.boolmonther,
    required this.focusedDay,
    required this.selectedDay,
    required this.selectedEvents,
    required this.selectedEventsSl,
    required this.calendarFormat,
    required this.rangeSelectionMode,
    required this.rangeStart,
    required this.rangeEnd,
    required this.eventsForMonth,
    required this.getEventsForDay,
  });

  final TodoRepository todoreposiy;
  List<Map<DateTime, List<Event>>> todos = [];
  bool boolmonther;
  DateTime focusedDay;
  DateTime selectedDay;

  ValueNotifier<List<Event>> selectedEvents = ValueNotifier([]);
  ValueNotifier<List<Event>> selectedEventsSl = ValueNotifier([]);

  CalendarFormat calendarFormat;
  RangeSelectionMode rangeSelectionMode;

  DateTime? rangeStart;
  DateTime? rangeEnd;
  List<Event> eventsForMonth;

  final List<Event> Function(DateTime day) getEventsForDay;

  @override
  State<Bodypage> createState() => _Bodypage();
}

class _Bodypage extends State<Bodypage> {
  final TextEditingController controllerTitulo = TextEditingController();
  final TextEditingController controllerValue = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  NotificationAPP _notification = NotificationAPP();

  @override
  void initState() {
    super.initState();
    initializeData();
    _notification.initizalize();
    _notification.agendarNotification(todos: widget.todos);
  }

  @override
  void dispose() {
    widget.selectedEvents.dispose();
    widget.selectedEventsSl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF730D62),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final cellWidth = constraints.maxWidth / 7;
                final cellHeight = cellWidth;

                return Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: TableCalendar<Event>(
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2060, 10, 16),
                    focusedDay: widget.focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(widget.selectedDay, day),
                    rangeStartDay: widget.rangeStart,
                    rangeEndDay: widget.rangeEnd,
                    calendarFormat: widget.calendarFormat,
                    rangeSelectionMode: widget.rangeSelectionMode,
                    eventLoader: (day) {
                      return widget.getEventsForDay(day);
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextFormatter: (date, locale) {
                        String day = DateFormat.E(locale).format(date);
                        if (day == 'Mon') return 'Seg';
                        if (day == 'Tue') return 'Ter';
                        if (day == 'Wed') return 'Qua';
                        if (day == 'Thu') return 'Qui';
                        if (day == 'Fri') return 'Sex';
                        if (day == 'Sat') return 'Sab';
                        if (day == 'Sun') return 'Dom';

                        return DateFormat.E(locale).format(date);
                      },
                      weekdayStyle: TextStyle(fontSize: 12),
                      weekendStyle: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return Container(
                          width: cellWidth,
                          height: cellHeight,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFD9328E),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Container(
                          width: cellWidth,
                          height: cellHeight,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return Container(
                          width: cellWidth,
                          height: cellHeight,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (widget.calendarFormat != format) {
                        setState(() {
                          widget.calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      widget.focusedDay = focusedDay;
                    },
                    onDayLongPressed: (selectedDay, focusedDay) {
                      controllerTitulo.text = '';
                      controllerDescription.text = '';
                      controllerValue.text = '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PageAddItem(
                            selectedDay: selectedDay,
                            addCard: addItem,
                            controllerTitulo: controllerTitulo,
                            controllerValue: controllerValue,
                            controllerDescription: controllerDescription,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 4.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: widget.selectedEventsSl,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFD9328E)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.6,
                            children: [
                              SlidableAction(
                                label: 'Delete',
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                onPressed: (context) {
                                  onDelete(value[index]);
                                },
                              ),
                              SlidableAction(
                                label: 'Edit',
                                backgroundColor: Colors.green,
                                icon: Icons.edit,
                                onPressed: (context) {
                                  controllerTitulo.text = value[index].title;
                                  controllerDescription.text =
                                      value[index].description;
                                  controllerValue.text =
                                      value[index].value.toString();

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PageAddItem(
                                      selectedDay: value[index].date,
                                      qntDay: value[index].qntDay,
                                      addCard: ({
                                        required String title,
                                        required String category,
                                        required String description,
                                        required String values,
                                        required int qntDay,
                                        required DateTime day,
                                      }) {
                                        setState(() {
                                          onUpdate(
                                              title: title,
                                              category: category,
                                              description: description,
                                              values: values,
                                              qntDay: qntDay,
                                              day: day,
                                              index: index,
                                              elem: value[index]);
                                        });
                                      },
                                      controllerTitulo: controllerTitulo,
                                      controllerValue: controllerValue,
                                      controllerDescription:
                                          controllerDescription,
                                      dropdownValuee: value[index].category,
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {},
                            onLongPress: () {},
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${value[index].title}',
                                        style: TextStyle(
                                          color: Color(0xFF3F1A40),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        value[index].category == "Renda"
                                            ? 'R\$ ${value[index].value}'
                                            : 'R\$ -${value[index].value}',
                                        style: TextStyle(
                                          color:
                                              value[index].category == "Renda"
                                                  ? Colors.blue
                                                  : Color(0xFFF23D3D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${value[index].date.day}/${value[index].date.month}/${value[index].date.year}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF3F1A40),
                                  ),
                                ),
                                Text(
                                  '${value[index].description}',
                                  style: TextStyle(
                                    color: Color(0xFF730D62),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  addItem(
      {required String title,
      required String category,
      required String description,
      required String values,
      required int qntDay,
      required DateTime day,
      String? key}) async {
    key = key ?? await KeyGenerator.getKey();

    int repeat = 0;
    int incr = -1;

    if (qntDay == 1) {
      repeat = 0;
      incr = 0;
    }
    if (qntDay == 2) {
      incr = 1;

      repeat = 361;
    }
    if (qntDay == 3) {
      incr = 7;

      repeat = 27;
    }

    if (qntDay == 4) {
      repeat = 24;
      incr = 1;
    }
    if (qntDay == 5) {
      incr = 1;
      repeat = 5;
    }

    var data = day.copyWith();

    while (repeat >= 0) {
      bool sent = false;

      for (var element in widget.todos) {
        if (element.keys.first == data) {
          sent = true;

          element[data]?.addAll([
            Event(
              key: key,
              title: title,
              date: day,
              description: description,
              qntDay: qntDay,
              value: double.tryParse(values) ?? 0.0,
              category: category,
            ),
          ]);
        }
      }

      if (!sent) {
        widget.todos.add(
          {
            data: [
              Event(
                key: key,
                title: title,
                date: data,
                description: description,
                qntDay: qntDay,
                value: double.tryParse(values) ?? 0.0,
                category: category,
              ),
            ],
          },
        );
      }

      if (qntDay >= 4) {
        if (qntDay == 4) {
          data = DateTime(data.year, data.month + incr, data.day);
        } else {
          data = DateTime(data.year + incr, data.month, data.day);
        }
      } else {
        if (qntDay == 1) {
          break;
        }

        data = data.add(Duration(days: incr));
      }

      repeat -= 1;
    }

    widget.todoreposiy.saveTodoList(widget.todos).then((value) {
      _notification.agendarNotification(todos: widget.todos);
      _private();
    });
  }

  onUpdate({
    required String title,
    required String category,
    required String description,
    required String values,
    required DateTime day,
    required int qntDay,
    required int index,
    required Event elem,
  }) {
    onDelete(elem);
    addItem(
        title: title,
        category: category,
        description: description,
        values: values,
        qntDay: qntDay,
        day: day);
  }

  onDelete(Event remove) {
    String keyRemove = remove.key;

    for (Map<DateTime, List<Event>> element in List.from(widget.todos)) {
      element.forEach((key, value) {
        bool achei = false;
        Event? removind;

        for (Event eventos in value) {
          if (eventos.key == keyRemove &&
              (eventos.date.isAfter(DateTime.now()) || eventos == remove)) {
            removind = eventos;
            achei = true;
          }
        }

        if (achei) {
          value.remove(removind);

          if (value.isEmpty) {
            widget.todos.remove(element);
          }
        }
      });
    }

    widget.todoreposiy.saveTodoList(widget.todos).then((value) {
      print("Deletou!!");
      _notification.agendarNotification(todos: widget.todos);
      _private();
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      widget.selectedDay = selectedDay;
      widget.focusedDay = focusedDay;
      widget.rangeStart = null;
      widget.rangeEnd = null;
      widget.rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    var stoge = widget.getEventsForDay(selectedDay);

    widget.selectedEvents.value = stoge;

    if (widget.boolmonther) {
      setState(() {
        widget.selectedEventsSl.value = List<Event>.from(widget.eventsForMonth);
        ;
      });
    } else {
      setState(() {
        widget.selectedEventsSl.value = List<Event>.from(stoge);
      });
    }
  }

  initializeData() {
    widget.todoreposiy.getTodoList().then((value) {
      setState(() {
        widget.todos = value;

        widget.selectedDay = widget.focusedDay;
        var valuer = ValueNotifier(widget.getEventsForDay(widget.selectedDay));
        widget.selectedEvents = valuer;

        widget.selectedEventsSl = ValueNotifier(widget.eventsForMonth);

        widget.selectedEventsSl.value = widget.eventsForMonth;
      });
    });
  }

  _private() {
    Map<DateTime, List<Event>> eventSource = {};

    for (var element in widget.todos) {
      eventSource.addAll(element);
    }

    var kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: (DateTime key) =>
          key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(eventSource);

    widget.eventsForMonth = [];

    kEvents.forEach((key, value) {
      if (key.year == widget.selectedDay.year &&
          key.month == widget.selectedDay.month) {
        widget.eventsForMonth.addAll(value);
      }
    });

    widget.selectedEvents = ValueNotifier(kEvents[widget.selectedDay] ?? []);

    if (widget.boolmonther) {
      setState(() {
        widget.selectedEventsSl = ValueNotifier(widget.eventsForMonth);
      });
    } else {
      setState(() {
        widget.selectedEventsSl = widget.selectedEvents;
      });
    }
  }
}
