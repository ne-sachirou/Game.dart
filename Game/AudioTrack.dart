//#import('game_all.dart');

class AudioTrack extends GameEntity {
  List get children() => [];
  UniteAudio uniteAudio;

  bool hasPoint(int x, int y) => false;
  void draw() {}

  AudioTrack() : super();
}
