import 'package:app/api/service_db_beverage.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/card_widget.dart';
import 'package:provider/provider.dart';

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
                  ),
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Settings For: ${beverage['type']}"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
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
                              SizedBox(height: 16),
                              MiniBeverageCard(
                                selectedBeverage: beverage['type'],
                                selectedQuantity: beverage['quantity'],
                                imageUrl: beverage['image_url'],
                              ),
                            ],
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
                                // Add save functionality here
                                Navigator.of(context).pop();
                              },
                              child: Text("Save"),
                            ),
                          ],
                        );
                      },
                    )
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

  const MiniBeverageCard({
    required this.selectedBeverage,
    required this.selectedQuantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    int beverageColor = 0xff92b6f0;
    var cardColors = {'Monster OG': 0xff6acd0c, 'Fanta': 0xffff5f17};

    if (cardColors[selectedBeverage] != null) {
      beverageColor = cardColors[selectedBeverage]!;
    } else {
      beverageColor = 0xff92b6f0;
    }

    return Container(
      width: double.infinity,
      child: Card(
        color: Color(beverageColor),
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
