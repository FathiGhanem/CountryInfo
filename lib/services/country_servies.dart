import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_info/models/country_model.dart';

class CountryServies {
  Future<CountryModel> fetchCountry(String name) async {
    final response = await http.get(
      Uri.parse("https://restcountries.com/v3.1/name/$name"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)[0];

      return CountryModel.fromJson(data);
    } else {
      throw Exception('Error fetching country data');
    }
  }

  Future<List<CountryModel>> fetchCountrys(List<String> names) async {
    List<CountryModel> countrys = [];
    for (int i = 1; i < names.length; i++) {
      final response = await http.get(
        Uri.parse("https://restcountries.com/v3.1/name/${names[i]}"),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body)[0];
        countrys.add(CountryModel.fromJson(data));
      } else {
        throw Exception('Error fetching country');
      }
    }

    return countrys;
  }
}
