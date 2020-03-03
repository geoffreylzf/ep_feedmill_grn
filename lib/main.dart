import 'package:ep_grn/notifiers/doc_po_list_notifier.dart';
import 'package:ep_grn/notifiers/user_repository_notifier.dart';
import 'package:ep_grn/pages/home/index.dart';
import 'package:ep_grn/pages/login.dart';
import 'package:ep_grn/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserRepositoryNotifier(),
          ),
          ChangeNotifierProvider(
            create: (_) => DocPoListNotifier(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eng Peng GRN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Selector<UserRepositoryNotifier, Status>(
        selector: (_, user) => user.status,
        builder: (_, status, __) {
          switch (status) {
            case Status.Initializing:
              return SplashPage();
              break;
            case Status.Authenticated:
              return HomeIndexPage();
              break;
            case Status.Unauthenticated:
              return LoginPage();
              break;
            default:
              return SplashPage();
          }
        },
      ),
    );
  }
}
