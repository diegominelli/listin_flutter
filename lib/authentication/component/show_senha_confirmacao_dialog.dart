import 'package:flutter/material.dart';
import 'package:listin/authentication/services/auth_service.dart';

showSenhaConfimacaoDialog({
  required BuildContext context,
  required String email,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController senhaConfirmacaoController =
          TextEditingController();
      return AlertDialog(
        title: Text("Deseja remover a conta com o e-mail $email?"),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              Text("Para confirmar a remoção da conta, digite sua senha."),
              TextFormField(
                controller: senhaConfirmacaoController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text("Senha de confirmação"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthService()
                  .removerConta(senha: senhaConfirmacaoController.text)
                  .then((String? erro) {
                    if (erro == null) {
                      Navigator.pop(context);
                    }
                  });
            },
            child: Text("EXCLUIR CONTA"),
          ),
        ],
      );
    },
  );
}
