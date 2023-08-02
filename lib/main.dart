import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/cubit/customer_cubit.dart';
import 'package:staff_cleaner/cubit/schedule_cubit.dart';
import 'package:staff_cleaner/cubit/staff_cubit.dart';
import 'package:staff_cleaner/screens/admin/admin_main.dart';
import 'package:staff_cleaner/screens/autentikasi/login/login_screen.dart';
import 'package:staff_cleaner/screens/staff/staff_main.dart';
import 'package:staff_cleaner/services/customer_service.dart';
import 'package:staff_cleaner/services/schedule_service.dart';
import 'package:staff_cleaner/services/staff_service.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/global_utils.dart';
import 'package:staff_cleaner/values/navigate_utils.dart';
import 'package:staff_cleaner/values/output_utils.dart';
import 'package:staff_cleaner/values/screen_utils.dart';

import 'firebase_options.dart';
import 'services/firebase_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// test

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CustomerService customerService;
  late ScheduleService scheduleService;
  late StaffService staffService;

  @override
  void initState() {
    customerService = CustomerService();
    scheduleService = ScheduleService();
    staffService = StaffService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => customerService,
        ),
        RepositoryProvider(
          create: (context) => scheduleService,
        ),
        RepositoryProvider(
          create: (context) => staffService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CustomerCubit(
              customerService: customerService,
            ),
          ),
          BlocProvider(
            create: (context) => ScheduleCubit(
              scheduleService: scheduleService,
            ),
          ),
          BlocProvider(
            create: (context) => StaffCubit(
              staffService: staffService,
            ),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: primaryColor,
            ),
            home: MainPage(),
            navigatorKey: GlobalContext.navigatorKey,
            debugShowCheckedModeBanner: false,
          );
        }),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseServices fs = FirebaseServices();

  Map<String, dynamic>? data;

  String deskripsi = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  dynamic getData() async {
    try {
      final user = fs.getUser();

      if (user == null) {
        return navigatePushAndRemove(const LoginScreen());
      }
      final res = await fs.getDataCollectionByQuery("staff", "email", user.email);
      if (res.isEmpty) {
        return navigatePushAndRemove(const AdminMain());
      }

      return navigatePushAndRemove(const StaffMain());
    } catch (e) {
      logO("e", m: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      width: 1.0.w,
      height: 1.0.h,
      // child: Center(
      //   child: TextComponent(deskripsi),
      // ),
    );
  }
}
