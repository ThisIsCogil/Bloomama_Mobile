class YouTubeHelper {
  
  static String? extractVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtube\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/\s]{11})',
      caseSensitive: false,
    );
    
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }
  
  static String? getThumbnailUrl(String url, {String quality = 'hqdefault'}) {
    final videoId = extractVideoId(url);
    if (videoId == null) return null;
    
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }
  
  // Get thumbnail with multiple fallback options
  static String getThumbnailUrlWithFallback(String url) {
    final videoId = extractVideoId(url);
    if (videoId == null) return '';
    
    // Return hqdefault as it's more reliable than maxresdefault
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
  
  // Function to get multiple quality thumbnails for error handling
  static List<String> getThumbnailUrlsWithMultipleFallbacks(String url) {
    final videoId = extractVideoId(url);
    if (videoId == null) return [];
    
    return [
      'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
      'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
      'https://img.youtube.com/vi/$videoId/default.jpg',
    ];
  }
  
  // Check if URL is YouTube
  static bool isYouTubeUrl(String url) {
    if (url.isEmpty) return false;
    return url.contains('youtube.com') || url.contains('youtu.be');
  }
}