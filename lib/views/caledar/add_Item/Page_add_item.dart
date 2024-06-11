import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color cor1 = Color(0xFFD9328E);
const Color cor2 = Color(0xFF3F1A40);
const Color cor3 = Color(0xFF730D62);
const Color cor4 = Color(0xFFF2CEF0);
const Color cor5 = Color(0xFFF23D3D);
List list = ['Renda', 'Despesa'];

// ignore: must_be_immutable
class PageAddItem extends StatefulWidget {
  PageAddItem({
    super.key,
    required this.selectedDay,
    required this.addCard,
    required this.controllerTitulo,
    required this.controllerValue,
    required this.controllerDescription,
    this.qntDay = 1,
    String? dropdownValuee,
  }) : dropdownValue = dropdownValuee ?? list.first;

  final DateTime selectedDay;
  int qntDay;

  final Function({
    required String title,
    required String category,
    required String description,
    required String values,
    required int qntDay,
    required DateTime day,
  }) addCard;

  String dropdownValue;
  final TextEditingController controllerTitulo;
  final TextEditingController controllerValue;
  final TextEditingController controllerDescription;

  @override
  State<PageAddItem> createState() => _PageAddItemState();
}

class _PageAddItemState extends State<PageAddItem> {
  bool testInvalTitulo = false;
  bool testInvalValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cor1,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          backbold(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.turned_in_outlined),
                      Text(
                        "Titúlo:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: widget.controllerTitulo,
                      style: TextStyle(height: 1),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: testInvalTitulo ? "Inválido" : null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: cor1,
                          ),
                        ),
                        hintText: 'Ex: Pagar boleto',
                        hintStyle: TextStyle(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (value) {
                        onvalidatedTitulo();
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                    children: [
                      Icon(Icons.category),
                      Text(
                        "Categoria:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.all(0),
                      initialSelection: widget.dropdownValue,
                      onSelected: (String? value) {
                        setState(() {
                          widget.dropdownValue = value!;
                        });
                      },
                      dropdownMenuEntries:
                          list.map<DropdownMenuEntry<String>>((value) {
                        return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text(
                        "Valor:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: widget.controllerValue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: testInvalValue ? "Inválido" : null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: cor1,
                          ),
                        ),
                        prefix: Text("R\$ "),
                        prefixStyle: TextStyle(color: Colors.black),
                        hintText: '18.88',
                        hintStyle: TextStyle(height: 1),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        onvalidatedValue();
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(6.0)),
                  Row(
                    children: [
                      Icon(Icons.edit),
                      Text(
                        "Descrição:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: widget.controllerDescription,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: cor1,
                          ),
                        ),
                        hintText: 'Lembrar de pagar meio dia',
                        hintStyle: TextStyle(height: 1),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomSlidingSegmentedControl<int>(
                        initialValue: widget.qntDay,
                        children: {
                          1: Text(
                            'Uma vez',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          2: Text(
                            'Diariamente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          3: Text(
                            'Semanalmente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          4: Text(
                            'Mensalmente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          5: Text(
                            'Anualmente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        },
                        decoration: BoxDecoration(
                          color: cor4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        thumbDecoration: BoxDecoration(
                          color: cor1,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            ),
                          ],
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInToLinear,
                        onValueChanged: (v) {
                          widget.qntDay = v;
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 0, 200),
                      ),
                      shape: MaterialStatePropertyAll(
                        LinearBorder(
                          side: BorderSide(
                            color: Color.fromARGB(255, 255, 0, 200),
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      height: 45,
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      onvalidated();
                      if ((!testInvalTitulo && !testInvalValue)) {
                        widget.addCard(
                          category: widget.dropdownValue,
                          title: widget.controllerTitulo.text,
                          values: widget.controllerValue.text,
                          description: widget.controllerDescription.text,
                          qntDay: widget.qntDay,
                          day: widget.selectedDay,
                        );

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onvalidated() {
    setState(() {
      testInvalValue = (widget.controllerValue.text == "" ||
          double.tryParse(widget.controllerValue.text) == null);

      testInvalTitulo = widget.controllerTitulo.text == "";
    });
  }

  onvalidatedValue() {
    setState(() {
      testInvalValue = (widget.controllerValue.text == "" ||
          double.tryParse(widget.controllerValue.text) == null);
    });
  }

  onvalidatedTitulo() {
    setState(() {
      testInvalTitulo = widget.controllerTitulo.text == "";
    });
  }

  Widget backbold() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // cor1,
            // Color(0xFFF1C7DD),
            Colors.white,
            Colors.white
          ],
        ),
      ),
    );
  }
}
