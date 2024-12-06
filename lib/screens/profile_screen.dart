import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_application_development_cw1b/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../service/auth.dart';
import '../widgets/profile_field.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  Future<void> _editField({
    required String fieldName,
    required String currentValue,
    required String userId,
    bool isPassword = false,
  }) async {
    TextEditingController controller =
        TextEditingController(text: isPassword ? '' : currentValue);

    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
              border: const OutlineInputBorder(),
            ),
            obscureText: isPassword,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newValue == null || newValue.isEmpty) {
      return;
    }

    try {
      String? currentPassword;

      if (fieldName == 'email' || fieldName == 'password') {
        currentPassword = await _getCurrentPassword(context);
      }

      if (fieldName == 'username') {
        await _authService.updateUserName(newValue);
      } else if (fieldName == 'email' && currentPassword != null) {
        await _authService.updateEmail(newValue,
            context: context, currentPassword: currentPassword);
      } else if (fieldName == 'password' && currentPassword != null) {
        await _authService.updatePassword(newValue,
            currentPassword: currentPassword);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fieldName updated successfully!')),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $fieldName: $e')),
      );
    }
  }

  Future<String?> _getCurrentPassword(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your current password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Current Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  userData['username'] ?? 'No Name',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ProfileField(
                  icon: Icons.person,
                  value: userData['username'] ?? 'No Name',
                  onTap: () => _editField(
                    fieldName: 'username',
                    currentValue: userData['username'] ?? '',
                    userId: userId,
                  ),
                ),
                /* ProfileField(
                  icon: Icons.email,
                  value: userData['email'] ?? 'No Email',
                  onTap: () => _editField(
                    fieldName: 'email',
                    currentValue: userData['email'] ?? '',
                    userId: userId,
                  ),
                ),*/
                ProfileField(
                  icon: Icons.lock,
                  value: '********',
                  onTap: () => _editField(
                    fieldName: 'password',
                    currentValue: '',
                    userId: userId,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await AuthService().clearUserCredentials();
                    await AuthService().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
