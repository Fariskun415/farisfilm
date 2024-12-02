import 'package:flutter/material.dart';
import 'package:farisfilm/screens/genre_movie_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../widgets/movie_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> latestMovies;
  late Future<List<Genre>> genres;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    popularMovies = ApiService().getPopularMovies();
    latestMovies = ApiService().getLatestMovies();
    genres = ApiService().getGenres();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        popularMovies = ApiService().getPopularMovies();
      } else {
        popularMovies = ApiService().searchMovies(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'FARISFILM™',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section (Search Bar)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://avatar.iran.liara.run/public/43'), // Ganti dengan URL yang benar
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search movies...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),

            // Genre Chips Section
            FutureBuilder<List<Genre>>(
              future: genres,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No genres available.'));
                } else {
                  final filteredGenres = snapshot.data!
                      .where((genre) => [
                            'Action',
                            'Comedy',
                            'Horror',
                            'Animation',
                            'Family',
                            'Music',
                            'Fantasy',
                            'War'
                          ].contains(genre.name))
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: filteredGenres.map((genre) {
                        return ChoiceChip(
                          label: Text(genre.name),
                          selected: false,
                          onSelected: (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GenreMoviesScreen(genreId: genre.id),
                              ),
                            );
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),

            // Judul dinamis berdasarkan pencarian
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _searchQuery.isEmpty ? 'Popular Movies' : 'Search Results',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Popular/Search Movies Section
            FutureBuilder<List<Movie>>(
              future: popularMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No popular movies found.'
                          : 'No search results found.',
                    ),
                  );
                } else {
                  return _searchQuery.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 250,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                            ),
                            items: snapshot.data!.take(10).map((movie) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return MovieCard(movie: movie);
                                },
                              );
                            }).toList(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return MovieCard(movie: snapshot.data![index]);
                            },
                          ),
                        );
                }
              },
            ),

            // Latest Movies Section (Hidden when search query is active)
            if (_searchQuery.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Latest Movies',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<List<Movie>>(
                future: latestMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No latest movies found.'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
