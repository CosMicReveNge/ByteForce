// screens/home_screen.dart (modified)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/providers/manga_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/screens/manga_detail_screen.dart';
import 'package:MangaLo/screens/profile/user_profile_screen.dart';
import 'package:MangaLo/widgets/manga_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<MangaProvider>(context, listen: false);
    await Future.wait([
      provider.fetchRecentlyRead(),
      provider.fetchNewlyAdded(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          // User profile icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.2),
                backgroundImage:
                    user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                child:
                    user?.photoUrl == null
                        ? Icon(
                          Icons.person,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadData,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Recently Read',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    _buildHorizontalMangaList(
                      context.watch<MangaProvider>().recentlyRead,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Newly Added',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    _buildHorizontalMangaList(
                      context.watch<MangaProvider>().newlyAdded,
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildHorizontalMangaList(List<Manga> mangaList) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240,
        child:
            mangaList.isEmpty
                ? const Center(child: Text('No manga found'))
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: mangaList.length,
                  itemBuilder: (context, index) {
                    final manga = mangaList[index];
                    return MangaCard(
                      manga: manga,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    MangaDetailScreen(mangaId: manga.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }
}
