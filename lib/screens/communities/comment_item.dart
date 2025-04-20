// screens/communities/comment_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:MangaLo/models/comment.dart';
import 'package:MangaLo/providers/community_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/screens/communities/create_comment_screen.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final bool isAuthor;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isAuthor,
    this.isReply = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  List<Comment> _replies = [];
  bool _loadingReplies = false;

  @override
  Widget build(BuildContext context) {
    final communityProvider = Provider.of<CommunityProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;
    final currentUserId = authProvider.firebaseUser?.uid;
    final hasLiked =
        currentUserId != null && widget.comment.likes.contains(currentUserId);

    return Card(
      margin: EdgeInsets.only(
        left: widget.isReply ? 32.0 : 0.0,
        right: 0.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: widget.comment.userPhotoUrl != null
                  ? NetworkImage(widget.comment.userPhotoUrl!)
                  : null,
              child: widget.comment.userPhotoUrl == null
                  ? Text(widget.comment.username[0].toUpperCase())
                  : null,
            ),
            title: Text(
              widget.comment.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timeago.format(widget.comment.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: widget.isAuthor
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.comment.content),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    // Like button
                    InkWell(
                      onTap: isAuthenticated
                          ? () => communityProvider.toggleLike(
                                widget.comment.id,
                              )
                          : () => _showLoginPrompt(context),
                      child: Row(
                        children: [
                          Icon(
                            hasLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: hasLiked ? Colors.red : null,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.comment.likes.length.toString(),
                            style: TextStyle(
                              color: hasLiked ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Reply button (only for top-level comments)
                    if (!widget.isReply)
                      InkWell(
                        onTap: isAuthenticated
                            ? () => _navigateToReply(context)
                            : () => _showLoginPrompt(context),
                        child: Row(
                          children: [
                            const Icon(Icons.reply, size: 16),
                            const SizedBox(width: 4),
                            Text(widget.comment.replyCount.toString()),
                          ],
                        ),
                      ),
                  ],
                ),

                // Show replies button (only for top-level comments with replies)
                if (!widget.isReply && widget.comment.replyCount > 0)
                  TextButton(
                    onPressed: _loadingReplies
                        ? null
                        : () => _toggleReplies(communityProvider),
                    child: _loadingReplies
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _showReplies
                                ? 'Hide replies'
                                : 'Show ${widget.comment.replyCount} replies',
                          ),
                  ),

                // Replies
                if (_showReplies && _replies.isNotEmpty)
                  Column(
                    children: _replies.map((reply) {
                      return CommentItem(
                        comment: reply,
                        isAuthor: currentUserId == reply.userId,
                        isReply: true,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleReplies(CommunityProvider provider) async {
    if (_showReplies) {
      setState(() {
        _showReplies = false;
      });
    } else {
      setState(() {
        _loadingReplies = true;
      });

      final replies = await provider.fetchReplies(widget.comment.id);

      setState(() {
        _replies = replies;
        _showReplies = true;
        _loadingReplies = false;
      });
    }
  }

  void _navigateToReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCommentScreen(
          parentId: widget.comment.id,
          parentUsername: widget.comment.username,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text(
          'Are you sure you want to delete this comment?',
        ),
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
              Provider.of<CommunityProvider>(
                context,
                listen: false,
              ).deleteComment(widget.comment.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'You need to sign in to interact with comments.',
        ),
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
