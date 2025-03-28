package objects;

import flixel.text.FlxInputText;
import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class WindowFunctionality extends FlxSpriteGroup{
    var functionran_EX:Bool = false;

    var bg:FlxSprite; //central bg varible.
    var windowbar:FlxSprite; //for if applications have a toolbar


    //toolbar buttons
        //file explorer
            public var dir_up:FlxButton;
            public var dir_back:FlxButton;
            public var dir_forward:FlxButton;
            public var dir_reload:FlxButton;
            public var directory:FlxText;
                public var directory_background:FlxSprite;
            public var searchbar:FlxInputText;
                public var searchbar_background:FlxSprite;
                public var searchbar_icon:FlxText;

    public var everything:FlxSpriteGroup = new FlxSpriteGroup(); //so everything can ACTUALLY be added to the window properly

    var par:Window;
    /**
     * make a new functional area of a window
     * @param x x position, set this to the window.
     * @param y y position, set this to the window.
     * @param Func what ui to load, if any.
     */
    public function new(x:Float, y:Float, Func:String = '', parent:Window){
        super(x, y);
        if(parent != null){
            if(!parent.fullscreen){
                this.width = parent.width;
                this.height = parent.height;
            }else{
                this.width = parent.width;
                this.height = parent.height;
            }
            par = parent;
        }
        if(Func != ''){
            loadWindowUI(Func);
        }
        this.add(everything);
    }
    /**
     * load a window ui based on input
     * @since 0.0.1
     */
    public function loadWindowUI(typ:String){
        switch(typ){
            case 'explorer':
                win_EXPLORER();
            default:
                trace('no window type found');
        }
    }
    /**
     * create an instance of the file explorer window.
     * @since 0.0.1
     */
    public function win_EXPLORER(){
        functionran_EX = true;
        bg = new FlxSprite(par.x, par.y).makeGraphic(1, 1, FlxColor.fromString('0x191919'));
        bg.setGraphicSize(par.window.width, par.window.height);
        bg.updateHitbox();
        everything.add(bg);

        windowbar = new FlxSprite(par.x, par.y).makeGraphic(1, 1, FlxColor.WHITE);
        windowbar.setGraphicSize(par.window.width, 20);
        windowbar.updateHitbox();
        everything.add(windowbar);

        dir_up = new FlxButton(windowbar.x + 45, windowbar.y + 20, '', ()->{null;});
        dir_up.label.font = 'assets/fonts/SEGMDL2.TTF';
        dir_up.loadGraphic('assets/ui/button_window_shell_windowcommands.png', true, 20, 20);
        everything.add(dir_up);
        dir_back = new FlxButton(windowbar.x + 5, windowbar.y + 20, '', ()->{null;});
        dir_back.label.font = 'assets/fonts/SEGMDL2.TTF';
        dir_back.loadGraphic('assets/ui/button_window_shell_windowcommands.png', true, 20, 20);
        everything.add(dir_back);
        dir_forward = new FlxButton(windowbar.x + 25, windowbar.y + 20, '', ()->{null;});
        dir_forward.label.font = 'assets/fonts/SEGMDL2.TTF';
        dir_forward.loadGraphic('assets/ui/button_window_shell_windowcommands.png', true, 20, 20);
        everything.add(dir_forward);
        dir_reload = new FlxButton(windowbar.x + 65, windowbar.y + 20, '', ()->{null;});
        dir_reload.label.font = 'assets/fonts/SEGMDL2.TTF';
        dir_reload.loadGraphic('assets/ui/button_window_shell_windowcommands.png', true, 20, 20);
        dir_reload.label.angle += 90;
        everything.add(dir_reload);
        directory_background = new FlxSprite(par.x + 85, par.y + 22).makeGraphic(400, 16, FlxColor.fromString('0xFF929292'));
        everything.add(directory_background);
        directory = new FlxText(par.x + 85, par.y + 20, 400, '[DIR]', 24, true);
        directory.setFormat('assets/fonts/SegUIVar.ttf', 12, FlxColor.BLACK, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
        everything.add(directory);
        //searchbar
    }


   override public function update(elapsed:Float){
        super.update(elapsed);
        if(par != null){
            if(functionran_EX){
                bg.setPosition(par.x, par.y);
                par.maximized && !par.fullscreen ? bg.setGraphicSize(par.window.width, par.window.height - 20) : bg.setGraphicSize(par.window.width - 2, par.window.height - 21); bg.y += 20; bg.x += 1;
                bg.updateHitbox();
                windowbar.setPosition(par.x, par.y + 20);
                par.maximized && !par.fullscreen ? windowbar.setGraphicSize(par.window.width, 20) : windowbar.setGraphicSize(par.window.width, 20); //windowbar.y += 20;
                windowbar.updateHitbox();
            }else{
                win_EXPLORER(); //force open once parent window isnt null, but only runs once shince functionran_EX is set to true.
            }
        }
   }
}