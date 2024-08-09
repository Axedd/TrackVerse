import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/api/service_db_beverage.dart';

class BeverageDropdown extends StatefulWidget {
  final Function(String, num) onSelected;

  const BeverageDropdown({super.key, required this.onSelected});

  @override
  State<BeverageDropdown> createState() => BeverageDropdownState();
}

class BeverageDropdownState extends State<BeverageDropdown> {
  List<Map<dynamic, dynamic>>? beverages;
  String? dropdownValue;
  num? selectedQuantity;
  final TextEditingController _searchController = TextEditingController();
  List<Map<dynamic, dynamic>> filteredBeverages = [];

  @override
  void initState() {
    super.initState();
    // Ensure that we start with the full list of beverages
    _searchController.addListener(_filterBeverages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilteredBeverages();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBeverages);
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredBeverages() {
    setState(() {
      filteredBeverages = beverages ?? [];
    });
  }

  void _filterBeverages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBeverages = beverages!.where((beverage) {
        return beverage['type'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Beverage'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: filteredBeverages.map<Widget>((Map<dynamic, dynamic> beverage) {
                      return ListTile(
                        title: Text(beverage['type']),
                        onTap: () {
                          setState(() {
                            dropdownValue = beverage['type'].toString();
                            selectedQuantity = beverage['quantity'];
                            Provider.of<ServiceDB>(context, listen: false).beverageChosen = dropdownValue;
                            widget.onSelected(dropdownValue!, selectedQuantity!);
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    beverages = Provider.of<ServiceDB>(context, listen: false).dataList;
    _updateFilteredBeverages(); // Ensure filtered beverages are updated

    dropdownValue = dropdownValue ?? (beverages!.isNotEmpty ? beverages![0]['type'].toString() : null);
    Provider.of<ServiceDB>(context, listen: false).beverageChosen = dropdownValue;

    return ElevatedButton(
      onPressed: _showSearchDialog,
      child: Text(dropdownValue ?? 'Select Beverage'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
      ),
    );
  }
}