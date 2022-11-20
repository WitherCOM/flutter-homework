import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:validators/validators.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginAutoLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/list');
        }
      },
      child: Center(
        child: Container(
          width: 400,
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.green,
              borderRadius: BorderRadius.circular(16)),
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (state is LoginLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: false,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    enabled: false,
                  ),
                  Row(
                    children: [
                      const Text("Remember me"),
                      Checkbox(
                        onChanged: null,
                        value: _remember,
                      )
                    ],
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            } else {
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        labelText: 'Email', errorText: _emailError),
                    onChanged: (value) {
                      setState(() {
                        _emailError = null;
                      });
                    },
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password', errorText: _passwordError),
                    onChanged: (value) {
                      setState(() {
                        _passwordError = null;
                      });
                    },
                  ),
                  Row(
                    children: [
                      const Text("Remember me"),
                      Checkbox(
                        onChanged: (checked) {
                          if (checked != null) {
                            setState(() {
                              _remember = checked;
                            });
                          }
                        },
                        value: _remember,
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {
                        if (!isEmail(_email.text)) {
                          setState(() {
                            _emailError = 'Have to be an email address!';
                          });
                        } else {
                          setState(() {
                            _emailError = null;
                          });
                        }
                        if (!isLength(_password.text, 6)) {
                          setState(() {
                            _passwordError =
                                'Have to be at least 6 characters!';
                          });
                        } else {
                          setState(() {
                            _passwordError = null;
                          });
                        }
                        if (isEmail(_email.text) &&
                            isLength(_password.text, 6)) {
                          context.read<LoginBloc>().add(LoginSubmitEvent(
                              _email.text, _password.text, _remember));
                        }
                      },
                      child: const Text("Login"),
                    ),
                  )
                ],
              );
            }
          }),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
