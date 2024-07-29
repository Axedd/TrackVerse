import 'package:flutter/material.dart';

class CustomModal extends StatefulWidget {
  final String title;
  final String? content; // Make content optional for image selection
  final List<String>? imageUrls; // List of image URLs
  final ValueChanged<String>? onImageSelected; // Callback for image selection
  final VoidCallback onClose;

  const CustomModal({
    Key? key,
    required this.title,
    this.content,
    this.imageUrls,
    this.onImageSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              if (widget.imageUrls != null) ...[
                // Display image grid if image URLs are provided
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust the number of columns as needed
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: widget.imageUrls!.length,
                    itemBuilder: (context, index) {
                      final imageUrl = widget.imageUrls![index];
                      return GestureDetector(
                        onTap: () {
                          if (widget.onImageSelected != null) {
                            widget.onImageSelected!(imageUrl);
                            Navigator.of(context).pop(); // Close modal after selection
                          }
                        },
                        child: Container(
                          height: 100, // Set the desired height
                          width: 100, // Set the desired width
                          color: Colors.blue[200], // Optional: add a background color
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain, // Fit the image within the specified dimensions
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else if (widget.content != null) ...[
                // Display content if provided
                Text(widget.content!),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onClose,
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}