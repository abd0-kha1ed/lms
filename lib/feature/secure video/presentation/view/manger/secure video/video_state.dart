part of 'video_cubit.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoModel> videos;

  const VideoLoaded(this.videos);
}

class VideoAddedSuccessfully extends VideoState {}
class VideoUpdatedSuccessfully extends VideoState {}
class VideoDeletedSuccessfully extends VideoState {}
class VideoError extends VideoState {
  final String error;

  const VideoError(this.error);
}