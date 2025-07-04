import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/data/model/video_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';



part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final FirebaseServices firebaseServices;
  String selectedGrade = "";
  bool? hasCode; // To track the selected grade for filtering

  VideoCubit(this.firebaseServices) : super(VideoInitial());

  Future<void> addVideo(VideoModel video) async {
    emit(VideoLoading());
    try {
      await firebaseServices.addVideo(video);
      emit(VideoAddedSuccessfully());
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> fetchVideos() async {
    emit(VideoLoading());
    try {
      final videos = await firebaseServices.fetchVideos();
      final filteredVideos = selectedGrade.isEmpty
          ? videos
          : videos.where((video) => video.grade == selectedGrade).toList();
      emit(VideoLoaded(filteredVideos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> editVideoDetails(VideoModel updatedVideo) async {
    emit(VideoLoading());
    try {
      await firebaseServices.updateVideoDetails(updatedVideo);
      emit(VideoUpdatedSuccessfully());
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  void setFilteredEncrypted(bool? hasCodeFilter) {
    hasCode = hasCodeFilter;
    fetchVideosEncrypted();
  }

  Future<void> fetchVideosEncrypted() async {
    emit(VideoLoading());

    try {
      final videos = await firebaseServices.fetchVideos();
      final filteredVideos = videos.where((video) {
        return hasCode == null || video.hasCodes == hasCode;
      }).toList();
      emit(VideoLoaded(filteredVideos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  void setGrade(String grade) {
    selectedGrade = grade;
    fetchVideos();
  }

  Future<void> deleteVideo(String id) async {
    emit(VideoLoading());
    try {
      await firebaseServices.deleteVideo(id);
      emit(VideoDeletedSuccessfully());
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> addEncryptedVideo(VideoModel video) async {
    emit(VideoLoading());
    try {
      await firebaseServices.addEncryptedVideo(video);
      emit(VideoAddedSuccessfully());
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
