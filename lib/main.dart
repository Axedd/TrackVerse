import 'dart:developer';

import 'package:app/api/logo_api.dart';
import 'package:app/widgets/card_widget.dart';
import 'package:app/widgets/drawer_widget.dart';
import 'package:app/widgets/logo_chooser_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app/widgets/dropdown_widget.dart';
import 'package:app/api/service_db_beverage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
      url: dotenv.env['DB_URL']!, anonKey: dotenv.env['KEY']!);

  final serviceDB = ServiceDB();
  await serviceDB.getData();

  final apiKey = dotenv.env['LOGO_API_KEY'] ?? '';
  final cseId = dotenv.env['CSE_ID'] ?? '';
  final logo = Logo(cseId: cseId, apiKey: apiKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceDB,
        ),
        ChangeNotifierProvider(
          create: (_) => logo,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackVerse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  late TextEditingController _controllerQuantity;
  String selectedBeverage = "None";
  num? selectedQuantity = 0.00;
  GlobalKey<BeverageDropdownState> dropdownKey =
      GlobalKey<BeverageDropdownState>();
  int choice = 0;
  String? image_url = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controllerQuantity = TextEditingController();
    selectedBeverage =
        Provider.of<ServiceDB>(context, listen: false).beverageChosen!;
    print(selectedBeverage);
    selectedQuantity =
        Provider.of<ServiceDB>(context, listen: false).beverageAmount!;
    image_url = Provider.of<ServiceDB>(context, listen: false).initialImageUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerQuantity.dispose();
    super.dispose();
  }

  void updateLogo(String type) {
    var serviceDB = Provider.of<ServiceDB>(context, listen: false);
    var dataList = serviceDB.dataList;
    print(dataList);
    print(type);
    dataList.forEach((element) {
      if (element['type'] == type) {
        image_url = element['image_url'];
      }
    });
  }

  void updateBeverage(String type, num quantity) {
    var serviceDB = Provider.of<ServiceDB>(context, listen: false);
    serviceDB.updateDataValues(type, quantity);
    updateLogo(type);
    setState(() {
      selectedBeverage = type;
      selectedQuantity = quantity;
      
    });
  }

  void changeChoice(int option) {
    setState(() {
      choice = option;
      print(Provider.of<Logo>(context, listen: false).imageUrls);
    });
  }

  void submit() async {
    if (choice == 0) {
      try {
        num newQuantity = num.parse(_controllerQuantity.text);
        updateBeverage(selectedBeverage, selectedQuantity! + newQuantity);
      } catch (error) {
        print('ERROR: $error');
      }
    } else if (choice == 1) {
      await Provider.of<Logo>(context, listen: false).fetchLogo('${_controller.text} Logo');
      _showImageSelectionModal();
      
    }
  }

  void _showImageSelectionModal() {
    var type = _controller.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: 'Select Logo',
          imageUrls: Provider.of<Logo>(context, listen: false).imageUrls,
          onImageSelected: (selectedImageUrl) { 
            print(_controllerQuantity.text);
            Provider.of<ServiceDB>(context, listen: false).addBeverage(type, num.parse(_controllerQuantity.text), selectedImageUrl);
            _controller.text = '';
            _controllerQuantity.text = '';
            setState(() {
              // Update your state or UI based on the selected image
            });
          },
          onClose: () {
            Navigator.of(context).pop(); // Close the modal
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('TrackVerse', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        
      ),
      endDrawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
      
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              choice == 0
                  ? BeverageDropdown(
                      key: dropdownKey,
                      onSelected: updateBeverage,
                    )
                  : TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter Beverage Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
              SizedBox(height: 10),
              TextField(
                controller: _controllerQuantity,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      changeChoice(0);
                    },
                    child: Text(
                      'Add Amount',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      changeChoice(1);
                    },
                    child: Text(
                      'Add Beverage',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              BeverageCard(
                selectedBeverage: selectedBeverage,
                selectedQuantity: selectedQuantity,
                imageUrl: image_url,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
