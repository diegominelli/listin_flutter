import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  entrarUsuario({required String email, required String senha}) {
    print("Entrando com usuário");
  }

  cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) {
    print("Cadastrar o usuário");
  }
}
