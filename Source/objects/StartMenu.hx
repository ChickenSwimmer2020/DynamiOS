package objects;

class StartMenu extends FlxSpriteGroup{
    public var open:Bool = false;
    public var tweening:Bool = false;

    public var background:FlxSprite;
    public var background2:FlxSprite;

    public function new(x:Float, y:Float){
        super(x, y);

        background = new FlxSprite(x, y).makeGraphic(500, 69 * 10, FlxColor.fromString('0x1f1f1f')); //hehe, nice.
        background2 = new FlxSprite(x, y + 590).makeGraphic(500, 100, FlxColor.fromString('0x181818'));
        add(background);
        add(background2);

        y = y - 100; 
    }


    public function openMenu(){
        if(!visible)
            visible = true;
        if(!tweening){
            tweening = true;
            FlxTween.tween(this, {y: y - 700}, 0.2, { ease: FlxEase.circOut, onComplete: function(_:FlxTween) { tweening = false; }});
        }
    }
    public function closeMenu(){
        if(!tweening){
            tweening = true;
            FlxTween.tween(this, {y: y + 700}, 0.2, { ease: FlxEase.smootherStepIn, onComplete: function(_:FlxTween) { visible = false; tweening = false; } });
        }
    }

}