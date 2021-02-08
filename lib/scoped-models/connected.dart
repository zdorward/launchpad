import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../models/schedule.dart';
import '../models/update.dart';
import '../models/promotion.dart';
import '../models/shift.dart';

import '../widgets/list_tiles.dart';

import '../widgets/error.dart';

mixin ConnectedModel on Model {
  List<Employee> _employees = [];

  bool rebuild = false;
  bool isLoading = false;

  Employee _loggedInUser;
  int _loggedInUserIndex;
}

mixin UserModel on ConnectedModel {
  Future<bool> addEmployee(String name, int id, String pin, bool manager) {
    final Map<String, dynamic> employeeData = {
      'name': name,
      'id': id,
      'pin': pin,
      'manager': manager,
      'requests': null,
      'logged in': false
    };
    return http
        .post('https://launchpad-9e294.firebaseio.com/employees.json',
            body: json.encode(employeeData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      _employees.add(Employee(
          key: responseData['name'],
          name: name,
          id: id,
          pin: pin,
          manager: manager,
          requests: null,
          loggedIn: false));
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> fetchEmployees() {
    notifyListeners();
    return http
        .get('https://launchpad-9e294.firebaseio.com/employees.json')
        .then((http.Response response) {
      final Map<String, dynamic> employeeListData = json.decode(response.body);
      if (employeeListData == null) {
        _employees = [];
      } else {
        List<Employee> fetchedEmployees = [];
        employeeListData.forEach((String key, dynamic employeeData) {
          if (employeeData['requests'] == null) {
            final Employee employee = Employee(
                key: key,
                name: employeeData['name'],
                id: (employeeData['id']),
                manager: employeeData['manager'],
                pin: (employeeData['pin']),
                requests: null,
                loggedIn: employeeData['logged in']);
            fetchedEmployees.add(employee);
          } else {
            final Employee employee = Employee(
                key: key,
                name: employeeData['name'],
                id: (employeeData['id']),
                manager: employeeData['manager'],
                pin: (employeeData['pin']),
                requests: employeeData['requests'],
                loggedIn: employeeData['logged in']);
            fetchedEmployees.add(employee);
          }
        });

        fetchedEmployees.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        List<Employee> newList = [];
        for (var i = 0; i < fetchedEmployees.length; i++) {
          if (fetchedEmployees[i].manager) {
            newList.add(fetchedEmployees[i]);
            fetchedEmployees.removeAt(i);
            i -= 1;
          }
        }
        for (var i = 0; i < fetchedEmployees.length; i++) {
          newList.add(fetchedEmployees[i]);
        }

        _employees = newList;
        notifyListeners();
      }
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteEmployee(int index, BuildContext context) {
    isLoading = true;
    final deletedEmployeeKey = _employees[index].key;

    if (deletedEmployeeKey == user.key) {
      Navigator.pushReplacementNamed(context, '/');
    }

    notifyListeners();
    return http
        .delete(
            'https://launchpad-9e294.firebaseio.com/employees/$deletedEmployeeKey.json')
        .then((http.Response respose) {
      _employees.removeAt(index);
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void reinsertEmployee(Employee employee, int index) {
    _employees.removeAt(index);
    _employees.insert(index, Employee.from(employee));
    notifyListeners();
  }

  List get employees {
    return List.from(_employees);
  }

  void setUser(Employee loggedInUser) {
    _loggedInUser = loggedInUser;
  }

  void changePIN(int index, newPass) {
    Employee identifiedEmployee = _employees[index];

    final Map<String, dynamic> employeeData = {
      'name': identifiedEmployee.name,
      'id': identifiedEmployee.id,
      'pin': newPass,
      'manager': identifiedEmployee.manager,
      'requests': identifiedEmployee.requests,
      'logged in': false
    };

    http.put(
        'https://launchpad-9e294.firebaseio.com/employees/${identifiedEmployee.key}.json',
        body: json.encode(employeeData));

    notifyListeners();
  }

  Future<bool> updateUser(int index) {
    isLoading = true;
    return http
        .get('https://launchpad-9e294.firebaseio.com/employees.json')
        .then((http.Response response) {
      final Map<String, dynamic> employeeListData = json.decode(response.body);
      if (employeeListData == null) {
        _employees = [];
      } else {
        List<Employee> fetchedEmployees = [];
        employeeListData.forEach((String key, dynamic employeeData) {
          if (employeeData['requests'] == null) {
            final Employee employee = Employee(
                key: key,
                name: employeeData['name'],
                id: (employeeData['id']),
                manager: employeeData['manager'],
                pin: (employeeData['pin']),
                requests: null,
                loggedIn: employeeData['logged in']);
            fetchedEmployees.add(employee);
          } else {
            final Employee employee = Employee(
                key: key,
                name: employeeData['name'],
                id: (employeeData['id']),
                manager: employeeData['manager'],
                pin: (employeeData['pin']),
                requests: employeeData['requests'],
                loggedIn: employeeData['logged in']);
            fetchedEmployees.add(employee);
          }
        });

        fetchedEmployees.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        List<Employee> newList = [];
        for (var i = 0; i < fetchedEmployees.length; i++) {
          if (fetchedEmployees[i].manager) {
            newList.add(fetchedEmployees[i]);
            fetchedEmployees.removeAt(i);
            i -= 1;
          }
        }
        for (var i = 0; i < fetchedEmployees.length; i++) {
          newList.add(fetchedEmployees[i]);
        }

        _employees = newList;

        _loggedInUser = _employees[index];
        notifyListeners();
      }
      isLoading = false;
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void setUserIndex(int index) {
    _loggedInUserIndex = index;
  }

  Employee get user {
    return _loggedInUser;
  }

  int get userIndex {
    return _loggedInUserIndex;
  }
}

mixin ScheduleModel on ConnectedModel {
  final Map<int, String> days = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  final Map<int, String> months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December'
  };

  DateTime savedDate = DateTime.now();
  DateTime temporaryDate;

  List<Schedule> _schedules = [];
  List<List<String>> _schedule = [];
  List<Widget> _widgetSchedule = [];
  List<String> _data;
  List<String> _employeeData;
  List<Update> _shiftChangeHistory = [];

  double _width;

  void setWidth(double width) {
    _width = width;
  }

  int countDay = 0;

  void setDate(DateTime dateToSave) {
    savedDate = dateToSave;
  }

  void setTemporaryDate(DateTime dateToSave) {
    temporaryDate = dateToSave;
  }

  DateTime get tempDate {
    return temporaryDate = temporaryDate.add(Duration(days: 1));
  }

  void addDay() {
    _schedule[countDay] = _employeeData;

    countDay++;
  }

  Widget container(String text, bool isGrey, double width) {
    bool smaller = false;
    if (width < 330.0) {
      smaller = true;
    }
    return Container(
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: smaller ? 7.5 : 9.0),
        ),
      ),
      color: isGrey ? Colors.white.withOpacity(0.9) : Colors.white,
    );
  }

  Future<bool> createRequest(
    String employeeName,
    DateTime date,
  ) {
    Employee otherEmployee;
    int index;

    for (var i = 0; i < _employees.length; i++) {
      if (_employees[i].name == employeeName) {
        otherEmployee = _employees[i];
        index = i;
        break;
      }
    }
    Map<String, String> addRequest = {
      'name': _loggedInUser.name,
      'date': date.toIso8601String()
    };
    if (_employees[index].requests == null) {
      _employees[index].requests = [addRequest];
    } else {
      _employees[index].requests.add(addRequest);
    }

    final Map<String, dynamic> employeeData = {
      'name': otherEmployee.name,
      'id': otherEmployee.id,
      'pin': otherEmployee.pin,
      'manager': otherEmployee.manager,
      'requests': otherEmployee.requests
    };
    return http
        .put(
            'https://launchpad-9e294.firebaseio.com/employees/${otherEmployee.key}.json',
            body: json.encode(employeeData))
        .then((http.Response response) {
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteRequest(int index) {
    isLoading = true;
    return http
        .delete(
            'https://launchpad-9e294.firebaseio.com/employees/${_loggedInUser.key}/requests/$index.json')
        .then((http.Response response) {
      _employees[_loggedInUserIndex].requests.removeAt(index);
      _loggedInUser = _employees[_loggedInUserIndex];
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> tradeShifts(
    DateTime date,
    String employeeName,
  ) {
    isLoading = true;

    String url = 'lol';
    int weekday = date.weekday;
    isLoading = true;
    notifyListeners();
    Schedule identifiedSchedule;
    int scheduleIndex;
    int otherEmployeeIndex;
    int loggedInUserIndex;

    Map<String, dynamic> updatedSchedule;

    for (var i = 0; i < _schedules.length; i++) {
      DateTime compareDate = date.subtract(Duration(days: date.weekday - 1));
      if ((compareDate.year == _schedules[i].firstDate.year) &&
          ((compareDate.month == _schedules[i].firstDate.month)) &&
          (compareDate.day == _schedules[i].firstDate.day)) {
        identifiedSchedule = _schedules[i];
        scheduleIndex = i;
      }
    }

    for (var i = 0; i < identifiedSchedule.employeeNames.length; i++) {
      if (employeeName == identifiedSchedule.employeeNames[i]) {
        otherEmployeeIndex = i;
      }
      if (_loggedInUser.name == identifiedSchedule.employeeNames[i]) {
        loggedInUserIndex = i;
      }
    }

    String temp;

    temp = identifiedSchedule.data[otherEmployeeIndex * 8 + weekday + 8];
    identifiedSchedule.data[otherEmployeeIndex * 8 + weekday + 8] =
        identifiedSchedule.data[loggedInUserIndex * 8 + weekday + 8];
    identifiedSchedule.data[loggedInUserIndex * 8 + weekday + 8] = temp;

    bool isGrey = false;
    final List<Widget> scheduleList =
        List.generate(identifiedSchedule.data.length, (index) {
      if (index % 8 == 0) {
        isGrey = !isGrey;
      }

      return container(identifiedSchedule.data[index], isGrey, _width);
    });
    _schedules[scheduleIndex].widget = scheduleList;

    updatedSchedule = {
      'data': identifiedSchedule.data,
      'first date': identifiedSchedule.firstDate.toIso8601String(),
      'last date': identifiedSchedule.lastDate.toIso8601String(),
      'employee names': identifiedSchedule.employeeNames,
    };
    url =
        'https://launchpad-9e294.firebaseio.com/schedules/${identifiedSchedule.key}.json';

    return http
        .put(url, body: json.encode(updatedSchedule))
        .then((http.Response response) {
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future addUpdate(String employeeName1, String employeeName2, String date,
      BuildContext context) {
    isLoading = true;

    fetchUpdates().then((bool success) {
      if (!success) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowErrorDialogue();
            });
      }
    });

    final Map<String, dynamic> employeeData = {
      'employeeName1': employeeName1,
      'employeeName2': employeeName2,
      'date': date,
      'seen': false,
    };

    return http
        .post('https://launchpad-9e294.firebaseio.com/updates.json',
            body: json.encode(employeeData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _shiftChangeHistory.add(Update(
        key: responseData['name'],
        employeeName1: employeeName1,
        employeeName2: employeeName2,
        date: date,
        seen: false,
      ));
      if (_shiftChangeHistory.length > 50) {
        String identifiedUpdateKey = _shiftChangeHistory[0].key;
        http.delete(
            'https://launchpad-9e294.firebaseio.com/updates/$identifiedUpdateKey.json');
        _shiftChangeHistory = _shiftChangeHistory.sublist(1);
      }
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void updateUpdates(int index) {
    Update identifiedUpdate = _shiftChangeHistory[index];
    Map<String, dynamic> updatedUpdate;
    updatedUpdate = {
      'employeeName1': identifiedUpdate.employeeName1,
      'employeeName2': identifiedUpdate.employeeName2,
      'date': identifiedUpdate.date,
      'seen': true,
    };
    http.put(
        'https://launchpad-9e294.firebaseio.com/updates/${identifiedUpdate.key}.json',
        body: json.encode(updatedUpdate));
    _shiftChangeHistory[index].seen = true;
    notifyListeners();
  }

  Future<bool> fetchUpdates() {
    isLoading = true;
    return http
        .get('https://launchpad-9e294.firebaseio.com/updates.json')
        .then((http.Response response) {
      final Map<String, dynamic> updateListData = json.decode(response.body);
      if (updateListData == null) {
        _shiftChangeHistory = [];
      } else {
        List<Update> fetchedUpdates = [];
        updateListData.forEach((String key, dynamic updateData) {
          final Update update = Update(
            key: key,
            employeeName1: updateData['employeeName1'],
            employeeName2: (updateData['employeeName2']),
            date: updateData['date'],
            seen: (updateData['seen']),
          );
          fetchedUpdates.add(update);
        });
        _shiftChangeHistory = fetchedUpdates;
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  List get shiftChangeHistory {
    return _shiftChangeHistory;
  }

  void resetSchedule() {
    _schedule = [];
  }

  List get schedule {
    return (_schedule);
  }

  List get widgetSchedule {
    return _widgetSchedule;
  }

  List get data {
    return _data;
  }

  List get allSchedules {
    return _schedules;
  }

  List get employeeData {
    return _employeeData;
  }

  Future<bool> addSchedule() async {
    isLoading = true;
    notifyListeners();
    List<String> employeeNames = [];
    for (var i = 0; i < _employees.length; i++) {
      employeeNames.add(_employees[i].name);
    }

    final Map<String, dynamic> scheduleData = {
      'data': data,
      'first date': savedDate.toIso8601String(),
      'last date': tempDate.subtract(Duration(days: 1)).toIso8601String(),
      'employee names': employeeNames
    };
    try {
      final http.Response response = await http.post(
          'https://launchpad-9e294.firebaseio.com/schedules.json',
          body: json.encode(scheduleData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      _schedules.add(
        Schedule(
          key: responseData['name'],
          data: data,
          widget: widgetSchedule,
          firstDate: savedDate,
          lastDate: tempDate.subtract(Duration(days: 1)),
          employeeNames: employeeNames,
        ),
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchSchedules() {
    isLoading = true;
    notifyListeners();
    return http
        .get('https://launchpad-9e294.firebaseio.com/schedules.json')
        .then((http.Response response) {
      isLoading = false;
      notifyListeners();
      final Map<String, dynamic> scheduleListData = json.decode(response.body);
      if (scheduleListData == null) {
        _schedules = [];
      } else {
        List<Schedule> fetchedSchedules = [];
        scheduleListData.forEach((String key, dynamic scheduleData) {
          List<dynamic> data = scheduleData['data'];
          DateTime fd = DateTime.parse(scheduleData['first date']);
          DateTime ld = DateTime.parse(scheduleData['last date']);
          List<dynamic> en = scheduleData['employee names'];

          bool isGrey = false;
          final List<Widget> scheduleList =
              List.generate(scheduleData['data'].length, (index) {
            if (index % 8 == 0) {
              isGrey = !isGrey;
            }
            return container(scheduleData['data'][index], isGrey, _width);
          });
          final Schedule schedule = Schedule(
              key: key,
              data: data,
              firstDate: fd,
              lastDate: ld,
              employeeNames: en,
              widget: scheduleList);
          fetchedSchedules.add(schedule);
        });
        _schedules = fetchedSchedules;
        notifyListeners();
      }
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteSchedule(int index) {
    isLoading = true;
    final deletedScheduleID = _schedules[index].key;

    notifyListeners();
    return http
        .delete(
            'https://launchpad-9e294.firebaseio.com/schedules/$deletedScheduleID.json')
        .then((http.Response respose) {
      allSchedules.removeAt(index);
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void reinsertSchedule(Schedule schedule, int index) {
    _schedules.removeAt(index);
    _schedules.insert(index, Schedule.from(schedule));
    notifyListeners();
  }

  void setWidgetSchedule(List<Widget> schedule) {
    _widgetSchedule = schedule;
  }

  void setData(List<String> data) {
    _data = data;
  }

  void setEmployeeData(List<String> data) {
    _employeeData = data;
  }

  String findShift(String name, DateTime date) {
    Schedule identifiedSchedule;
    int employeeIndex;
    String shift;

    for (var i = 0; i < _schedules.length; i++) {
      DateTime compareDate = date.subtract(Duration(days: date.weekday - 1));
      if ((compareDate.year == _schedules[i].firstDate.year) &&
          ((compareDate.month == _schedules[i].firstDate.month)) &&
          (compareDate.day == _schedules[i].firstDate.day)) {
        identifiedSchedule = _schedules[i];
      }
    }
    if (identifiedSchedule == null) {
      return 'null';
    }
    for (var i = 0; i < identifiedSchedule.employeeNames.length; i++) {
      if (name == identifiedSchedule.employeeNames[i]) {
        employeeIndex = i;
      }
    }

    shift = identifiedSchedule.data[employeeIndex * 8 + date.weekday + 8];
    return shift;
  }
}

mixin PromotionsModel on ConnectedModel {
  List<Promotion> _promotions = [];

  List get promotions {
    return _promotions;
  }

  Future<bool> addPromotion(String name, String description) {
    isLoading = true;
    final Map<String, dynamic> promotionData = {
      'name': name.trim(),
      'description': description,
    };
    return http
        .post('https://launchpad-9e294.firebaseio.com/promotions.json',
            body: json.encode(promotionData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _promotions.add(Promotion(
          key: responseData['name'], name: name, description: description));
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> fetchPromotions() {
    isLoading = true;
    return http
        .get('https://launchpad-9e294.firebaseio.com/promotions.json')
        .then((http.Response response) {
      final Map<String, dynamic> promotionListData = json.decode(response.body);
      if (promotionListData == null) {
        _promotions = [];
      } else {
        List<Promotion> fetchedPromotions = [];
        promotionListData.forEach((String key, dynamic promotionData) {
          final Promotion promotion = Promotion(
            key: key,
            name: promotionData['name'],
            description: promotionData['description'],
          );
          fetchedPromotions.add(promotion);
        });

        _promotions = fetchedPromotions;
        notifyListeners();
      }
      notifyListeners();
      isLoading = false;
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void reinsertPromotion(Promotion promotion, int index) {
    _promotions.removeAt(index);
    _promotions.insert(index, Promotion.from(promotion));
    notifyListeners();
  }

  Future<bool> deletePromotion(
    int index,
  ) {
    isLoading = true;
    final deletedPromotionKey = _promotions[index].key;

    return http
        .delete(
            'https://launchpad-9e294.firebaseio.com/promotions/$deletedPromotionKey.json')
        .then((http.Response respose) {
      _promotions.removeAt(index);
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

mixin ShiftModel on ConnectedModel {
  List<Shift> _shiftPool = [];

  List get shiftPool {
    return _shiftPool;
  }

  Future<bool> addShift(String name, DateTime date, String shift) {
    isLoading = true;
    final Map<String, dynamic> shiftData = {
      'name': name,
      'date': date.toIso8601String(),
      'shift': shift
    };
    return http
        .post('https://launchpad-9e294.firebaseio.com/shifts.json',
            body: json.encode(shiftData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _shiftPool.add(
        Shift(
            key: responseData['name'],
            employeeName: name,
            date: date,
            shift: shift),
      );
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> fetchShifts() {
    isLoading = true;
    notifyListeners();
    return http
        .get('https://launchpad-9e294.firebaseio.com/shifts.json')
        .then((http.Response response) {
      final Map<String, dynamic> shiftListData = json.decode(response.body);
      if (shiftListData == null) {
        _shiftPool = [];
      } else {
        List<Shift> fetchedShifts = [];
        shiftListData.forEach((String key, dynamic shiftData) {
          final Shift shift = Shift(
              key: key,
              employeeName: shiftData['name'],
              date: DateTime.parse(shiftData['date']),
              shift: shiftData['shift']);
          fetchedShifts.add(shift);
        });
        _shiftPool = fetchedShifts;
      }
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteShift(String name, DateTime date) {
    isLoading = true;
    int index = -1;
    for (int i = 0; i < _shiftPool.length; i++) {
      if (name == _shiftPool[i].employeeName && date == _shiftPool[i].date) {
        index = i;
      }
    }

    final deletedShiftKey = _shiftPool[index].key;

    return http
        .delete(
            'https://launchpad-9e294.firebaseio.com/shifts/$deletedShiftKey.json')
        .then((http.Response respose) {
      _shiftPool.removeAt(index);
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }
}
mixin ListTileModel on ConnectedModel {
  List<Widget> get listTiles {
    if (_loggedInUser.manager) {
      return [
        AppBar(
          title: Text('Menu'),
        ),
        //AnnouncementsPageListTile(),
        ScheduleListTile(),
        RequestShiftChangeListTile(),
        ShiftPoolListTile(),
        CreateScheduleListTile(),
        ManagerConsoleListTile(),
        PromotionsListTile(),
        AccountListTile(),
      ];
    } else {
      return [
        AppBar(
          title: Text('Menu'),
        ),
        //AnnouncementsPageListTile(),
        ScheduleListTile(),
        RequestShiftChangeListTile(),
        ShiftPoolListTile(),
        PromotionsListTile(),
        AccountListTile()
      ];
    }
  }
}
