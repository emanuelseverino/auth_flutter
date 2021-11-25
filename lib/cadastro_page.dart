import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _senhaCController = TextEditingController();
  bool visivelSenha = true;
  bool visivelCSenha = true;

  void verSenha() {
    setState(() {
      visivelSenha = !visivelSenha;
    });
  }

  void verCSenha() {
    setState(() {
      visivelCSenha = !visivelCSenha;
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
                Text(
                  'Crie sua conta agora',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  decoration: const InputDecoration(
                    label: Text('nome completo'),
                    prefixIcon: Icon(
                      Icons.person_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('e-mail'),
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu e-mail';
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
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
                      icon: Icon(visivelSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
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
                TextFormField(
                  obscureText: visivelCSenha,
                  controller: _senhaCController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    label: const Text('confirmar senha'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(visivelCSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () {
                        verCSenha();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    } else if (value != _senhaController.text) {
                      return 'Suas senhas não conferem';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: OutlinedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool cadastro = await fazerCadastro();
                        if(cadastro){
                          Navigator.pop(context);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro ao fazer cadastro')),
                          );
                        }
                      }
                    },
                    child: const Text('Cadastrar'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Já tem conta? Faça login!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> fazerCadastro() async {
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
      return true;
    } else {
      return false;
    }
  }
}
