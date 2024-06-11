import 'package:flutter/material.dart';
import 'package:Agenda_Management/model/events.dart';
import 'package:Agenda_Management/model/renda.dart';
import 'package:Agenda_Management/repository/repository.dart';
import 'package:Agenda_Management/views/avaliacion/card/widget_card.dart';
import 'package:Agenda_Management/views/custom_drawer/custom_drawer.dart';

class PageAvaliation extends StatefulWidget {
  const PageAvaliation({super.key, required this.controller, required this.id});

  final PageController controller;
  final int id;

  @override
  State<PageAvaliation> createState() => _PageAvaliationState();
}

class _PageAvaliationState extends State<PageAvaliation> {
  final TodoRepository _todoreposiy = TodoRepository();
  late List<Map<DateTime, List<Event>>> _todos;
  Map<String, List<Event>> meses = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _todoreposiy.getTodoList().then((value) {
      _todos = value;
      _filtro();
      _scrollController.animateTo(
        140 * cal().toDouble(), 
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: WidgetCustomDrawer(controller: widget.controller, id: widget.id),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Orçamentos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF730D62),
      ),
      body: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(12.0),
        children: cards(),
      ),
    );
  }

  List<CardWidget> cards() {
    List<CardWidget> cardsList = [];

    meses.forEach((key, value) {
      double despesas = 0.0;
      double receita = 0.0;

      for (Event element in value) {
        if (element.category == 'Renda') {
          receita += element.value;
        } else {
          despesas -= element.value;
        }
      }

      cardsList.add(
        CardWidget(
          month: key,
          despesas: Data('Despesas', despesas),
          renda: Data('Receita', receita),
        ),
      );
    });

    return cardsList;
  }

  _filtro() {
    for (Map<DateTime, List<Event>> map_element in _todos) {
      map_element.forEach((key, value) {
        value.forEach((element) {
          String month = '';
          if (element.date.month == 1) month = 'Jan';
          if (element.date.month == 2) month = 'Fev';
          if (element.date.month == 3) month = 'Mar';
          if (element.date.month == 4) month = 'Abr';
          if (element.date.month == 5) month = 'Mai';
          if (element.date.month == 6) month = 'Jun';
          if (element.date.month == 7) month = 'Jul';
          if (element.date.month == 8) month = 'Ago';
          if (element.date.month == 9) month = 'Set';
          if (element.date.month == 10) month = 'Out';
          if (element.date.month == 11) month = 'Nov';
          if (element.date.month == 12) month = 'Dez';

          if (meses["$month ${element.date.year}"] != null) {
            meses["$month ${element.date.year}"]?.add(element);
          } else {
            meses.addAll({
              "$month ${element.date.year}": [element]
            });
          }
        });
      });
    }
    setState(() {
      meses = ordenarMapaPorChave(meses);
    });
  }

  Map<String, List<Event>> ordenarMapaPorChave(Map<String, List<Event>> mapa) {
    List<Map<String, List<Event>>> trab = [];

    mapa.forEach((key, value) {
      trab.add({key: value});
    });

    if (mapa.length == 0) return mapa;
    if (mapa.length == 1) return mapa;

    int otimiz = 0;

    for (int i = 0; i < trab.length - otimiz; i++) {
      for (int index = 0; index < trab.length - 1; index++) {
        Map<String, List<Event>> a = trab[index];
        Map<String, List<Event>> b = trab[index + 1];

        String keya = a.keys.first;
        String keyb = b.keys.first;

        List<String> aParts = keya.split('-')[0].split(' ');
        List<String> bParts = keyb.split('-')[0].split(' ');

        String month = intMonth(aParts[0]);
        DateTime date1 = DateTime.parse('${aParts[1]}-${month}-01');

        month = intMonth(bParts[0]);
        DateTime date2 = DateTime.parse('${bParts[1]}-${month}-01');

        if (date1.isAfter(date2) == true) {
          trab.removeAt(index);

          trab.insertAll(index + 1, [a]);
        }
      }
      otimiz += 1;
    }

    Map<String, List<Event>> new_mapa = {};
    trab = trab.reversed.toList();

    trab.forEach((e) {
      new_mapa.addAll(e);
    });

    return new_mapa;
  }

  intMonth(String Stringmonth){
    String month = '01';

    if (Stringmonth == 'Jan') month = '01';
        if (Stringmonth == 'Fev') month = '02';
        if (Stringmonth == 'Mar') month = '03';
        if (Stringmonth == 'Abr') month = '04';
        if (Stringmonth == 'Mai') month = '05';
        if (Stringmonth == 'Jun') month = '06';
        if (Stringmonth == 'Jul') month = '07';
        if (Stringmonth == 'Ago') month = '08';
        if (Stringmonth == 'Set') month = '09';
        if (Stringmonth == 'Out') month = '10';
        if (Stringmonth == 'Nov') month = '11';
        if (Stringmonth == 'Dez') month = '12';

      return month;
      
  }

  int cal(){
    int cont = 0;
    DateTime today = DateTime.now();
    meses.forEach((key, value) {

        List<String> aParts = key.split('-')[0].split(' ');
        DateTime date1 = DateTime.parse('${aParts[1]}-${intMonth(aParts[0])}-01');

        if(today.isBefore(date1)){
          cont++;
        }

    });
    return cont;
  }
}
