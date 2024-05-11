
import 'main_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_chatgpt_app/shared/cach_helper/shared_preferences.dart';

class ChatCubit extends Cubit<ChatStatus> {
  ChatCubit() : super(ChatInitialStates());



  static ChatCubit get(context) => BlocProvider.of(context);


  bool isDark = cachHelper.getBoolean(key: 'isDark')??false;

  void changeSocialMode({required bool formSared}) {
    if (formSared != false) {
      isDark = formSared;
      emit(ChatChangeModeState());
      print('click 2');
    } else {
      isDark = !isDark;
      cachHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(ChatChangeModeState());
        print('click 3');
        print(isDark);
      });
    }
  }

}
