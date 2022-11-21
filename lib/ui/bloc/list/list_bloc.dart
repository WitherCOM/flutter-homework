import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/main.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>(
        (event, emit) async {
          if(state is ListLoading){
            return;
          }
          emit(ListLoading());
          try {
            List responseData = (await GetIt.I<Dio>().get('/users')).data;
            List<UserItem> users = responseData
            .map((e) => UserItem(e["name"] ?? '', e["avatarUrl"] ?? '')).cast<UserItem>().toList();
            emit(ListLoaded(users));
          }
          on DioError
          catch(e)
          {
            emit(ListError(e.response?.data['message']));
          }
        });
  }
}
