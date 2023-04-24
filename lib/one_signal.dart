import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'is_ekleme_sayfasi.dart';

class OneSignalApi {
  static Future setupOneSignal() async {
    final String? deviceId = await PlatformDeviceId.getDeviceId;
    final String? deviceLang = await ui.window.locale.languageCode;

    OneSignal oneSignal = OneSignal.shared;

    oneSignal.promptUserForPushNotificationPermission();

    oneSignal.setAppId("");
    oneSignal.setExternalUserId(deviceId!);
    oneSignal.setLanguage(deviceLang!);
  }

  static Future<void> sendNotification(String message) async {
    String appId = '';
    String restApiKey = '';
    String url = '';
    List<String> tokens = await getTokensFromFirestore();
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $restApiKey',
    };

    var body = json.encode({
      'app_id': appId,
      'include_player_ids': tokens,
      'contents': {'en': message},
    });

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Error sending notification: ${response.body}');
    }
  }
}
