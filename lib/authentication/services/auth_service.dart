import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'O e-mail não está cadastrado.';
        case 'invalid-credential':
          return 'Senha incorreta.';
      }

      return e.code;
    }

    return null;
  }

  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      await userCredential.user!.updateDisplayName(nome);

      print("Funcionou chegamos até essa linha!");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'O e-mail já está em uso.';
      }

      return e.code;
    }

    return null;
  }
}
