import 'package:flutter/material.dart';
import 'package:Agenda_Management/model/renda.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  CardWidget(
      {super.key,
      required this.month,
      required this.renda,
      required this.despesas});

  String month;
  Data renda, despesas;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 213, 244),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                month,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                width: 100,
                child: SfCircularChart(
                  margin: EdgeInsets.all(0),
                  palette: [Colors.green, Colors.red],
                  series: <CircularSeries<Data, String>>[
                    DoughnutSeries<Data, String>(
                      explodeIndex: 0,
                      dataSource: [
                        renda,
                        despesas,
                      ],
                      xValueMapper: (Data data, _) => data.title,
                      yValueMapper: (Data data, _) => data.yData,
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                      strokeColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Receitas: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        "R\$ ${renda.yData}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Despesas: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        "R\$ ${despesas.yData}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Total: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        "R\$ ${renda.yData + despesas.yData}",
                        style: TextStyle(
                          color: renda.yData + despesas.yData >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
