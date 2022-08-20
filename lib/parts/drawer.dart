import 'package:app_toro/routes/toros.dart';
import 'package:app_toro/routes/toros.distance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ToroDrawer extends StatelessWidget {
  const ToroDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconSeparator = 25.0;
    const listTitleIconSeparator = 16.0;
    const Color backgroundColor = Colors.white;

    return Drawer(
        child: Container(
      color: const Color(0xFFe6e6e6),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
                border: Border.all(color: backgroundColor),
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: ListTile(
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TorosRoute()));
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(color: backgroundColor),
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 16,
                      semanticLabel: 'Map icon to see nearest toro',
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: listTitleIconSeparator),
                      child: const Text('Toro más cercano'),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TorosDistanceRoute()));
                },
              )),
        ],
      ),
    ));
  }
}
