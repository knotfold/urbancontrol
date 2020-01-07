import 'package:flutter/material.dart';
import 'pages/pages.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';
import 'package:urbancontrol/shared/shared.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  final Controller controller = Controller();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      builder: (context) => controller,
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
        theme: _gcAppTheme,
        routes: {
        
        },
      ),
    );
  }
}

final ThemeData _gcAppTheme = _buildGCAppTheme();

ThemeData _buildGCAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    cardTheme: CardTheme(color: Colors.white),

    bottomAppBarTheme: BottomAppBarTheme(
      color: primaryColor

    ),

    accentIconTheme: IconThemeData(
      color: primaryColor
    ),

    primaryIconTheme: IconThemeData(
      color: primaryColor
    ),
    iconTheme: IconThemeData(
      color: primaryColor,
      size: 30,
    ),
    textTheme: TextTheme(
      body1: TextStyle(
        color: Colors.black,
        
        fontSize: 14
      ),
    ),
    primaryTextTheme: TextTheme(body1: TextStyle(color: primaryColor)),
    accentColor: primaryColor,
    primaryColor: primaryColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
     
    ),
    primaryColorDark: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textSelectionColor: primaryColor,
    errorColor: Colors.red,
    backgroundColor: Colors.white
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}