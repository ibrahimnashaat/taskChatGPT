import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/layout/home.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';
import 'package:task_chatgpt_app/shared/cach_helper/shared_preferences.dart';

class Swiping {
  late final String image;
  late final String text1;
  late final String text2;
  late final String text3;
  late final String text4;



  Swiping({
    required this.image,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<Swiping> swipingScreens = [
    Swiping(
        image: 'assets/images/icon1_onboarding.png',
        text1: 'Examples',
        text2: '"Explain quantum computing in simple terms"',
        text3: '"Got any creative ideas for a 10 year old’s birthday?"',
        text4: '"How do I make an HTTP request in Javascript?"'),
    Swiping(
        image: 'assets/images/icon2_onboarding.png',
        text1: 'Capabilities',
        text2: 'Remembers what user said earlier in the conversation',
        text3: 'Allows user to provide follow-up corrections',
        text4: 'Trained to decline inappropriate requests'),
    Swiping(
        image: 'assets/images/icon3_onboarding.png',
        text1: 'Limitations',
        text2: 'May occasionally generate incorrect information',
        text3:
            'May occasionally produce harmful instructions or biased content',
        text4: 'Limited knowledge of world and events after 2021'),
  ];

  var pageController = PageController();
  bool isLast = false;

  void submit() {
    cachHelper.saveData(key: 'onBoarding', value: true).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 20.0, top: 80.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/chat_gpt_icon.png',
                  width: 6.w,
                  height: 6.h,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'ChatGPT',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Ask anything, get your answer',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.54,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      if (index == swipingScreens.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemBuilder: (context, index) =>
                        onBoarding(swipingScreens[index], index),
                    itemCount: swipingScreens.length,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: buttonAndUserChatColor),
                  child: MaterialButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        pageController.nextPage(
                            duration: const Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: isLast
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Let\'s Chat',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).iconTheme.color,
                                size: 16.0,
                              ),
                            ],
                          )
                        : Text(
                            'Next',
                            style:Theme.of(context).textTheme.displayMedium,
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onBoarding(Swiping wid, int index) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              wid.image,
              width: 6.w,
              height: 6.h,
              color: Theme.of(context).iconTheme.color,
            ),
            Text(
              wid.text1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.2)),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                wid.text2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.2)),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                wid.text3,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.2)),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                wid.text4,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.002,
                  color: index == 0 ? buttonAndUserChatColor : Theme.of(context).iconTheme.color,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.002,
                  color: index == 1 ? buttonAndUserChatColor : Theme.of(context).iconTheme.color,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.002,
                  color: index == 2 ? buttonAndUserChatColor : Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ],
        ),
      );

}
