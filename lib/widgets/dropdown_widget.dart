import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/api/service_db_beverage.dart';

class BeverageDropdown extends StatefulWidget {
  final Function(String, num) onSelected;

  const BeverageDropdown(
      {super.key, required this.onSelected});

  @override
  State<BeverageDropdown> createState() => BeverageDropdownState();
}

class BeverageDropdownState extends State<BeverageDropdown> {
  List<Map<dynamic, dynamic>>? beverages;
  String? dropdownValue;
  num? selectedQuantity;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Load values from the beverages list in stored in the Provider to prevent too many API requests to the Database
    beverages = Provider.of<ServiceDB>(context, listen: false).dataList;
    dropdownValue = beverages![0]['type'].toString();
    Provider.of<ServiceDB>(context, listen: false).beverageChosen =
        dropdownValue;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Beverage',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          selectedQuantity = beverages!.firstWhere(
              (beverage) => beverage['type'] == dropdownValue)['quantity'];
          widget.onSelected(dropdownValue!, selectedQuantity!);
        });
      },
      items: beverages!
          .map<DropdownMenuItem<String>>((Map<dynamic, dynamic> beverage) {
        return DropdownMenuItem<String>(
          value: beverage['type'].toString(),
          child: Text(beverage['type']),
        );
      }).toList(),
    );
  }
}
