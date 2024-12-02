import 'package:flutter/material.dart';
import 'package:farisfilm/models/genre.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class GenreMoviesScreen extends StatefulWidget {
  final int genreId;

  const GenreMoviesScreen({super.key, required this.genreId});

  @override
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  late Future<List<Movie>> genreMovies;
  late Future<Genre> genreDetails;

  @override
  void initState() {
    super.initState();
    genreMovies = ApiService().getMoviesByGenre(widget.genreId);
    genreDetails =
        ApiService().getGenreById(widget.genreId); // Get genre details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies by Genre'),
      ),
      body: Column(
        children: [
          // Genre Section (without description)
          FutureBuilder<Genre>(
            future: genreDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('Genre not found')),
                );
              } else {
                final genre = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        genre.name, // Genre name
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Removed the description part
                    ],
                  ),
                );
              }
            },
          ),

          // Movie Grid Section
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: genreMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: snapshot.data![index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
