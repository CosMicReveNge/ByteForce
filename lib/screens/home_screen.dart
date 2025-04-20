import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/providers/manga_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/screens/manga_detail_screen.dart';
import 'package:MangaLo/screens/profile/user_profile_screen.dart';
import 'package:MangaLo/widgets/manga_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<MangaProvider>(context, listen: false).initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mangaProvider = Provider.of<MangaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          _buildUserAvatar(authProvider),
        ],
      ),
      body: mangaProvider.recentlyRead.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(mangaProvider),
    );
  }

  Widget _buildContent(MangaProvider provider) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSectionHeader('Recently Read'),
          _buildHorizontalMangaList(provider.recentlyRead),
          _buildSectionHeader('Newly Added'),
          _buildHorizontalMangaList(provider.newlyAdded),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildHorizontalMangaList(List<MangaModel> mangaList) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          itemCount: mangaList.length,
          itemBuilder: (context, index) {
            final manga = mangaList[index];
            return MangaCard(
              manga: manga,
              onTap: () => _navigateToDetail(context, manga),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AuthProvider authProvider) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfileScreen(),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          backgroundImage: authProvider.user?.photoUrl != null
              ? NetworkImage(authProvider.user!.photoUrl!)
              : null,
          child: authProvider.user?.photoUrl == null
              ? Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, MangaModel manga) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MangaDetailScreen(manga: manga),
      ),
    );
  }
}
