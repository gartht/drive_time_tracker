class Weather {
  int id;
  String description;
  String main;

  Weather({this.id, this.description, this.main});

  Weather.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        main = json['main'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'main': main,
      };
}
