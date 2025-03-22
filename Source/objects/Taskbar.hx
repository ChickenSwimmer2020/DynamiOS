package objects;

class TaskBar extends FlxSpriteGroup{
    var taskbar:FlxSprite = new FlxSprite(0, 0);
    var startButton:FlxButton;
    var startMenu:FlxSpriteGroup = new FlxSpriteGroup();
    var startMenuOpen:Bool = false;
    var startMenuItems:Array<FlxButton> = [];
    var startMenuItemsText:Array<String> = ['Settings', 'Power', 'Log Out', 'Shut Down'];
    var startMenuItemsFunctions:Array<Void->Void> = [
        ()->{trace('Settings');},
        ()->{trace('Power');},
        ()->{trace('Log Out');},
        ()->{trace('Shut Down');}
    ];

    public function new(Width:Int, Height:Int, Properties:Window.WindowProperties){
        super(x, y);

        taskbar.makeGraphic(Width, Height, Properties._bgColor);
        this.add(taskbar);

        startButton = new FlxButton(0, 0, "Start", ()->{ //the start button
            startMenuOpen = !startMenuOpen;
            if(startMenuOpen){
                startMenu.visible = true;
            }else{
                startMenu.visible = false;
            }
        });
        this.add(startButton);

        for(i in 0...startMenuItemsText.length){
            var item:FlxButton = new FlxButton(0, -20 * i - 20, startMenuItemsText[i], startMenuItemsFunctions[i]);
            startMenuItems.push(item);
            startMenu.add(item);
        }
        startMenu.visible = false;
        this.add(startMenu);
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
    }
}