#import('dart:html');
#import('Game/game_all.dart');
#import('FirstScene.dart');

Game game;

void main() {
  game = new Game(query('#game'));
  game.size(800, 600);
  game.fps = 15;
  game.preloadImages = ['images/image.png'];
  /*game.preloadAudios = ['audios/kaiT_newshound_mixed.ogg',
                        'audios/kaiT_tsukimisou_mixed.ogg',
                        'audios/zenPRen_areiNoKodomo_mixed.ogg'];*/
  game.on.load.add((evt) => game.loadScene(new FirstScene()));
  game.start();
}