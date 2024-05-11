import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';
import '../shared/components/uri_component.dart';
import 'shared_elements_between_chats/chat_message.dart';
import '../shared/models/chat_model.dart';
import '../shared/database/database.dart';

class ChatPage extends StatefulWidget {
  final int chatId;

  const ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late DatabaseHelper _databaseHelper;
  late List<Map<String, dynamic>> _messagesFromDatabase;

  final TextEditingController _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = false;

    _databaseHelper = DatabaseHelper.instance;
    _messagesFromDatabase = [];
    _fetchMessagesFromDatabase();

    print(widget.chatId);
  }



  void printMessages() {
    for (var message in _messagesFromDatabase) {
      print(
          'ID: ${message['id']}, Text: ${message['messageText']}, Type: ${message['txt']}');
    }
  }






  Future<void> _fetchMessagesFromDatabase() async {
    try {
      List<Map<String, dynamic>> messages = await _databaseHelper.getMessagesForChat(widget.chatId);
      setState(() {
        _messagesFromDatabase = messages;
      });
    } catch (e) {
      print('Error fetching messages from the database: $e');
    }
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


                    _databaseHelper.insertMessage(
                      widget.chatId,
                      input,
                      'user',
                    ).then((value) => _fetchMessagesFromDatabase());






                  });




                  Future.delayed(const Duration(
                    milliseconds: 50,
                  )).then((value) => _scrollDown());


                  generateResponse(input).then((value) async {

                    setState(()  {
                      isLoading = false;
                      _messages.add(
                        ChatMessage(
                          text: value,
                          chatMessageType: ChatMessageType.bot,
                        ),
                      );


                      _databaseHelper.insertMessage(
                        widget.chatId,
                        value,
                        'bot',
                      ).then((value) => _fetchMessagesFromDatabase());


                    });


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
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut);
  }

  ListView _buildList() {
    return ListView.builder(
        itemCount: _messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var message = _messages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
        });
  }
}

