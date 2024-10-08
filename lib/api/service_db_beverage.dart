import 'package:app/api/logo_api.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app/api/utils.dart';

// Initialize Supabase client
final client = SupabaseClient(
  dotenv.env['DB_URL']!,
  dotenv.env['KEY']!,
);

final supabase = Supabase.instance.client;

class ServiceDB extends ChangeNotifier {
  List<Map<dynamic, dynamic>> _dataList = [];
  List<Map<dynamic, dynamic>> get dataList => _dataList;

  String? beverageChosen = 'None';
  num? beverageAmount = 0;
  String? initialImageUrl = '';

  // Fetch data from Supabase
  Future<List<Map<dynamic, dynamic>>> getData() async {
    try {
      final response = await supabase.from('beverage').select('*');
      _dataList = List<Map<dynamic, dynamic>>.from(response);
      if (_dataList.isNotEmpty) {
        beverageChosen = _dataList[0]['type'];
        print(beverageChosen);
        beverageAmount = _dataList[0]['quantity'];
        initialImageUrl = _dataList[0]['image_url'];
      }
      notifyListeners();
      return _dataList;
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

  Future<void> updateDataValues(String type, String initialType, num quantity,
      {Color? beverageColor}) async {
    print("Initial Type: $initialType");
    print("New Type: $type");

    try {
      Map<String, dynamic> updateData = {
        'type': type,
        'quantity': quantity,
      };

      if (beverageColor != null) {
        updateData['color'] = beverageColor.value.toString();
        print("Updating with color: $updateData");

        await supabase.from('beverage').update(updateData).eq('type', initialType);
      } else {
        print("Updating without color: $updateData");

        await supabase.from('beverage').update(updateData).eq('type', initialType);
      }

      await _updateLocalData(initialType, type, quantity, beverageColor);
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  Future<void> _updateLocalData(String initialType, String type, num quantity,
      Color? beverageColor) async {
    for (var item in _dataList) {
      if (item['type'] == initialType) {
        item['type'] = type;
        item['quantity'] = quantity;
        if (beverageColor != null) {
          item['color'] = beverageColor.value.toString();
        }
        notifyListeners();
        break;
      }
    }
    await insertDateData(type, quantity);
    notifyListeners();
  }

  // Add new beverage
  Future<void> addBeverage(String type, num quantity, String img_url) async {
    try {
      _dataList.add({'type': type, 'quantity': quantity, 'image_url': img_url});
      await supabase
          .from('beverage')
          .insert({'type': type, 'quantity': quantity, 'image_url': img_url});
      await insertDateData(type, quantity);

      notifyListeners();
    } catch (error) {
      print('Error adding beverage: $error');
    }
  }

  // Insert date data
  Future<void> insertDateData(String type, num quantity) async {
    try {
      String date = await getDate();
      final response = await supabase.rpc('update_beverages', params: {
        'date': date,
        'new_beverage': {type: quantity}
      });

      if (response == null) {
        print('Error: Response is null');
        return;
      }

      if (response.error != null) {
        print('Error: ${response.error!.message}');
      } else {
        print('Data updated successfully');
      }
    } catch (error) {
      print('Error inserting date data: $error');
    }
  }
}
