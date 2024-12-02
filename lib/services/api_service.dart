import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/movie_detail.dart';

class ApiService {
  final String apiKey = 'af0092c2559a609af061f9d2e2c62799';
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Method to handle URL encoding
  String _encodeQuery(String query) {
    return Uri.encodeComponent(query); // Ensures special characters are handled
  }

  Future<List<Movie>> getPopularMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List movies = json.decode(response.body)['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getLatestMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List movies = json.decode(response.body)['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  Future<List<Genre>> getGenres() async {
    final response =
        await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List genres = json.decode(response.body)['genres'];
      return genres.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'));
    if (response.statusCode == 200) {
      final List movies = json.decode(response.body)['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final movieDetail = json.decode(response.body);
      return MovieDetail.fromJson(movieDetail);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      return []; // Return an empty list if the query is empty or contains only spaces
    }

    final encodedQuery = _encodeQuery(query); // URL encode the query
    final response = await http.get(
        Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['results'];
      return jsonData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  // Add this method to fetch genre details
  Future<Genre> getGenreById(int genreId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/genre/$genreId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final genre = json.decode(response.body);
      return Genre.fromJson(genre);
    } else {
      throw Exception('Failed to load genre details');
    }
  }
}
