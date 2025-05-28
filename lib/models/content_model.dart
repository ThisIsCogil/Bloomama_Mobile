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
      title: json['title'],
      url: json['url'],
      category: json['category'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}