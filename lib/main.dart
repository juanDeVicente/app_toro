import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where is my toro?',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Where is my toro?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    const listTitleIconSeparator = 25.0;
    const iconSeparator = 25.0;

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: SvgPicture.asset('assets/bull.svg',
                            width: 100,
                            height: 100,
                            color: Colors.black,
                            semanticsLabel: 'A bull'),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: iconSeparator),
                          child: const Text(
                            'Where is my toro?',
                            style: TextStyle(fontSize: 18),
                          )),
                    ]),
              ),
              ListTile(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    const Icon(
                      Icons.map,
                      color: Colors.black,
                      size: 16,
                      semanticLabel: 'Map icon to see toros',
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: listTitleIconSeparator),
                      child: const Text('Ver toros'),
                    )
                  ],
                ),
                onTap: () {},
              ),
              ListTile(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 16,
                      semanticLabel: 'Map icon to see toros',
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: listTitleIconSeparator),
                      child: const Text('Toro más cercano'),
                    )
                  ],
                ),
                onTap: () {},
              )
            ],
          ),
        ),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            )));
  }
}
