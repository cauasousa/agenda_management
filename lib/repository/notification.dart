import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:Agenda_Management/model/events.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPP {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late List<PendingNotificationRequest> _pendingNotificationRequests;
  
  initizalize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        
      },
    );

    final bool result = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        false;

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<int> _addNotification(
      {required String title, required DateTime day}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "ic_launcher",
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tzdata.initializeTimeZones();
    
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    
    tz.Location location = tz.getLocation(timeZoneName);

   

    tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(day, location);
    scheduledTZTime.add(Duration(hours: 8));

    _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
      _pendingNotificationRequests.length + 1,
      title,
      'Você possui compromisso agendado!!',
      scheduledTZTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    )
        .onError((error, stackTrace) {
      print("ERRROOO em adicionar a notiffication -> ${error}");
    }).then((value) {
      print("Notificação agendada, every okay !");
    });

    _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return _pendingNotificationRequests.length + 1;
  }

  deletNotification(int id) async {
     _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    
    await _flutterLocalNotificationsPlugin.cancel(id);

    _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  agendarNotification({required List<Map<DateTime, List<Event>>> todos}) async {
    _pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    _pendingNotificationRequests.forEach((element) async {
      await _flutterLocalNotificationsPlugin.cancel(element.id);
    });

    DateTime today = DateTime.now();

    int cont = 0;

    for (var element in todos) {
      if (cont >= 45) {
        break;
      }

      element.forEach((key, value) {
        for (var event in value) {
          if (event.date.isBefore(today)) {
            if (cont < 45) {
              _addNotification(title: event.title, day: event.date);
              cont++;
            } else {
              break;
            }
          }
        }
      });
    }

    await _flutterLocalNotificationsPlugin
        .pendingNotificationRequests()
        .then((value) {
      _pendingNotificationRequests = value;
    });
  }
}
