import 'package:flutter/material.dart';
import 'package:s3/res/auth_service.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Form(
        key: _formKey,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var res = await context.read<AuthService>().signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                          print(res);
                        }
                      },
                      child: Text("Войти"),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
