// screens/communities/create_comment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/community_provider.dart';

class CreateCommentScreen extends StatefulWidget {
  final String? parentId;
  final String? parentUsername;

  const CreateCommentScreen({super.key, this.parentId, this.parentUsername});

  @override
  State<CreateCommentScreen> createState() => _CreateCommentScreenState();
}

class _CreateCommentScreenState extends State<CreateCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReply = widget.parentId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isReply ? 'Reply to Comment' : 'New Comment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isReply)
                Card(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Replying to ${widget.parentUsername}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  hintText: 'Share your thoughts...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a comment';
                  }
                  if (value.trim().length < 3) {
                    return 'Comment must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(isReply ? 'Post Reply' : 'Post Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitComment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final communityProvider = Provider.of<CommunityProvider>(
        context,
        listen: false,
      );
      final success = await communityProvider.addComment(
        _contentController.text.trim(),
        parentId: widget.parentId,
      );

      if (success && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              communityProvider.errorMessage ?? 'Failed to post comment',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
