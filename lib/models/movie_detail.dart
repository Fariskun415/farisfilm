// lib/models/movie_detail.dart
class MovieDetail {
  final String title;
  final String releaseDate;
  final double rating;
  final String overview;
  final String backdropPath;
  final List<String> genres;

  MovieDetail({
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.overview,
    required this.backdropPath,
    required this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    List<String> genres = List<String>.from(
      json['genres'].map((genre) => genre['name'] ?? 'Unknown'),
    );

    return MovieDetail(
      title: json['title'],
      releaseDate: json['release_date'] ?? 'Unknown',
      rating: json['vote_average'].toDouble(),
      overview: json['overview'] ?? 'No Overview',
      backdropPath:
          'https://image.tmdb.org/t/p/w500' + (json['backdrop_path'] ?? ''),
      genres: genres,
    );
  }
}
