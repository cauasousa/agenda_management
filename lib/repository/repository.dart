import 'dart:convert';
import 'package:Agenda_Management/model/events.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keyTodo = 'todos';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Map<DateTime, List<Event>>>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final String todoJson = sharedPreferences.getString(keyTodo) ?? '[]';
    final List listTodo = json.decode(todoJson) as List;
    List<Map<DateTime, List<Event>>> todos = [];

    listTodo.forEach((e) {

      Map<DateTime, List<Event>> todosMap = {};

      e.forEach((key, value) {

        List<Event> listeventos = [];

        for (var element in value) {
          listeventos.add(Event.fromJson(element));
        }

        todosMap.addAll({DateTime.parse(key): listeventos});
      });

      todos.add(todosMap);
    });
    
    return todos ;
  }

  Future saveTodoList(List<Map<DateTime, List<Event>>> todos) async {

    List<Map<String, List>> newList = [];

    for (var element in todos) {
      element.forEach((key, value) {
        
        List<Map> listEventos = [];

        for (var i in value) {
          listEventos.add(i.toJson());
        }

        newList.add({"${key.toString()}": listEventos});
      });
    }

    String jsonString = json.encode(newList);
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(keyTodo, jsonString);
  }
}
