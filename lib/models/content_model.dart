import 'package:flutter/material.dart';
import '../helpers/youtube_helper.dart'; // ← Tambahkan import ini

class Content {
  final String contentId;
  final String title;
  final String url;
  final String category;
  final String description;
  final String thumbnail;
  final DateTime createdAt;

  Content({
    required this.contentId,
    required this.title,
    required this.url,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      contentId: json['content_id'].toString(),
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  // MODIFIED: Always prioritize YouTube thumbnail over database thumbnail
  String get effectiveThumbnail {
    // If this is a YouTube video, ALWAYS get thumbnail from YouTube
    if (url.isNotEmpty && YouTubeHelper.isYouTubeUrl(url)) {
      return YouTubeHelper.getThumbnailUrlWithFallback(url);
    }
    
    // Only use database thumbnail for non-YouTube content
    if (thumbnail.isNotEmpty) {
      return thumbnail;
    }
    
    return '';
  }
  
  // Get multiple thumbnail URLs for YouTube videos (for error handling)
  List<String> get youtubeThumbnailFallbacks {
    if (url.isNotEmpty && YouTubeHelper.isYouTubeUrl(url)) {
      return YouTubeHelper.getThumbnailUrlsWithMultipleFallbacks(url);
    }
    return [];
  }
  
  // Getter to check if this is a YouTube video
  bool get isYouTubeVideo => url.isNotEmpty && YouTubeHelper.isYouTubeUrl(url);
}