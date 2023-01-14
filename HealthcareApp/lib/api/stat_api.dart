import 'dart:convert';
import 'package:http/http.dart' as http;

class StatApi {
  static Future<List<dynamic>> getNumberOfSteps() async {
    var uri = Uri.parse('http://192.168.100.7:3200/getAllSteps');
    var response = await http.get(uri);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['result']);
      return data['result'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> getFrequency() async {
    var uri = Uri.parse('http://192.168.100.7:3200/getFrequency');
    var response = await http.get(uri);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['result']);
      return data['result'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
