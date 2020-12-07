class Weather {
  int id;
  String description;
  String main;

  Weather({this.id, this.description, this.main});

  Weather.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      id = json['id'];
      description = json['description'];
      main = json['main'];
    } else {
      return;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'main': main,
      };
}
