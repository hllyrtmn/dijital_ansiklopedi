class Entry {
  final String id;
  final String title;
  final String keywords;
  final String description;
  final String sources;
  final DateTime createdAt;

  Entry({
    required this.id,
    required this.title,
    required this.keywords,
    required this.description,
    required this.sources,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'keywords': keywords,
      'description': description,
      'sources': sources,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      title: json['title'],
      keywords: json['keywords'],
      description: json['description'],
      sources: json['sources'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
