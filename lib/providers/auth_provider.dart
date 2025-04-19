import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MangaLo/models/user.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _firebaseUser;
  UserModel? _user;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        _firebaseUser = null;
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _firebaseUser = user;
        await _fetchUserData();
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final doc =
          await _firestore.collection('users').doc(_firebaseUser!.uid).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        username: username,
        photoUrl: null,
        favorites: [],
        readingProgress: {},
        preferences: {
          'theme': 'system',
          'readingDirection': 'leftToRight',
          'showUnreadOnly': false,
          'downloadOnWifiOnly': true,
        },
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());

      _user = user;
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _handleAuthError(e);
    }
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Update last login time
      if (_firebaseUser != null) {
        await _firestore.collection('users').doc(_firebaseUser!.uid).update({
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
      }

      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _handleAuthError(e);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _status = AuthStatus.unauthenticated;
      _user = null;
      _firebaseUser = null;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _handleAuthError(e);
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _handleAuthError(e);
    }
    notifyListeners();
  }

  Future<void> updateUserProfile({String? username, String? photoUrl}) async {
    try {
      if (_user == null) return;

      final updatedUser = _user!.copyWith(
        username: username,
        photoUrl: photoUrl,
      );

      await _firestore.collection('users').doc(_user!.id).update({
        if (username != null) 'username': username,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });

      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      if (_user == null) return;

      final updatedPreferences = {..._user!.preferences, ...preferences};

      final updatedUser = _user!.copyWith(preferences: updatedPreferences);

      await _firestore.collection('users').doc(_user!.id).update({
        'preferences': updatedPreferences,
      });

      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating user preferences: $e');
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The email address is already in use.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return error.message ?? 'An unknown error occurred.';
      }
    }
    return 'An unknown error occurred.';
  }
}
