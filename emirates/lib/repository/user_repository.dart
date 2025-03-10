import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emirates/models/user_form_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('skywards_users');

  // Store user form data to Firestore with better error handling
  Future<String> storeUserData(UserFormModel userFormModel) async {
    try {
      print("Starting user registration process...");

      // First create the user authentication
      UserCredential userCredential;
      try {
        print("Attempting to create Firebase Auth user...");
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: userFormModel.email,
          password: userFormModel.password,
        );
        print(
          "Firebase Auth user created successfully: ${userCredential.user?.uid}",
        );
      } catch (authError) {
        print("Firebase Auth error: $authError");
        if (authError is FirebaseAuthException) {
          switch (authError.code) {
            case 'weak-password':
              return 'The password provided is too weak';
            case 'email-already-in-use':
              return 'An account already exists for that email';
            case 'invalid-email':
              return 'The email address is not valid';
            case 'operation-not-allowed':
              return 'Email/password accounts are not enabled. Contact support.';
            default:
              return 'Authentication error: ${authError.message}';
          }
        }
        return 'Authentication error: $authError';
      }

      // If authentication successful, store user data in Firestore
      if (userCredential.user != null) {
        try {
          // Add user ID to the data
          print("Preparing data for Firestore...");
          Map<String, dynamic> userData = userFormModel.toJson();
          userData['uid'] = userCredential.user!.uid;
          userData['createdAt'] = Timestamp.now();

          // Remove password from Firestore data for security
          userData.remove('password');

          print("Attempting to store data in Firestore...");
          // Store in Firestore
          await _usersCollection.doc(userCredential.user!.uid).set(userData);
          print("Data successfully stored in Firestore");

          return "success";
        } catch (firestoreError) {
          print("Firestore error: $firestoreError");
          // Try to clean up the created auth user since Firestore failed
          try {
            await userCredential.user?.delete();
          } catch (e) {
            print("Failed to delete auth user after Firestore error: $e");
          }
          return "Failed to store user data: $firestoreError";
        }
      } else {
        return "Failed to create user authentication: No user returned";
      }
    } catch (e) {
      print("Unexpected error in storeUserData: $e");
      return 'Unexpected error storing user data: $e';
    }
  }

  // Get user data from Firestore
  Future<UserFormModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();

      if (doc.exists) {
        return UserFormModel.fromSnap(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile data
  Future<String> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _usersCollection.doc(uid).update(data);
      return "success";
    } catch (e) {
      return "Failed to update profile: $e";
    }
  }

  // Delete user account
  Future<String> deleteUserAccount(String uid) async {
    try {
      // Delete from Firestore first
      await _usersCollection.doc(uid).delete();

      // Then delete the authentication account
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }

      return "success";
    } catch (e) {
      return "Failed to delete account: $e";
    }
  }
}
