import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/presentation/bloc/sign_in_bloc.dart';
import 'package:s3/injection_container.dart';
//import 'package:s3/res/auth_service.dart';
//import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _key, body: buildBody(context));
  }

  BlocProvider<SignInBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignInBloc>(),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset('lib/assets/man_with_axe.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'ЛенСпилДрев 2.0',
                ),
              ),
              BlocBuilder<SignInBloc, SignInState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return CircularProgressIndicator();
                  } else if (state is Error) {
                    return ErrorMessage();
                  } else {
                    return SignInForm();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TextFormField(
            controller: emailController,
            validator: (value) =>
                (value!.isEmpty) ? "Пожалуйста, введите почту" : null,
            decoration: InputDecoration(
              labelText: "Почта",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TextFormField(
            controller: passwordController,
            validator: (value) =>
                (value!.isEmpty) ? "Пожалуйста, введите пароль" : null,
            decoration: InputDecoration(
              labelText: "Пароль",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                onPressed: () => dispatchSignin(),
                child: Text("Войти"),
              )),
        ),
      ],
    ));
  }

  void dispatchSignin() async {
    BlocProvider.of<SignInBloc>(context).add(UserLogin(
      emailController.text.trim(),
      passwordController.text.trim(),
    ));
    /*  var res = await context.read<AuthService>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim()); */
  }
}

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Text("Произошла ошибка"),
    );
  }
}
