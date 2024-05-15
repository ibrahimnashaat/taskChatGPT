
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/chat_pages/new_chat.dart';
import 'package:task_chatgpt_app/chat_pages/saved_chats.dart';
import 'package:task_chatgpt_app/layout/splash_screen.dart';
import 'package:task_chatgpt_app/layout/updates_faq.dart';
import 'package:task_chatgpt_app/shared/cach_helper/shared_preferences.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';
import '../cubit/main_cubit.dart';

import '../shared/database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper _databaseHelper;
  List<Map<String, dynamic>> _chats = [];

    String newChatButtonText = 'loading...';

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;

    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      List<Map<String, dynamic>> chats = await _databaseHelper.getChats();
      setState(() {
        _chats = chats;
      });
    } catch (e) {
      print('Error loading chats: $e');
    }
  }


  String getLastUserMessage(Map<String, dynamic> messages) {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages['txt'] == 'user') {
        return messages[i]['messageText'] ;
      }
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 1.h),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        int chatId = await _databaseHelper.insertChat('New Chat');
                        _loadChats();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(chatId: chatId),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Theme.of(context).iconTheme.color,
                                size: 20,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'New Chat',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                                size: 20,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            color: Theme.of(context).iconTheme.color,
                            height: 0.3,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: ListView.builder(

                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  int chatId = _chats[index]['id'];

                  return MaterialButton(
                    onPressed: () async {
                      List<Map<String, dynamic>> messages = await _databaseHelper.getMessagesForChat(chatId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeneratedChat(chatId: chatId, databaseMessages: messages),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                              size: 20,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: FutureBuilder<Map<String, dynamic>?>(
                                future: _databaseHelper.getLastUserMessage(chatId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {

                                    return LinearProgressIndicator();
                                  } else if (snapshot.hasError) {

                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {

                                    Map<String, dynamic>? lastUserMessage = snapshot.data;
                                    if (lastUserMessage != null) {
                                      String messageText = lastUserMessage['messageText'];
                                      return Text(
                                        messageText,
                                        style: Theme.of(context).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    } else {
                                      return Text('No user messages found');
                                    }
                                  } else {
                                    return Text('');
                                  }
                                },
                              ),
                            ),

                            const Spacer(),
                            PopupMenuButton<int>(
                              itemBuilder: (context) => [

                                PopupMenuItem(
                                  value: 1,

                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline,color: Colors.red,),
                                       SizedBox(
                                         width: 4,
                                       ),
                                      Text("Delete",style: Theme.of(context).textTheme.labelMedium?.copyWith(color:Colors.red ),)
                                    ],
                                  ),
                                ),


                              ],
                              offset: Offset(0, 50),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              elevation: 2,
                              iconColor: Theme.of(context).iconTheme.color,
                              shadowColor: Colors.black,
                              onSelected: (value) {

                                if (value == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: buttonAndUserChatColor,
                                      title: Text("Confirmation",

                                        style: Theme.of(context).textTheme.labelMedium,

                                      ),
                                      content: Text("Do you want to delete this chat?",style: Theme.of(context).textTheme.bodyMedium,),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No",style: Theme.of(context).textTheme.labelLarge,),
                                        ),
                                        TextButton(
                                          onPressed: () async {


                                              _databaseHelper.deleteChat(chatId);
                                              Navigator.pop(context);
                                            _loadChats();
                                          },
                                          child: Text("Yes",style: Theme.of(context).textTheme.labelLarge,),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Theme.of(context).iconTheme.color,
                          height: 0.3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0005,
              color: Theme.of(context).iconTheme.color,
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () async {

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: buttonAndUserChatColor,
                      title: Text("Confirmation",

                        style: Theme.of(context).textTheme.labelMedium,

                      ),
                      content: Text("Do you want to delete all chats?",style: Theme.of(context).textTheme.bodyMedium,),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No",style: Theme.of(context).textTheme.labelLarge,),
                        ),
                        TextButton(
                          onPressed: () async {

                            await _databaseHelper.deleteAllChats();
                            Navigator.of(context).pop();
                            _loadChats();
                          },
                          child: Text("Yes",style: Theme.of(context).textTheme.labelLarge,),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                      size: 20,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Clear conversations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color:Theme.of(context).iconTheme.color?.withOpacity(0.6),
                        size: 20,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        'Upgrade to Plus',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.028,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: buttonAndUserChatColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {

                    setState(() {
                      ChatCubit.get(context).changeSocialMode(formSared: false);
                      print('click 1');
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.light_mode_outlined,
                        color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                        size: 20,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        'Light mode',
                        style:Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatesAndFAQ()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.update,
                        color:Theme.of(context).iconTheme.color?.withOpacity(0.6),
                        size: 20,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        'Updates & FAQ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {

                    cachHelper.saveData(key: 'onBoarding', value: false).then((value){
                      return Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()),
                              (route) => false);
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
