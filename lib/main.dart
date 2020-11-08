import 'package:flutter/material.dart';
import 'package:shopper/pages/cart_page.dart';
import 'package:shopper/pages/home_page.dart';

main() => runApp(ShoppyApp());

class ShoppyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> primarySwatch = {
      50: Color(0xfff3e0),
      100: Color(0xffe0b2),
      200: Color(0xffcc80),
      300: Color(0xffb74d),
      400: Color(0xffa726),
      500: Color(0xff9800),
      600: Color(0xfb8c00),
      700: Color(0xf57c00),
      800: Color(0xef6c00),
      900: Color(0xec5100),
    };

    Map<int, Color> primarySwatchDark = {
      50: Color(0xefebe9),
      100: Color(0xd7ccc8),
      200: Color(0xbcaaa4),
      300: Color(0xa1887f),
      400: Color(0x8d6e63),
      500: Color(0x795548),
      600: Color(0x6d4c41),
      700: Color(0x5d4037),
      800: Color(0x4e342e),
      900: Color(0x3e2723),
    };
    return MaterialApp(
      //home: HomePage(),
      title: "Shoppy",
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.red,//MaterialColor(0xFFff9800, primarySwatch),
        primaryColor: Colors.red,
        accentColor: Colors.indigoAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
      darkTheme: ThemeData(
        primarySwatch: MaterialColor(0xFF795548, primarySwatchDark),
        primaryColor: Colors.red,
        accentColor: Colors.orangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
      initialRoute: "/",
      routes: {
        "/" : (BuildContext context) => HomePage(),
        "/cart": (BuildContext context) => CartPage(),
      },
    );
  }
}
