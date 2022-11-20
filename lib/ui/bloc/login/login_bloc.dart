import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/main.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if(state is LoginLoading){
        return;
      }
      final Map<String, String> loginData = {
        "email": event.email,
        "password": event.password
      };
      try {
        emit(LoginLoading());
        Map<String, String> data =
            (await GetIt.I<Dio>().post('/login', data: loginData)).data;
        final token = data['token'];
        GetIt.I<Dio>().options.headers['Authorization'] = "Bearer $token";
        if (event.rememberMe && token != null) {
          GetIt.I<SharedPreferences>().setString('token', token);
        }
        emit(LoginSuccess());
        emit(LoginForm());
      } on DioError catch (e) {
        emit(LoginError(e.response?.data['message']));
        emit(LoginForm());
      }
    });
    on<LoginAutoLoginEvent>((event, emit) {
      var storage = GetIt.I<SharedPreferences>();
      if (storage.containsKey('token')) {
        final token = storage.getString('token');
        GetIt.I<Dio>().options.headers['Authorization'] = "Bearer $token";
        emit(LoginSuccess());
      }
    });
  }
}
