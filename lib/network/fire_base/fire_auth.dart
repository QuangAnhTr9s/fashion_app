import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    return user;
  }

  Future<User?> createUserWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(firstName);
    }
    return user;
    /*await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        if (value != null) {}
      });*/
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
