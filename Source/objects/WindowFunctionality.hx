package objects;

class WindowFunctionality extends FlxSpriteGroup{
    var functionran_EX:Bool = false;

    var bg:FlxSprite; //central bg varible.

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
        trace('window functionality created');
        trace(parent);
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
        bg = new FlxSprite(par.x, par.y).makeGraphic(1, 1, FlxColor.WHITE);
        bg.setGraphicSize(par.window.width, par.window.height);
        bg.updateHitbox();
        everything.add(bg);
    }


   override public function update(elapsed:Float){
        super.update(elapsed);
        if(par != null){
            if(functionran_EX){
                bg.setPosition(par.x, par.y);
                par.maximized && !par.fullscreen ? bg.setGraphicSize(par.window.width, par.window.height - 20) : bg.setGraphicSize(par.window.width, par.window.height - 20); bg.y += 20;
                bg.updateHitbox();
            }else{
                win_EXPLORER(); //force open once parent window isnt null, but only runs once shince functionran_EX is set to true.
            }
        }
   }
}