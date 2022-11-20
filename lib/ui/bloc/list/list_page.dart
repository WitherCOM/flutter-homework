import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/main.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  @override
  void initState() {
    super.initState();
    context.read<ListBloc>().add(ListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        actions: [
          IconButton(
            onPressed: () {
              GetIt.I<Dio>().options.headers.remove('Authorization');
              GetIt.I<SharedPreferences>().remove('token');
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is ListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ListLoaded) {
              return ListView.builder(
                itemBuilder: (context, i) {
                  return SizedBox(
                    height: 90,
                    child: Row(
                      children: [
                        Image.network(state.users[i].avatarUrl,width: 90),
                        Text(state.users[i].name)
                      ],
                    )
                  );
                },
                itemCount: state.users.length,
              );
            }
            else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
