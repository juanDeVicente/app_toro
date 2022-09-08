import 'package:app_toro/parts/app.bar.dart';
import 'package:app_toro/parts/drawer.dart';
import 'package:app_toro/parts/text.panel.dart';
import 'package:app_toro/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToroApp extends StatelessWidget {
  const ToroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Where is my toro?',
        theme: ThemeData(
            sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
            ),
            primarySwatch: Colors.blue,
            backgroundColor: backgroundColor),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  final double separation = 30.0;

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        backgroundColor: backgroundColor,
        body: Container(
            color: backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: separation,
                    ),
                    TextPanel(
                        headerText:
                            AppLocalizations.of(context)!.firstPanelHeader,
                        bodyText: AppLocalizations.of(context)!.firstPanelBody),
                    SizedBox(
                      height: separation,
                    ),
                    TextPanel(
                        headerText:
                            AppLocalizations.of(context)!.secondPanelHeader,
                        bodyText:
                            AppLocalizations.of(context)!.secondPanelBody),
                    SizedBox(
                      height: separation,
                    ),
                    TextPanel(
                        headerText:
                            AppLocalizations.of(context)!.thirdPanelHeader,
                        bodyText: AppLocalizations.of(context)!.thirdPanelBody),
                    SizedBox(
                      height: separation,
                    ),
                  ]),
            )));
  }
}
