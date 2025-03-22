package objects;

import objects.WindowFunctionality;

typedef WindowProperties = {
    ?_bgColor:FlxColor,
    ?_title:String,
    ?_resizable:Bool,
    ?_canBeMinimized:Bool,
    ?_canBeMaximized:Bool,
    ?_functionality:WindowFunctionality,
    ?_program:String,
};
/**
 * a window. used as a base for every application in this joke of a program
 */
class Window extends FlxSpriteGroup{
    public var windowHeld:Bool = false;

    var closeButton:FlxButton;
    var minimizeButton:FlxButton;
    var maximizeButton:FlxButton;
    var title:FlxText;
    public var internalwindow:WindowFunctionality;
    
    //window definition & shtuff
    public var window:FlxSprite = new FlxSprite(0, 0);
    //actual window objects
    var dragLocation:FlxSprite;

    //window varibles
    public var maximized:Bool = false;
    public var fullscreen:Bool = false;

    public function new(Width:Int, Height:Int, Properties:WindowProperties){
        super(x, y);

        window.makeGraphic(Width, Height, Properties._bgColor);
        dragLocation = new FlxSprite(0, 0).makeGraphic(Width - 60, 20, FlxColor.WHITE);
        #if debug
        dragLocation.alpha = 0.25;
        #else
        dragLocation.visible = false;
        #end
        this.add(window);
        this.add(dragLocation);
        closeButton = new FlxButton(this.width - 20, 0, "", ()->{ //the x
            closeWindow();
        });
        closeButton.loadGraphic('assets/ui/buttonSQR.png', true, 20, 20);
        closeButton.label.font = 'assets/fonts/SEGMDL2.TTF';
        this.add(closeButton);
       
        maximizeButton = new FlxButton(this.width - 40, 0, "", ()->{ //window icon
            trace('window should be maximized');
            maximized = !maximized; //toggle, if maximized, then minimize, if minimized, then maximize. simple and doesnt neet a big ifelse code block.
        });
        maximizeButton.loadGraphic('assets/ui/buttonSQR.png', true, 20, 20);
        maximizeButton.label.font = 'assets/fonts/SEGMDL2.TTF';
        this.add(maximizeButton);

        minimizeButton = new FlxButton(this.width - 60, 0, "", ()->{ //that one minus icon
            trace('window should be minimized');
        });
        minimizeButton.loadGraphic('assets/ui/buttonSQR.png', true, 20, 20);
        minimizeButton.label.font = 'assets/fonts/SEGMDL2.TTF';
        this.add(minimizeButton);
        title = new FlxText(0, 0, this.width, Properties._title);
        this.add(title);

        this.scale.set(0.2,0.2);
        this.alpha = 0;

        FlxTween.tween(this, {"scale.x": 1, "scale.y": 1, alpha: 1}, 0.1, { ease: FlxEase.expoOut, onComplete: function(twn:FlxTween) { trace('done'); #if debug dragLocation.alpha = 0.25; #end }});



        this.scrollFactor.set();
    }

    public function loadUI(window:Window, Properties:WindowProperties){
        //internalwindow = Properties._functionality;
        window.add(Properties._functionality);
    }

    public function closeWindow(){
        FlxTween.tween(this, {"scale.x": 0, "scale.y": 0, alpha: 0}, 0.2, { ease: FlxEase.expoOut, onComplete: function(twn:FlxTween) { this.destroy(); }});
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        if(internalwindow != null){
            internalwindow.update(elapsed);
            internalwindow.alpha = 1;
        }

        this.maximized && !this.fullscreen ? maximizeButton.label.text = "" : maximizeButton.label.text = "";

        if(Global.currentlySelectedWindow == this.ID){
            if(FlxG.mouse.overlaps(dragLocation)){
                if(FlxG.mouse.pressed){
                    this.x = FlxG.mouse.x;
                    this.y = FlxG.mouse.y;
                    windowHeld = true;
                }
            }else{
                if(windowHeld){
                    this.x = FlxG.mouse.x;
                    this.y = FlxG.mouse.y;
                }
            }
            if(FlxG.mouse.released){
                if(windowHeld)
                    windowHeld = false;
            }
        }
    }
}