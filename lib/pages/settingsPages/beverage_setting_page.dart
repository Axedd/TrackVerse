import 'package:app/api/service_db_beverage.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/card_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BeverageSettingPage extends StatefulWidget {
  const BeverageSettingPage({super.key});

  @override
  State<BeverageSettingPage> createState() => _BeverageSettingPageState();
}

class _BeverageSettingPageState extends State<BeverageSettingPage> {
  late List<Map<dynamic, dynamic>> beverageList;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch the data from the provider
    beverageList = Provider.of<ServiceDB>(context, listen: false).dataList;
  }

  int? getBeverageColor(String type) {
  var serviceDB = Provider.of<ServiceDB>(context, listen: false);
  var dataList = serviceDB.dataList;

  for (var element in dataList) {
    if (element['type'] == type) {
      if (element['color'] == null) {
        return null;
      } else {
        return int.parse(element['color']);
      }
    }
  }

  return null;
}
  

  void updateBeverageNow(String type, num quantity, Color beverageColor)  {
    var serviceDB = Provider.of<ServiceDB>(context, listen: false);
    serviceDB.updateBeverage(type, quantity, beverageColor);
    setState(() {
      beverageList = Provider.of<ServiceDB>(context, listen: false).dataList;
    });
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
          'TrackVerse - Beverages',
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
                return GestureDetector(
                  child: BeverageCard(
                    selectedBeverage: beverage['type'],
                    selectedQuantity: beverage['quantity'],
                    imageUrl: beverage['image_url'] ?? '',
                    isChangeAble: true,
                    beverageColor: getBeverageColor(beverage['type']),
                  ),
                  onTap: () {
                    Color currentColor = Color(0xff92b6f0); // Initial color
                    bool isEditingDetails = true; // Toggle between edit and color picker

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text(
                                "Settings For: ${beverage['type']}",
                                style: TextStyle(fontSize: 12),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditingDetails = true;
                                            });
                                          },
                                          child: Text("Edit Details"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditingDetails = false;
                                            });
                                          },
                                          child: Text("Pick Color"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    if (isEditingDetails)
                                      Column(
                                        children: [
                                          TextFormField(
                                            initialValue: beverage['type'],
                                            decoration: InputDecoration(
                                              labelText: 'Edit Beverage Type',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          TextFormField(
                                            initialValue: beverage['quantity'].toString(),
                                            decoration: InputDecoration(
                                              labelText: 'Edit Beverage Quantity',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          MiniBeverageCard(
                                            selectedBeverage: beverage['type'],
                                            selectedQuantity: beverage['quantity'],
                                            imageUrl: beverage['image_url'],
                                            beverageColor: currentColor,
                                          ),
                                          SizedBox(height: 16),
                                          Text("Select Card Color"),
                                          ColorPicker(
                                            pickerColor: currentColor,
                                            enableAlpha: false,
                                            onColorChanged: (color) {
                                              setState(() {
                                                currentColor = color;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    updateBeverageNow(beverage['type'], beverage['quantity'], currentColor);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MiniBeverageCard extends StatelessWidget {
  final String selectedBeverage;
  final num? selectedQuantity;
  final String? imageUrl;
  final Color beverageColor;

  const MiniBeverageCard({
    required this.selectedBeverage,
    required this.selectedQuantity,
    required this.imageUrl,
    required this.beverageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: beverageColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                color: const Color.fromARGB(0, 144, 202, 249),
                child: Image.network(
                  imageUrl ?? '',
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedBeverage,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("${selectedQuantity.toString()} L"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}