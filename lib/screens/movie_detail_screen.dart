import 'package:flutter/material.dart';
import '../models/movie_detail.dart';
import '../services/api_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> movieDetail;

  @override
  void initState() {
    super.initState();
    movieDetail = ApiService().getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Lighter background for a fresh look
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 4, // Slight elevation for a subtle shadow effect
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Movie Detail',
            style: TextStyle(
              color: Colors.white, // White text for contrast
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2.0, 2.0),
                ),
              ], // Add text shadow for more pop
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share,
                color: Colors.white), // Share icon in white
            onPressed: () {
              // Share functionality will go here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF707379).withOpacity(0.8),
                const Color.fromRGBO(86, 91, 95, 1).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<MovieDetail>(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No movie details found.'));
          } else {
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie backdrop with a subtle shadow to stand out
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movie.backdropPath),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie title with darker text for high contrast
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Release Date with lighter gray text
                        Text(
                          'Release Date: ${movie.releaseDate}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        // Rating with star icon and dark text
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.yellow[700], size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${movie.rating}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Overview Section with a light background for the text box
                        const Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Genres Section with a white background for the genre chips
                        const Text(
                          'Genres',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: movie.genres.map((genre) {
                            return Chip(
                              label: Text(genre,
                                  style: const TextStyle(color: Colors.black)),
                              backgroundColor:
                                  const Color.fromARGB(255, 254, 254, 254),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
