// lib/models/movie.dart
class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath:
          'https://image.tmdb.org/t/p/w500' + (json['poster_path'] ?? ''),
      releaseDate: json['release_date'] ?? 'Unknown',
      rating: json['vote_average'].toDouble(),
    );
  }
}
