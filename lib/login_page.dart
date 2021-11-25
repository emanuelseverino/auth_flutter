import 'dart:convert';

import 'package:auth_teste/cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool visivelSenha = true;

  void verSenha (){
    setState(() {
      visivelSenha = !visivelSenha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Crie sua conta agora', style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const  InputDecoration(
                    label: Text('e-mail'),
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu e-mail';
                    }else if(!RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)){
                      return 'Digite um e-mail válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: visivelSenha,
                  controller: _senhaController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    label: const Text('senha'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(visivelSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () {
                        verSenha();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0)),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Esqueceu a senha?',
                        style: TextStyle(fontSize: 12),
                      ),
                    )),
                OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool logou = await fazerLogin();
                      if(logou){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage(),), (route) => false);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao fazer login')),
                        );
                      }
                    }
                  },
                  child: const  Text('Entrar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPage(),),);
                  },
                  child: const  Text('Não tem conta? Cadastre-se!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> fazerLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('https://google.com');
    Map<String, String> headers = {
      'content-type': 'application/json',
    };
    Map<String, dynamic> body = {
      'email': _emailController.text,
      'password': _senhaController.text,
    };
    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      await sharedPreferences.setString('token', 'Token ' + json.decode(response.body)['token']);
      return true;
    } else {
      return false;
    }
  }

}
