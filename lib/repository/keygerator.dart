import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class KeyGenerator {
  static const String _keyPref = 'unique_key';

  static Future<String> getKey() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? keys = prefs.getString(_keyPref);
    
    final List listTodo = json.decode(keys ?? '[]') as List;

    String key;
    bool achou = false;

    do{

      key = Uuid().v4();

      for (var element in listTodo) {
        if(element == key){
          achou = true;
        }
      }

    }while(achou != false);

    listTodo.add(key);

    String jsonString = json.encode(listTodo);
    await prefs.setString(_keyPref, jsonString);
    
    return key;
  }

  static removeKey(String key) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? keys = prefs.getString(_keyPref);
    
    final List listTodo = json.decode(keys ?? '[]') as List;

    int index = 0;

    for (var element in listTodo) {
      if(element == key){
        break;
      }
      index++;
    }

    listTodo.removeAt(index);

    String jsonString = json.encode(listTodo);
    await prefs.setString(_keyPref, jsonString);
    
  }
}