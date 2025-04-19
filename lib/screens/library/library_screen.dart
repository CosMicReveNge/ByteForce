import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/manga_provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/screens/manga_detail_screen.dart';
import 'package:MangaLo/widgets/manga_grid_item.dart';
import 'package:MangaLo/widgets/empty_library_view.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isLoading = true;
  List<Manga> _libraryManga = [];
  String _searchQuery = '';
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadLibrary();

    // Get settings
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    _showUnreadOnly = settingsProvider.showUnreadOnly;
  }

  Future<void> _loadLibrary() async {
    setState(() {
      _isLoading = true;
    });

    final mangaProvider = Provider.of<MangaProvider>(context, listen: false);
    await mangaProvider.fetchLibrary();

    setState(() {
      _libraryManga = mangaProvider.library;
      _isLoading = false;
    });
  }

  List<Manga> get _filteredManga {
    return _libraryManga.where((manga) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return manga.title.toLowerCase().contains(query) ||
            manga.author.toLowerCase().contains(query) ||
            manga.genres.any((genre) => genre.toLowerCase().contains(query));
      }

      // Apply unread filter
      if (_showUnreadOnly) {
        // TODO: Implement unread filter
        return true;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortFilterDialog();
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'categories',
                    child: Text('Categories'),
                  ),
                  const PopupMenuItem(
                    value: 'update',
                    child: Text('Update library'),
                  ),
                ],
            onSelected: (value) {
              if (value == 'categories') {
                // TODO: Implement categories
              } else if (value == 'update') {
                _loadLibrary();
              }
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _libraryManga.isEmpty
              ? const EmptyLibraryView()
              : RefreshIndicator(
                onRefresh: _loadLibrary,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _filteredManga.length,
                  itemBuilder: (context, index) {
                    final manga = _filteredManga[index];
                    return MangaGridItem(
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Library'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search by title, author, or genre',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showSortFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sort & Filter'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RadioListTile(
                  title: const Text('Title'),
                  value: 'title',
                  groupValue: 'title', // TODO: Implement sort
                  onChanged: (value) {
                    // TODO: Implement sort
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: const Text('Last read'),
                  value: 'lastRead',
                  groupValue: 'title', // TODO: Implement sort
                  onChanged: (value) {
                    // TODO: Implement sort
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: const Text('Last updated'),
                  value: 'lastUpdated',
                  groupValue: 'title', // TODO: Implement sort
                  onChanged: (value) {
                    // TODO: Implement sort
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const Text(
                  'Filter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SwitchListTile(
                  title: const Text('Unread only'),
                  value: _showUnreadOnly,
                  onChanged: (value) {
                    setState(() {
                      _showUnreadOnly = value;
                    });

                    // Save to settings
                    final settingsProvider = Provider.of<SettingsProvider>(
                      context,
                      listen: false,
                    );
                    settingsProvider.setShowUnreadOnly(value);

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
