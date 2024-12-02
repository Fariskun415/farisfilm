import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4, // Tambahkan elevasi untuk efek bayangan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Hindari melebihi ruang
          children: [
            // Gambar dengan batas tinggi maksimal
            Container(
              height: 170, // Maksimal tinggi gambar
              width: double.infinity, // Lebar penuh card
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: movie.posterPath.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(movie.posterPath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: movie.posterPath.isEmpty
                  ? const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    )
                  : null,
            ),
            // Teks Judul Film
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 14, // Ukuran font kecil untuk mencegah overflow
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Teks dengan elipsis
                maxLines: 2, // Maksimal 2 baris teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
