import 'package:ep_grn/notifiers/user_repository_notifier.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:ep_grn/widgets/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: LoginForm(),
        ),
        Consumer<UserRepositoryNotifier>(
          builder: (ctx, user, _) {
            return SimpleLoadingDialog(user.isLoading);
          },
        ),
      ]),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTec = TextEditingController();
  final _passwordTec = TextEditingController();

  @override
  void dispose() {
    _usernameTec.dispose();
    _passwordTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Eng Peng Feedmill GRN"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: _usernameTec,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      contentPadding: const EdgeInsets.all(16)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PasswordFormField(_passwordTec),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text('SIGN IN'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      final msg = await Provider.of<UserRepositoryNotifier>(context, listen: false)
                          .signIn(_usernameTec.text, _passwordTec.text);
                      if (msg != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleAlertDialog(
                              title: 'Sign In Error',
                              message: msg,
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final passwordTec;

  PasswordFormField(this.passwordTec);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordTec,
      obscureText: _visible,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
              icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              })),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
    );
  }
}
