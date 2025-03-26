package;

import filesystem.FileSystem;
import lime.app.Application;
import openfl.display.Screen;

class Main extends Sprite{
    var game:FlxGame;
    public static var onExit:Array<(Int)->Void> = [];

    public function new(){
        super();
        FileSystem.loadFileSystem('fs');
        game = new FlxGame(Std.int(Screen.mainScreen.bounds.width), Std.int(Screen.mainScreen.bounds.height), Login, 60, 60, false, false);

        addChild(game);

        onExit.push(onOSExit);
        for (func in onExit)
            Application.current.onExit.add(func);
    }

    public function onOSExit(exitCode:Int):Void {
        FileSystem.saveFileSystem('fs');
    }
}