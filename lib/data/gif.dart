class Gif {
  final String url;

  Gif({
    required this.url,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      url: json['url'],
    );
  }
}
