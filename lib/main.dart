
import 'package:flutter/material.dart';
import 'package:meds_aid/src/providers/sign_up_model.dart';
import 'package:meds_aid/src/splashScreen.dart';
import 'package:meds_aid/src/ui/themes/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SignUpModel())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: primaryTheme,
        home: SplashScreen(),
      ),
    );
  }
}
