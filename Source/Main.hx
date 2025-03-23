package;

import filesystem.FileSystem;
import lime.app.Application;

class Main extends Sprite{
    var game:FlxGame;
    public static var onExit:Array<(Int)->Void> = [];

    public function new(){
        super();
        FileSystem.loadFileSystem('fs');
        game = new FlxGame(2560, 1440, Playstate, 60, 60, false, false);

        addChild(game);

        onExit.push(onOSExit);
        for (func in onExit)
            Application.current.onExit.add(func);
    }

    public function onOSExit(exitCode:Int):Void {
        FileSystem.saveFileSystem('fs');
    }
}