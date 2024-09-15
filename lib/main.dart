import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/db_helper.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/my_http_overrides.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/cubit/login_cubit.dart';
import 'package:taxi_driver/view/login/splash_view.dart';


SharedPreferences? prefs;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
    DBHelper.shared().db;
     SocketManager.shared.initSocket();
    
  prefs = await SharedPreferences.getInstance();
  if (Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userObj = Globs.udValue(Globs.userPayload) as Map? ?? {};
    ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;
  }
  Platform.isIOS ?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDLBlK8YqkKLxEHiysVsrZVk12JCXuLsuw',
       appId: '1:1098297880691:ios:b103045b1b24bed441fa06',
        messagingSenderId: '1098297880691', 
        projectId: 'badaa-5295d',)) :

        await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA0J4jZojt_3hS3GcKFVVOrd4_YRBoB8LE',
       appId: '1:1098297880691:android:9d3eae587ac641bb41fa06',
        messagingSenderId: '1098297880691', 
        projectId: 'badaa-5295d',));

       
 

  
  

  runApp(const MyApp());
  configLoading();
  ServiceCall.getStaticDateApi();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.white
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
    
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginCubit())],
      child: MaterialApp(
      title: 'Taxi Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NunitonSans",
        scaffoldBackgroundColor: TColor.bg,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
       useMaterial3: false,
        
          
      ),
      
      home: const SplashView(),
      builder: EasyLoading.init(),
      ),
    );
  }
}

