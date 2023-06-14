import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:youtube_ecommerce/constants/theme.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_options/firebase_options.dart';
import 'package:youtube_ecommerce/provider/app_provider.dart';
import 'package:youtube_ecommerce/screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
debugProfileBuildsEnabled = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Youtube E-Commerce',
        theme: themeData,
        home: const HomeScreen(),
      ),
    );
  }
}
