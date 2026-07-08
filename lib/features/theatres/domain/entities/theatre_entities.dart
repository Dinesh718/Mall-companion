class CastMemberEntity {
  final String name;
  final String characterName;
  final String imageUrl;

  const CastMemberEntity({
    required this.name,
    required this.characterName,
    required this.imageUrl,
  });
}

class CrewMemberEntity {
  final String name;
  final String role;
  final String imageUrl;

  const CrewMemberEntity({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class ShowTimeEntity {
  final String id;
  final String theatreId;
  final String movieId;
  final String time; // e.g. "10:00 AM"
  final double price;
  final String status; // e.g. "Available", "Almost Full", "Sold Out"
  final int availableSeats;

  const ShowTimeEntity({
    required this.id,
    required this.theatreId,
    required this.movieId,
    required this.time,
    required this.price,
    required this.status,
    required this.availableSeats,
  });
}

class TheatreEntity {
  final String id;
  final String name;
  final String floorText;
  final String screenText;
  final List<String> facilities;
  final String mapImageUrl;
  final String distanceWalkText;

  const TheatreEntity({
    required this.id,
    required this.name,
    required this.floorText,
    required this.screenText,
    required this.facilities,
    required this.mapImageUrl,
    required this.distanceWalkText,
  });
}

class MovieEntity {
  final String id;
  final String title;
  final String imageUrl;
  final String bannerUrl;
  final double rating;
  final String genre;
  final String language;
  final String duration;
  final String ageRestriction;
  final String synopsis;
  final String releaseDate;
  final List<CastMemberEntity> cast;
  final List<CrewMemberEntity> crew;
  final List<String> gallery;
  final bool isBookmarked;
  final List<ShowTimeEntity> showTimes;
  final String category; // e.g. "Now Showing", "Coming Soon"
  final String nextShowTimeText; // e.g. "1:30 PM"
  final String associatedTheatreName; // e.g. "PVR LUXE, Level 4"

  const MovieEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.bannerUrl,
    required this.rating,
    required this.genre,
    required this.language,
    required this.duration,
    required this.ageRestriction,
    required this.synopsis,
    required this.releaseDate,
    required this.cast,
    required this.crew,
    required this.gallery,
    this.isBookmarked = false,
    required this.showTimes,
    required this.category,
    required this.nextShowTimeText,
    required this.associatedTheatreName,
  });

  MovieEntity copyWith({
    bool? isBookmarked,
  }) {
    return MovieEntity(
      id: id,
      title: title,
      imageUrl: imageUrl,
      bannerUrl: bannerUrl,
      rating: rating,
      genre: genre,
      language: language,
      duration: duration,
      ageRestriction: ageRestriction,
      synopsis: synopsis,
      releaseDate: releaseDate,
      cast: cast,
      crew: crew,
      gallery: gallery,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      showTimes: showTimes,
      category: category,
      nextShowTimeText: nextShowTimeText,
      associatedTheatreName: associatedTheatreName,
    );
  }
}
