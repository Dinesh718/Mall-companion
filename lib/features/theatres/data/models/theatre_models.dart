import '../../domain/entities/theatre_entities.dart';

class CastMemberModel extends CastMemberEntity {
  const CastMemberModel({
    required super.name,
    required super.characterName,
    required super.imageUrl,
  });
}

class CrewMemberModel extends CrewMemberEntity {
  const CrewMemberModel({
    required super.name,
    required super.role,
    required super.imageUrl,
  });
}

class ShowTimeModel extends ShowTimeEntity {
  const ShowTimeModel({
    required super.id,
    required super.theatreId,
    required super.movieId,
    required super.time,
    required super.price,
    required super.status,
    required super.availableSeats,
  });
}

class TheatreModel extends TheatreEntity {
  const TheatreModel({
    required super.id,
    required super.name,
    required super.floorText,
    required super.screenText,
    required super.facilities,
    required super.mapImageUrl,
    required super.distanceWalkText,
  });
}

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.bannerUrl,
    required super.rating,
    required super.genre,
    required super.language,
    required super.duration,
    required super.ageRestriction,
    required super.synopsis,
    required super.releaseDate,
    required List<CastMemberEntity> super.cast,
    required List<CrewMemberEntity> super.crew,
    required super.gallery,
    super.isBookmarked,
    required List<ShowTimeEntity> super.showTimes,
    required super.category,
    required super.nextShowTimeText,
    required super.associatedTheatreName,
  });
}
