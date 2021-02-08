import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/login.dart';
import './pages/announcements.dart';
import './pages/create_account.dart';
import './pages/schedule.dart';
import './pages/manager_console.dart';
import './pages/select_week.dart';
import './pages/switch_shifts.dart';
import './pages/create_schedule.dart';
import './pages/promotions.dart';
import './pages/account.dart';
import './pages/change_pin.dart';
import './pages/pool.dart';

import './tabs/shift_log.dart';
import './tabs/personal_shift_log.dart';

import './scoped-models/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AfterSplash();
    // return SplashScreen(
    //   seconds: 4,
    //   navigateAfterSeconds: AfterSplash(),
    //   title: Text('LaunchPad Employees'),
    //   backgroundColor: Colors.white,
    //   image: Image.asset('assets/icon.png'),
    //   loaderColor: Colors.blue,
    // );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LaunchPad',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            accentColor: Colors.orange,
            buttonColor: Colors.orange),
        routes: {
          '/': (BuildContext context) => LoginPage(model),
          '/announcements': (BuildContext context) => AnnouncementsPage(),
          '/create_account': (BuildContext context) => CreateAccountPage(),
          '/schedule': (BuildContext context) => SchedulePage(model),
          '/change_shifts': (BuildContext context) => SwitchShiftsPage(model),
          '/select_day': (BuildContext context) => SelectDayPage(),
          '/create_schedule': (BuildContext context) => CreateSchedulePage(),
          '/manager_console': (BuildContext context) => ManagerConsole(model),
          '/promotions': (BuildContext context) => PromotionsPage(model),
          '/account': (BuildContext context) => AccountPage(),
          '/change_pin': (BuildContext context) => ChangePINPage(),
          '/pool': (BuildContext context) => ShiftPoolPage(model),

          '/shift_log': (BuildContext context) => ShiftLogTab(model),
          '/personal_shift_log': (BuildContext context) => PersonalShiftLogTab(model),
          
          
        },
        // onGenerateRoute: (RouteSettings settings) {
        //   final List<String> pathElements = settings.name.split('/');
        //   if (pathElements[0] != '') {
        //     return null;
        //   }
        //   if (pathElements[1] == 'schedule') {
        //     final int day = int.parse(pathElements[2]);
        //   }
        //   return MaterialPageRoute(builder: (BuildContext context) => SchedulePage(day));
        // },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(model));
        },
      ),
    );
  }
}
