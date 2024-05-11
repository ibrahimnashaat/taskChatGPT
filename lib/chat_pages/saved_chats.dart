
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';
import '../shared/components/uri_component.dart';
import 'shared_elements_between_chats/chat_message.dart';
import '../shared/models/chat_model.dart';
import '../shared/database/database.dart';


class GeneratedChat extends StatefulWidget {
  final List<Map<String, dynamic>> databaseMessages;
     final int chatId;

  const GeneratedChat({super.key, required this.databaseMessages, required this.chatId});

  @override
  State<GeneratedChat> createState() => _GeneratedChatState();
}

class _GeneratedChatState extends State<GeneratedChat> {
  final TextEditingController _textController = TextEditingController();

  final _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> _databaseMessages = [];

  late bool isLoading;

  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    isLoading = false;

    _databaseHelper = DatabaseHelper.instance;

    _loadMessagesFromDatabase();
    _fetchMessagesFromDatabase(context);
    Future.delayed(
      const Duration(milliseconds: 50),
    ).then((value) => _scrollDown());

    print(widget.databaseMessages);
    print(widget.chatId);

  }












    Future<void> _fetchMessagesFromDatabase(BuildContext context) async {
    try {
      List<Map<String, dynamic>> messages = await _databaseHelper.getMessagesForChat(widget.chatId);
      print('Messages from the database: $messages');

      setState(() {
        _databaseMessages = messages.map((message) {
          return ChatMessage(
            text: message['messageText'],
            chatMessageType: message['txt'] == 'user'
                ? ChatMessageType.user
                : ChatMessageType.bot,
          );
        }).toList();

      });


    } catch (e) {
      print('Error fetching messages from the database: $e');
    }
  }


  Future<void> _loadMessagesFromDatabase() async {
    setState(() {
      _databaseMessages = widget.databaseMessages.map((message) {
        return ChatMessage(
          text: message['messageText'],
          chatMessageType: message['txt'] == 'user'
              ? ChatMessageType.user
              : ChatMessageType.bot,
        );
      }).toList();
    });
  }



  Future<void> saveMessage(String input, ChatMessageType messageType) async {
    String type = messageType == ChatMessageType.user ? 'user' : 'bot';
     await _databaseHelper.insertMessage(
      widget.chatId,
      input,
      type,
    );


    await _loadMessagesFromDatabase();

  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                          Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            'Back',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/chat_gpt_icon.png',
                            width: 5.w,
                            height: 5.h,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.0005,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
        controller: _textController,
        decoration: InputDecoration(
          fillColor: Theme.of(context).iconTheme.color?.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          suffixIcon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: buttonAndUserChatColor,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () async {

                  var input = _textController.text;



                  setState(()  {


                    _messages.add(
                      ChatMessage(
                        text: _textController.text,
                        chatMessageType: ChatMessageType.user,
                      ),
                    );
                    isLoading = true;
                  });







                  _textController.clear();



                  await saveMessage(input, ChatMessageType.user).then((value) =>  _fetchMessagesFromDatabase(context));




                  generateResponse(input).then((value) async {

                    setState(()  {
                      isLoading = false;
                      _messages.add(
                        ChatMessage(
                          text: value,
                          chatMessageType: ChatMessageType.bot,
                        ),
                      );



                    });


                    await saveMessage(value, ChatMessageType.bot).then((value) =>  _fetchMessagesFromDatabase(context));

                       });

                  _textController.clear();
                  Future.delayed(
                    const Duration(milliseconds: 50),
                  ).then((value) => _scrollDown());
                },
                icon: Image.asset(
                  'assets/images/send_icon.png',
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.extentTotal,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut);
  }

  ListView _buildList() {
    return ListView.builder(
        itemCount: _databaseMessages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var message = _databaseMessages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
        });
  }
}