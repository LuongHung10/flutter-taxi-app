import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/src/app.dart';
import 'package:testflutter/src/resource/dialog/loading_dialog.dart';
import 'package:testflutter/src/resource/dialog/msg_dialog.dart';
import 'package:testflutter/src/resource/home_page.dart';
import 'package:testflutter/src/resource/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPass = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 140,
            ),
            Image.asset("assets/ic_car_green.png"),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
              child: Text(
                "Welcome back!",
                style: TextStyle(color: Color(0xff333333), fontSize: 22),
              ),
            ),
            const Text(
              "Login to continue using iCab",
              style: TextStyle(fontSize: 16, color: Color(0xff606470)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 145, 0, 20),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("assets/ic_mail.png")),
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffCED0D2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            ),
            TextField(
              controller: _passController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Container(
                      width: 50, child: Image.asset("assets/ic_phone.png")),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
            Container(
              constraints:
                  BoxConstraints.loose(const Size(double.infinity, 40)),
              alignment: AlignmentDirectional.centerEnd,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    onPressed: _onLoginClick,
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: RichText(
                text: TextSpan(
                    text: "New user? ",
                    style:
                        const TextStyle(color: Color(0xff606470), fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()));
                            },
                          text: "Sign up for a new account",
                          style: const TextStyle(
                              color: Color(0xff3277D8), fontSize: 16))
                    ]),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void _onLoginClick() {
    String email = _emailController.text;
    String pass = _passController.text;
    var authBloc = MyApp.of(context)!.authBloc;

    LoadingDialog.showLoadingDialog(context, "Loading...");

    authBloc.signIn(email, pass, () {
      // Ensure the widget is still mounted before attempting to use the context
      if (!mounted) return;
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }, (msg) {
      // Ensure the widget is still mounted before attempting to use the context
      if (!mounted) return;
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Sign-In", msg);
    });
  }
}
