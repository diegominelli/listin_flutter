import 'package:flutter/material.dart';
import 'package:listin/_core/my_colors.dart';
import 'package:listin/authentication/component/show_snackbar.dart';
import 'package:listin/authentication/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool isEntrando = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      "https://github.com/ricarthlima/listin_assetws/raw/main/logo-icon.png",
                      height: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isEntrando)
                            ? "Bem vindo ao Listin!"
                            : "Vamos começar?",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      (isEntrando)
                          ? "Faça login para criar sua lista de compras."
                          : "Faça seu cadastro para começar a criar sua lista de compras com Listin.",
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("E-mail")),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text("Senha")),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: isEntrando,
                      child: TextButton(
                        onPressed: () {
                          esqueciMinhaSenhaClicado();
                        },
                        child: Text("Esqueci minha senha."),
                      ),
                    ),
                    Visibility(
                      visible: !isEntrando,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _confirmaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text("Confirme a senha"),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 4) {
                                return "Insira uma confirmação de senha válida.";
                              }
                              if (value != _senhaController.text) {
                                return "As senhas devem ser iguais.";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              label: Text("Nome"),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Insira um nome maior.";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoEnviarClicado();
                      },
                      child: Text((isEntrando) ? "Entrar" : "Cadastrar"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEntrando = !isEntrando;
                        });
                      },
                      child: Text(
                        (isEntrando)
                            ? "Ainda não tem conta?\nClique aqui para cadastrar."
                            : "Já tem uma conta?\nClique aqui para entrar",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MyColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(email: email, senha: senha);
      } else {
        _criarUsuario(email: email, senha: senha, nome: nome);
      }
    }
  }

  _entrarUsuario({required String email, required String senha}) {
    authService.entrarUsuario(email: email, senha: senha).then((String? erro) {
      if (erro != null) {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  _criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) {
    authService.cadastrarUsuario(email: email, senha: senha, nome: nome).then((
      String? erro,
    ) {
      if (erro != null) {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  esqueciMinhaSenhaClicado() {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefinicaoSenhaController =
            TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme um e-mail para redefinição de senha."),
          content: TextFormField(
            controller: redefinicaoSenhaController,
            decoration: InputDecoration(label: Text("Confirme o e-mail")),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                authService
                    .redefinicaoSenha(email: redefinicaoSenhaController.text)
                    .then((String? erro) {
                      if (erro == null) {
                        showSnackBar(
                          context: context,
                          mensagem:
                              "E-mail de redefinição de senha enviado com sucesso!",
                          isErro: false,
                        );
                      } else {
                        showSnackBar(context: context, mensagem: erro);
                      }
                      Navigator.pop(context);
                    });
              },
              child: Text("Redefinir senha"),
            ),
          ],
        );
      },
    );
  }
}
