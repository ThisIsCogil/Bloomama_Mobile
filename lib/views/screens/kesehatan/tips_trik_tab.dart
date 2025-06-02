import 'package:flutter/material.dart';
import 'package:login/controllers/content_provider.dart';
import 'package:login/models/content_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../helpers/youtube_helper.dart';

class TipsTrikTab extends StatefulWidget {
  final ScrollController scrollController;
  final String searchQuery;
  final bool isSearching;

  const TipsTrikTab({
    Key? key,
    required this.scrollController,
    this.searchQuery = '',
    this.isSearching = false,
  }) : super(key: key);

  @override
  _TipsTrikTabState createState() => _TipsTrikTabState();
}

class _TipsTrikTabState extends State<TipsTrikTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String? selectedCategory = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ContentProvider>(context, listen: false);
      if (provider.oneContents.isEmpty && !provider.isLoading) {
        provider.fetchOneContent();
      }
      provider.fetchAllContent();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Content> _filterContent(List<Content> contents) {
    if (widget.searchQuery.isEmpty) return contents;
    return contents.where((content) =>
        content.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
        (content.description?.toLowerCase().contains(widget.searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  void _selectCategory(String? category) {
    setState(() {
      selectedCategory = category;
    });

    final provider = Provider.of<ContentProvider>(context, listen: false);
    if (category == null) {
      provider.fetchAllContent();
    } else {
      provider.fetchContentByCategory(category);
    }
  }

  Widget _buildCategoryButton(String title, String? category) {
    bool isSelected = selectedCategory == category;

    return Container(
      height: 32,
      margin: EdgeInsets.only(right: 8),
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
          backgroundColor: isSelected ? Color(0xFF11B3CF) : Color(0xFFF2F4F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: Size(0, 32),
          side: BorderSide(
            color: isSelected ? Color(0xFF11B3CF) : Colors.grey.shade300,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
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
  final thumbnailUrl = content.effectiveThumbnail; // This now prioritizes YouTube

  return GestureDetector(
    onTap: () => _openArticleDetail(context, content),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: thumbnailUrl.isNotEmpty
                    ? _buildThumbnailImageLarge(thumbnailUrl, content.isYouTubeVideo, content.url)
                    : Container(
                        height: 180,
                        color: const Color(0xFF11B3CF),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Video',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              // Play button overlay
              Positioned.fill(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              // YouTube badge
              if (content.isYouTubeVideo)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'YouTube',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (content.url.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        content.isYouTubeVideo ? Icons.play_circle : Icons.link,
                        size: 14, 
                        color: content.isYouTubeVideo ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          Uri.parse(content.url).host,
                          style: TextStyle(
                            fontSize: 12,
                            color: content.isYouTubeVideo ? Colors.red : Colors.grey,
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

// Helper method for small thumbnail images with fallback
Widget _buildThumbnailImage(String thumbnailUrl, bool isYouTube, String? videoUrl) {
  return CachedNetworkImage(
    imageUrl: thumbnailUrl,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      color: Color(0xFFF2F4F7),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF11B3CF)),
          strokeWidth: 2,
        ),
      ),
    ),
    errorWidget: (context, url, error) {
      print('Error loading thumbnail: $error for URL: $url');
      
      // If it's YouTube and the current quality failed, try fallback
      if (isYouTube && videoUrl != null) {
        return _buildYouTubeFallbackImage(videoUrl);
      }
      
      return Container(
        color: const Color(0xFF11B3CF),
        child: const Center(
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    },
  );
}

// Helper method for large thumbnail images with fallback
Widget _buildThumbnailImageLarge(String thumbnailUrl, bool isYouTube, String videoUrl) {
  return CachedNetworkImage(
    imageUrl: thumbnailUrl,
    height: 180,
    width: double.infinity,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      height: 180,
      color: Color(0xFFF2F4F7),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF11B3CF)),
        ),
      ),
    ),
    errorWidget: (context, url, error) {
      print('Error loading thumbnail: $error for URL: $url');
      
      // If it's YouTube and the current quality failed, try fallback
      if (isYouTube && videoUrl.isNotEmpty) {
        return _buildYouTubeFallbackImageLarge(videoUrl);
      }
      
      return Container(
        height: 180,
        color: const Color(0xFF11B3CF),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
              SizedBox(height: 4),
              Text(
                'Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Fallback widget for YouTube thumbnails (small)
Widget _buildYouTubeFallbackImage(String videoUrl) {
  final fallbackUrls = YouTubeHelper.getThumbnailUrlsWithMultipleFallbacks(videoUrl);
  
  if (fallbackUrls.length > 1) {
    // Try the second fallback (mqdefault)
    return CachedNetworkImage(
      imageUrl: fallbackUrls[1],
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Container(
          color: const Color(0xFF11B3CF),
          child: const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
  
  return Container(
    color: const Color(0xFF11B3CF),
    child: const Center(
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}

// Fallback widget for YouTube thumbnails (large)
Widget _buildYouTubeFallbackImageLarge(String videoUrl) {
  final fallbackUrls = YouTubeHelper.getThumbnailUrlsWithMultipleFallbacks(videoUrl);
  
  if (fallbackUrls.length > 1) {
    // Try the second fallback (mqdefault)
    return CachedNetworkImage(
      imageUrl: fallbackUrls[1],
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Container(
          height: 180,
          color: const Color(0xFF11B3CF),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
                SizedBox(height: 4),
                Text(
                  'Video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  return Container(
    height: 180,
    color: const Color(0xFF11B3CF),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(height: 4),
          Text(
            'Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

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
    BuildContext context, 
    ContentProvider contentProvider,
    List<Content> filteredContents,
  ) {
    if (contentProvider.isLoading && contentProvider.allContents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (contentProvider.error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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

    if (filteredContents.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            widget.searchQuery.isEmpty 
                ? 'Tidak ada konten tersedia' 
                : 'Tidak ditemukan hasil untuk "${widget.searchQuery}"',
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
      itemCount: filteredContents.length,
      itemBuilder: (context, index) {
        final content = filteredContents[index];
        return _buildArticleCard(
          title: content.title,
          thumbnail: content.thumbnail,
          url: content.url,
          onTap: () => _openArticleDetail(context, content),
        );
      },
    );
  }

  // Updated _buildArticleCard method
Widget _buildArticleCard({
  required String title,
  String? thumbnail,
  String? url,
  required VoidCallback onTap,
}) {
  // Always prioritize YouTube thumbnail if it's a YouTube URL
  String effectiveThumbnail = '';
  bool isYouTube = false;
  
  if (url != null && url.isNotEmpty) {
    isYouTube = YouTubeHelper.isYouTubeUrl(url);
    
    // If it's YouTube, ALWAYS get thumbnail from YouTube
    if (isYouTube) {
      effectiveThumbnail = YouTubeHelper.getThumbnailUrlWithFallback(url);
    } else if (thumbnail != null && thumbnail.isNotEmpty) {
      // Only use database thumbnail for non-YouTube content
      effectiveThumbnail = thumbnail;
    }
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: 100,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
                color: const Color(0xFF11B3CF),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12)),
                    child: effectiveThumbnail.isNotEmpty
                        ? _buildThumbnailImage(effectiveThumbnail, isYouTube, url)
                        : Container(
                            color: const Color(0xFF11B3CF),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                  ),
                  // Play button overlay
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  // YouTube badge
                  if (isYouTube)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'YT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (url != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              isYouTube ? Icons.play_circle : Icons.link,
                              size: 12, 
                              color: isYouTube ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                Uri.parse(url).host,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isYouTube ? Colors.red : Colors.grey,
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
    super.build(context);
    return Container(
      color: Color(0xFFF2F4F7), 
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton("Semua", null),
                    _buildCategoryButton("Olahraga", "exercise"),
                    _buildCategoryButton("Nutrisi", "nutrition"),
                    _buildCategoryButton("Kesehatan", "health_tips"),
                  ],
                ),
              ),
            ),

            // Video Terbaru section - hanya tampil jika tidak ada kategori dipilih
            if (selectedCategory == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rekomendasi Video",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Consumer<ContentProvider>(
                      builder: (context, provider, child) {
                        return _buildFeaturedVideoItem(provider);
                      },
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory == null 
                        ? "Semua Video" 
                        : "Video ${_getCategoryTitle(selectedCategory!)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Consumer<ContentProvider>(
                    builder: (context, contentProvider, child) {
                      final filteredContents = _filterContent(contentProvider.allContents);
                      return _buildArticlesSection(context, contentProvider, filteredContents);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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