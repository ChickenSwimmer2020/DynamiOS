package;

class Main extends Sprite{
    var game:FlxGame;

    public function new(){
        super();
        game = new FlxGame(1920, 1080, Playstate, 60, 60, false, false);

        addChild(game);
    }
}