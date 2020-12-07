import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  String endpoint;

  NetworkService(this.endpoint);

  Future getData() async {
    var response = await http.get(endpoint);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print("An error occurred retrieving the data: ${response.statusCode}");
      return null;
    }
  }
}
