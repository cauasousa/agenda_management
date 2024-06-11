class Event {

  String title;
  String description;
  String category;
  double value;
  int qntDay;
  String key;
  DateTime date;

  Event({required this.key, required this.description, required this.value, required this.title, required this.date, required this.category, required this.qntDay});

  Event.fromJson( json):key = json['key'], title = json['title'], date =DateTime.tryParse(json['date'])!, description = json['description'], value = json['value'], category = json['category'], qntDay = json['repeat'];

  toJson(){
    return {
      'key':key,
      'title' : title,
      'description' : description,
      'category' : category,
      "value" : value,
      "repeat" : qntDay,
      "date" : date.toString(),
      
    };
  }

}


