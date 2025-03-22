package objects;

import objects.StartMenu;

class TaskBar extends FlxSpriteGroup{
    var taskbar:FlxSprite = new FlxSprite(0, 0);
    var open:Bool = true;
    var strtmnu:StartMenu;
    var startButton:FlxButton;

    public function new(Width:Int, Height:Int, Properties:Window.WindowProperties){
        super(x, y);

        strtmnu = new StartMenu(x, y);
        add(strtmnu);
        
        taskbar.makeGraphic(Width, Height, Properties._bgColor);
        this.add(taskbar);

        startButton = new FlxButton(0, 0, "Start", ()->{ //the start button
            open = !open;
            if(!open)
                strtmnu.openMenu();
            if(open)
                strtmnu.closeMenu();
        });
        this.add(startButton);
        
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        if(strtmnu.tweening){
            startButton.status = FlxButtonState.DISABLED;
        }else{
            startButton.status = FlxButtonState.NORMAL;
        }
    }
}