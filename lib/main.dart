import 'package:adjust_sdk/adjust.dart';
import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/firebase/firebase_messaging_service.dart';
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/firebase_options.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/screens/splash/splash_screen.dart';
import 'package:ask_qx/firebase/firebase_dynamic_link.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:ask_qx/services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'adjust/adjust_services.dart';
import 'services/theme.dart';
import 'themes/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await MethodChannelService.instance.buildFlavor().then((value) async {

    ApiClient.client.init();

    await GetStorage.init("qxlabai_onboarding");

    await GetStorage.init("qxlabai").then((s) {
      AppStorage.setBuildFlavor(value);
    });

    await Firebase.initializeApp(
      name: "qxlabai",
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((_) async {
      await initServices();
      runApp(const MainApp());
    });
  });

}

Future<void> initServices() async {

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  if(kReleaseMode && !AppStorage.isDevBuild()) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  await RemoteConfigService.instance.init();

  await FirebaseDynamicLinkService.link.init();

  await FirebaseAnalyticService.instance.init();

  await NotificationService.service.init();

  await FirebaseMessageService.instance.receiveMessage();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver{
  var isFirstTime = true.obs;
  final _connectivity = Connectivity();

  @override
  void initState() {
    _checkConnectivity();
    RemoteConfigService.instance.fetchAndUpdate();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 3),(){
      AdjustServices.instance.init(); // <-- Initialise SDK in here.
    });
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GetMaterialApp(
        // getPages: MyRoutes.appRoutes(),
        // initialRoute: MyRoutes.init,
        themeMode: ThemeService().theme,

        debugShowCheckedModeBanner: false,

        defaultTransition: Transition.fade,
        //  initialBinding: RootBinding(),

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFEFBFF),
          colorScheme: lightColorScheme,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          brightness: Brightness.dark
        ),
        home: const SplashScreen(),
      ),
    );
  }

  void _checkConnectivity() async {
    final state = await _connectivity.checkConnectivity();
    initialConnectivityResult = state;
    if (state == ConnectivityResult.none) {
      ErrorHandle.error(AppDataProvider.connectionError);
    }

    _connectivity.onConnectivityChanged.listen((result) {
      debugPrint("$result");
      if (!isFirstTime.value) {
        switch (result) {
          case ConnectivityResult.none:
            ErrorHandle.error(AppDataProvider.connectionError);
            break;
          case ConnectivityResult.mobile:
          case ConnectivityResult.wifi:
            ErrorHandle.success("Back online");
            break;
          default:
        }
      } else {
        isFirstTime(false);
      }
    });
  }
}

ConnectivityResult initialConnectivityResult = ConnectivityResult.none;
