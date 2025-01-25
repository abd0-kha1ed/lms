import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final FirebaseServices firebaseServices;

  VideoCubit(this.firebaseServices) : super(VideoInitial());

  Future<void> addVideo(VideoModel video) async {
    try {
      await firebaseServices.addVideo(video);
      emit(VideoAddedSuccessfully());
      print('video added successfully');
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> fetchVideos() async {
    emit(VideoLoading());
    try {
      final videos = await firebaseServices.fetchVideos();
      emit(VideoLoaded(videos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
