import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/api/service_db_beverage.dart';
import 'package:app/widgets/card_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<Map<dynamic, dynamic>> beverageList;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch the data from the provider
    beverageList = Provider.of<ServiceDB>(context, listen: false).dataList;
  }

  @override
  Widget build(BuildContext context) {
    // Filter the beverage list based on the search query
    final filteredBeverageList = beverageList.where((beverage) {
      final type = beverage['type'].toLowerCase();
      return type.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TrackVerse - Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "FULL BEVERAGE LIST",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Search Beverage',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(height: 16), // Space between the search field and the list
          Expanded(
            child: ListView.builder(
              itemCount: filteredBeverageList.length,
              itemBuilder: (context, index) {
                final beverage = filteredBeverageList[index];
                return BeverageCard(
                  selectedBeverage: beverage['type'],
                  selectedQuantity: beverage['quantity'],
                  imageUrl: beverage['image_url'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}