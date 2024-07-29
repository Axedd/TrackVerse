import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';


// Google Search API
class Logo extends ChangeNotifier {
  final String searchUrl = 'https://www.googleapis.com/customsearch/v1';
  final String cseId;
  final String apiKey;
  List<String> imageUrls = [];
  

  Logo({required this.cseId, required this.apiKey});

  Future<void> fetchLogo(String query) async {
    final params = {
      'q': query,
      'cx': cseId,
      'key': apiKey,
      'searchType': 'image',
      'num': '5',
    };

    final uri = Uri.parse(searchUrl).replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (data['items'] != null) {
        for (var item in data['items']) {
          if (item['link'] != null) {
            imageUrls.add(item['link']);
          }
        }
      }

    } else {
      throw Exception('Failed to load images');
    }
  }
}