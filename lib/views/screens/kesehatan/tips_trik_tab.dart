import 'package:flutter/material.dart';
import 'package:login/controllers/content_provider.dart';
import 'package:login/models/content_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';


class TipsTrikTab extends StatefulWidget {
  final ScrollController scrollController;

  const TipsTrikTab({Key? key, required this.scrollController})
      : super(key: key);

  @override
  _TipsTrikTabState createState() => _TipsTrikTabState();
}

class _TipsTrikTabState extends State<TipsTrikTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Tambahkan variable untuk menyimpan kategori yang dipilih
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ContentProvider>(context, listen: false);
      if (provider.oneContents.isEmpty && !provider.isLoading) {
        provider.fetchOneContent();
      }
      if (provider.allContents.isEmpty && !provider.isLoading) {
        provider.fetchAllContent();
      }
    });
  }

  // Method untuk mengubah kategori dan fetch data
  void _selectCategory(String? category) {
    setState(() {
      selectedCategory = category;
    });
    
    final provider = Provider.of<ContentProvider>(context, listen: false);
    if (category == null) {
      // Jika tidak ada kategori dipilih, ambil semua data
      provider.fetchAllContent();
    } else {
      // Jika ada kategori dipilih, ambil data berdasarkan kategori
      provider.fetchContentByCategory(category);
    }
  }

  Widget _buildCategoryButton(String title, String? category) {
    bool isSelected = selectedCategory == category;
    
    return Container(
      height: 32,
      child: OutlinedButton(
        onPressed: () => _selectCategory(category),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF11B3CF) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: Size(0, 32),
          side: BorderSide(
            color: isSelected ? Color(0xFF11B3CF) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

Widget _buildFeaturedVideoItem(ContentProvider provider) {
  if (provider.isLoading && provider.oneContents.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  if (provider.error.isNotEmpty) {
    return Text(
      'Gagal memuat video: ${provider.error}',
      style: const TextStyle(color: Colors.red),
    );
  }

  if (provider.oneContents.isEmpty) {
    return const SizedBox.shrink();
  }

  final content = provider.oneContents.first;

  return GestureDetector(
    onTap: () => _openArticleDetail(context, content),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail dengan play icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: content.thumbnail != null && content.thumbnail!.isNotEmpty
                    ? Image.network(
                        content.thumbnail!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: const Color(0xFF11B3CF),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 180,
                        width: double.infinity,
                        color: const Color(0xFF11B3CF),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
              ),
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.black.withOpacity(0.6),
                    size: 48,
                  ),
                ),
              ),
            ],
          ),

          // Bagian bawah putih berisi judul dan url
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  content.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // URL
                if (content.url != null && content.url!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.link, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          Uri.parse(content.url!).host,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // Article-related methods
  Future<void> _openArticleDetail(BuildContext context, Content content) async {
    if (content.url != null && content.url!.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(content.url!))) {
          await launchUrl(
            Uri.parse(content.url!),
            mode: LaunchMode.externalApplication,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka tautan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel tidak memiliki tautan')),
      );
    }
  }

  Widget _buildArticlesSection(
      BuildContext context, ContentProvider contentProvider) {
    
    if (contentProvider.isLoading && contentProvider.allContents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (contentProvider.error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'Failed to load articles: ${contentProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory == null) {
                  contentProvider.fetchAllContent();
                } else {
                  contentProvider.fetchContentByCategory(selectedCategory!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (contentProvider.allContents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            'Tidak ada konten tersedia',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contentProvider.allContents.length,
      itemBuilder: (context, index) {
        final content = contentProvider.allContents[index];
        return _buildArticleCard(
          title: content.title,
          thumbnail: content.thumbnail,
          url: content.url,
          onTap: () => _openArticleDetail(context, content),
        );
      },
    );
  }

  Widget _buildArticleCard({
    required String title,
    String? thumbnail,
    String? url,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail image - left side (video-like)
              Container(
                height: 100,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(12)),
                  color: const Color(0xFF11B3CF),
                ),
                child: Stack(
                  children: [
                    // Background image or placeholder
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12)),
                      child: thumbnail != null
                          ? Image.network(
                              thumbnail,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: const Color(0xFF11B3CF),
                                  child: const Center(),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color(0xFF11B3CF),
                              child: const Center(
                                child: Icon(
                                  Icons.article,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                    ),
                    // Play button overlay (video-like appearance)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    // Duration badge (video-like feature)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          "Tonton",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Article content - right side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (url != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.link,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  Uri.parse(url).host,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category buttons - Updated dengan parameter kategori
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCategoryButton("Semua", null), // Tombol untuk semua kategori
                  SizedBox(width: 8),
                  _buildCategoryButton("Olahraga", "exercise"),
                  SizedBox(width: 8),
                  _buildCategoryButton("Nutrisi", "nutrition"),
                  SizedBox(width: 8),
                  _buildCategoryButton("Kesehatan", "health_tips"),
                ],
              ),
            ),
          ),

          // Video Terbaru section - hanya tampil jika tidak ada kategori dipilih
          if (selectedCategory == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rekomendasi Video",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Consumer<ContentProvider>(
                    builder: (context, provider, child) {
                      return _buildFeaturedVideoItem(provider);
                    },
                  ),
                ],
              ),
            ),

          // Articles section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCategory == null 
                      ? "Semua Video" 
                      : "Video ${_getCategoryTitle(selectedCategory!)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Consumer<ContentProvider>(
                  builder: (context, contentProvider, child) {
                    return _buildArticlesSection(context, contentProvider);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk mendapatkan judul kategori
  String _getCategoryTitle(String category) {
    switch (category) {
      case 'exercise':
        return 'Olahraga';
      case 'nutrition':
        return 'Nutrisi';
      case 'health_tips':
        return 'Kesehatan';
      default:
        return category;
    }
  }
}