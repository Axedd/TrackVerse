import 'package:flutter/material.dart';

class BeverageCard extends StatefulWidget {
  final String selectedBeverage;
  final num? selectedQuantity;
  final String? imageUrl;
  final bool isChangeAble;
  final int? beverageColor;

  const BeverageCard(
      {super.key,
      required this.selectedBeverage,
      required this.selectedQuantity,
      required this.imageUrl,
      required this.isChangeAble, required this.beverageColor});

  @override
  State<BeverageCard> createState() => _BeverageCardState();
}

class _BeverageCardState extends State<BeverageCard> {
  int beverageColor = 0xff92b6f0;
  var cardColors = {'Monster OG': 0xff6acd0c, 'Fanta': 0xffff5f17};

  @override
  Widget build(BuildContext context) {
    // Check for special color for beverage if null then use default color
    if (widget.beverageColor != null) {
      beverageColor = widget.beverageColor!;
    } else {
      beverageColor = 0xff92b6f0;
    }

    return Container(
      width: double.infinity,
      child: Card(
        color: Color(beverageColor),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                mainAxisAlignment: MainAxisAlignment.start, // Align to the start horizontally
                children: [
                  Container(
                    height: 100, // Set the desired height
                    width: 100, // Set the desired width
                    color: const Color.fromARGB(0, 144, 202, 249), // Optional: add a background color
                    child: Image.network(
                      widget.imageUrl ?? '',
                      fit: BoxFit.contain, // Fit the image within the specified dimensions
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
                      // If image == '' then add an alternative to display (Perhaps the initial of the beverage)
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
                  Container(
                    height: 70,
                    child: VerticalDivider(color: Colors.black),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Beverage:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text(widget.selectedBeverage),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("Amount:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text("${widget.selectedQuantity.toString()} L"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.isChangeAble)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(Icons.settings),
                ),
            ],
          ),
        ),
      ),
    );
  }
}