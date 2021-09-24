import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  //usuario atual
  //FirebaseUSer -> User || AuthResult -> UserCredential

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  //executa quando o app é aberto
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();

  }

  void SiginUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSucess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user!;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void SignIn(
      {required String email,
      required String pass,
      required VoidCallback onSucess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners(); // atualiza as variaveis do modelo (view) como um setState()

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((authResult) async{
      firebaseUser = authResult.user;

      await _loadCurrentUser();

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }

  void SignOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();

    isLoading = false;
  }

  void recoverPass({required String email}) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //função interna coloca underlnie
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);

    print(userData);
    print("DADO SALVO NA NUVEM COM SUCESSO!");
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser;
    }
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
            await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }



}
