import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';

import '../../shared/models/chat_model.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget({
    Key? key,
    required this.text,
    required this.chatMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chatMessageType == ChatMessageType.bot
        ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 8,left: 8,right: 80 ),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

             Padding(
               padding: const EdgeInsets.only(bottom: 8, left: 8.0),
               child: Row(
                 children: [
                   Icon(Icons.thumb_up_outlined,
                   color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
                   ),
                   SizedBox(
                     width: 6.w,
                   ),
                   Icon(Icons.thumb_down_outlined,
                   color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
                   ),
                   SizedBox(
                     width: 10.w,
                   ),
                   GestureDetector(
                     onTap: () {
                       Clipboard.setData(ClipboardData(text: text));
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('Copied successfully'),
                         ),
                       );
                     },
                     child: Icon(Icons.copy,
                       size: 20,
                       color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
                     ),
                   ),
                   SizedBox(
                     width: 1.w,
                   ),
                   GestureDetector(
                     onTap: () {
                       Clipboard.setData(ClipboardData(text: text));
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('Copied successfully'),
                         ),
                       );
                     },
                     child: Text(
                       'Copy',
                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                         color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
          ],
        )
        : Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 100.0, right: 8),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: buttonAndUserChatColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
