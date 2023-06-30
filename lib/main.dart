import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:swaminarayan_status/google_ads_controller.dart';

import 'app/routes/app_pages.dart';
import 'constants/app_module.dart';
import 'firebase_options.dart';

initFireBaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

bool isFlutterLocalNotificationInitialize = false;
final getIt = GetIt.instance;
GetStorage box = GetStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
      testDeviceIds: <String>[
        "8BE5F1E64BE609192A8C00DAD1326637",
      ],
    ),
  );
  setUp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("ab0f47df-ef21-4e81-b62d-703da55d3672");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    print(event.notification.body);
    event.complete(event.notification);
  });
  await GetStorage.init();
  Get.put(GoogleAdsController());
  FlutterNativeSplash.removeAfter(afterInit);
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Sf_pro_display',
      ),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> afterInit(_) async {
  await Future.delayed(Duration(microseconds: 1));
}
