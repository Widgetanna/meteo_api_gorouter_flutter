import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:my_meteo_flutter/service/geoloc_service.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//-----recuperer json depuis Api
class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.weatherapi.com/v1/current.json';

  static String get weatherApiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  final List<String> cities = ['London', 'New York', 'Tokyo', 'Sydney'];

  Map<String, dynamic> get commonQueryParameters => {
        'key': weatherApiKey,
        'localtime': 'true',
        'text': 'text',
      };

  WeatherData _parseWeatherData(Map<String, dynamic> data) {
    final temperature = data['current']['temp_c'];
    final cityName = data['location']['name'];
    final localtime = data['location']['localtime'];
    final text = data['current']['condition']['text'];

    final localDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(localtime);
    final date = DateFormat('dd/MM/yyyy HH:mm').format(localDateTime);

    return WeatherData(
      city: cityName,
      temperature: temperature,
      localtime: date,
      text: text,
    );
  }

  Future<List<WeatherData>> fetchTemperatures() async {
    final List<WeatherData> temperatures = [];

    for (final city in cities) {
      final response = await _dio.get(_baseUrl, queryParameters: {
        ...commonQueryParameters,
        'q': city,
      });

      temperatures.add(_parseWeatherData(response.data));
    }
    return temperatures;
  }

  Future<WeatherData> getCityFromTextField(String? cityName) async {
    // Vérifier que cityName n'est pas null avant de l'utiliser
    if (cityName == null) {
      // Gérer le cas où cityName est null, par exemple en renvoyant une erreur
      throw ArgumentError('City name cannot be null');
    }

    final response = await _dio.get(_baseUrl, queryParameters: {
      ...commonQueryParameters,
      'q': cityName,
    });

   
    if (response.data != null) {
      return _parseWeatherData(response.data);
    } else {
    
      throw Exception('Failed to get weather data for $cityName');
    }
  }

 Future<WeatherData> getCityName() async {
  try {
    final geoposition = await GeoLocalisation().getLocation();
    final response = await _dio.get(_baseUrl, queryParameters: {
      ...commonQueryParameters,
      'q': geoposition,
    });

    if (response.data != null) {
      return _parseWeatherData(response.data);
    } else {
      throw Exception('Failed to get weather data for $geoposition');
    }
  } catch (e) {
   print('Error: $e');
    rethrow;
  }
}

}
