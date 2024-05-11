import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/layout/home.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';
import 'package:task_chatgpt_app/shared/cach_helper/shared_preferences.dart';
import 'package:task_chatgpt_app/layout/splash_screen.dart';
import 'package:task_chatgpt_app/shared/styles/dark_light.dart';
import 'cubit/main_cubit.dart';
import 'cubit/main_states.dart';
import 'layout/on_boarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cachHelper.init();

  Widget widget;
  var onBoarding = await cachHelper.getData(key: 'onBoarding');

  if (onBoarding == true) {
    widget = const HomePage();
  } else {
    widget = const OnBoarding();
  }



  runApp(MyApp(
    startWidget: widget,

  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;


  const MyApp({
    Key? key,
    required this.startWidget,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
      ],
      child: BlocBuilder<ChatCubit, ChatStatus>(
        builder: (context, state) {
          return Sizer(
            builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: homePageColor,
              ));

              return MaterialApp(

                theme: ChatCubit.get(context).isDark ?  Styles.lightTheme(context) : Styles.darkTheme(context),
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  '/home': (context) => startWidget,
                },
              );
            },
          );
        },
      ),
    );
  }
}
