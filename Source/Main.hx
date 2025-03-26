package;

import openfl.display.Screen;

class Main extends Sprite{
    var game:FlxGame;

    public function new(){
        super();
        game = new FlxGame(Std.int(Screen.mainScreen.bounds.width), Std.int(Screen.mainScreen.bounds.height), Login, 60, 60, false, false);

        addChild(game);
    }
}