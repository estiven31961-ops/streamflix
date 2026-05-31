import 'package:json_serializable/json_serializable.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final int id;
  final String title;
  final String description;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;
  final String streamUrl;
  bool isAvailable;
  final List<String> genres;
  final String duration;
  final String director;
  final List<String> cast;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.streamUrl,
    required this.isAvailable,
    required this.genres,
    required this.duration,
    required this.director,
    required this.cast,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
