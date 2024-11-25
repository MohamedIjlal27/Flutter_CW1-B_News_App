import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_news_app/widgets/profile_field.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
            return const Center(child: Text('User not found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Edit Icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['profileImage'] ??
                          'https://via.placeholder.com/150'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Username
                Text(
                  userData['username'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Editable Profile Fields
                ProfileField(
                  icon: Icons.person,
                  value: userData['username'] ?? 'No Name',
                  onTap: () {
                    // Navigate to edit username screen
                  },
                ),
                ProfileField(
                  icon: Icons.email,
                  value: userData['email'] ?? 'No Email',
                  onTap: () {
                    // Navigate to edit email screen
                  },
                ),
                ProfileField(
                  icon: Icons.lock,
                  value: '********',
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                ProfileField(
                  icon: Icons.location_on,
                  value: userData['location'] ?? 'No Location',
                  onTap: () {
                    // Navigate to edit location screen
                  },
                ),

                const SizedBox(height: 8),

                // Support Section
                ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: const Text('Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to support screen
                  },
                ),
                const Divider(),

                // Logout Button
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Handle logout functionality
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
