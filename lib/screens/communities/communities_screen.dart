// screens/communities/communities_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/community_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/screens/communities/comment_item.dart';
import 'package:MangaLo/screens/communities/create_comment_screen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch comments when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommunityProvider>(context, listen: false).fetchComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final communityProvider = Provider.of<CommunityProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;

    return Scaffold(
      appBar: AppBar(title: const Text('Communities')),
      body:
          communityProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : communityProvider.comments.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: () => communityProvider.fetchComments(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: communityProvider.comments.length,
                  itemBuilder: (context, index) {
                    final comment = communityProvider.comments[index];
                    return CommentItem(
                      comment: comment,
                      isAuthor:
                          isAuthenticated &&
                          authProvider.firebaseUser?.uid == comment.userId,
                    );
                  },
                ),
              ),
      floatingActionButton:
          isAuthenticated
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateCommentScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add_comment),
              )
              : FloatingActionButton(
                onPressed: () {
                  _showLoginPrompt(context);
                },
                child: const Icon(Icons.login),
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to start a conversation!',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign In Required'),
            content: const Text('You need to sign in to post comments.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to login screen
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
    );
  }
}
