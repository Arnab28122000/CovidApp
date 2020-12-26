import 'dart:async';
import 'dart:convert';
import '../models/CovidData.dart';


import 'package:http/http.dart' as http;

Future<List<CovidData>> fetchdata() async {
  final response =
      await http.get('https://coronavirus-19-api.herokuapp.com/countries');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final List jsonResponse=json.decode(response.body);
    return jsonResponse.map((job) => new CovidData.fromJson(job)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}


