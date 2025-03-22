package objects;


class DesktopIcon extends FlxSpriteGroup{
    public var highlightSquare:FlxSprite;
    var Gr:FlxSprite;
    var pro:Window.WindowProperties;
    var timer:Int = 0; //ms timer.
    public function new(x:Float, y:Float, grph:FlxGraphicAsset, nme:String, Prop:Window.WindowProperties){
        super(x, y);
        pro = Prop;
        highlightSquare = new FlxSprite(-5, 0).makeGraphic(59, 78, FlxColor.WHITE);
        add(highlightSquare);
        Gr = new FlxSprite(0, 0).loadGraphic(grph);
        Gr.setGraphicSize(48, 48);
        Gr.updateHitbox();
        var text:FlxText = new FlxText(Gr.x, 60, Gr.width, nme, 12, true);
        text.alignment = 'center';
        this.add(Gr);
        this.add(text);
        var button:FlxButton = new FlxButton(0, 0, '', ()->{});
        button.loadGraphic('assets/ui/buttonSQR.png', true, 20, 20);
        button.label.text = '';
        button.label.fieldWidth = 0;
        button.scale.set(2.5, 2.5);
        button.updateHitbox();
        button.alpha = 0;
        this.add(button);

        this.scrollFactor.set();

        for(object in this.members){
            if(Std.isOfType(object, FlxSprite)){
                var obj:FlxSprite = cast object;
                obj.scrollFactor.set();
            }
        }
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
  
        if(FlxG.mouse.overlaps(Gr)){
            highlightSquare.alpha = 0.5;

            if (timer == 1000)
                timer--;
            if (timer <= 0)
                timer = 0;

            if (FlxG.mouse.justPressed && timer == 0)
                timer = 1000;
            else{
                timer -= 75;
                if (FlxG.mouse.justPressed && timer >= 100)
                {
                    timer = 0;
                    makeWindow(pro);
                }
            }

        }else{
            if(highlightSquare.alpha != 0){
                highlightSquare.alpha = 0;
            }
        }
    }

    public function makeWindow(Prop:Window.WindowProperties){
        var window:Window = new Window(640, 480, Prop);
        Playstate.instance.add(window);
        window.loadUI(window, {_functionality: new WindowFunctionality(window.x, window.y, pro._program, window)});
    }
}