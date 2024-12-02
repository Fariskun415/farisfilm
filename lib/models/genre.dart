class Genre {
  final int id;
  final String name;
  final String description;

  Genre({required this.id, required this.name, required this.description});

  // Modify the factory constructor to handle JSON response
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      description:
          _getDescriptionById(json['id']), // Add description based on genre ID
    );
  }

  // Add descriptions manually for each genre ID
  static String _getDescriptionById(int id) {
    switch (id) {
      case 28: // Action
        return "Action movies are characterized by intense sequences, fight scenes, and physical stunts.";
      case 12: // Adventure
        return "Adventure movies involve exciting and daring stories, often set in exotic locations.";
      case 35: // Comedy
        return "Comedy movies are designed to entertain and make audiences laugh.";
      case 18: // Drama
        return "Drama movies focus on real-life situations, with emotional and thought-provoking narratives.";
      // Add more genres and their descriptions as needed
      default:
        return "Description not available.";
    }
  }
}
