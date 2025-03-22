package objects;


/**
 * simple loading wheel, for loading screens or general loading stuff.
 * @since 0.0.1
 */
using flixel.util.FlxSpriteUtil;

/**
 * wheel properties.
 * @param isSeeThrough [Bool] is the main wheel transparent?
 * @param bgColor [FlxColor] the color of the background behind the wheel, since i dont know how to make it ACTUALLY transparent.
 * @param lineThickness [Float] controls the inner circle thickness to give the ILLUSION of a outlined wheel
 * @since 0.0.1
 */
typedef Wheelproperties = {
    isSeeThrough:Bool, //is the main wheel transparent?
    bgColor:FlxColor, //the color of the background behind the wheel, since i dont know how to make it ACTUALLY transparent.
    lineThickness:Float //controls the inner circle thickness to give the ILLUSION of a outlined wheel
}

class LoadingWheel extends FlxSprite {
    var spd:Float = 1;
/**
 * create a new instance of a loading wheel
 * @param x [float] x position of the wheel
 * @param y [float] y position of the wheel
 * @param width [Int] width of the wheel
 * @param height [Int] height of the wheel
 * @param Radius [float] radius of the wheel
 * @param Speed [Float] speed of the wheel
 * @param Color [FlxColor] color of the wheel
 * @param CenterOnWindow [Bool] if the wheel should be centered on the window its needed one, keep set to false if you need specific positioning
 * @since 0.0.1
 */
 public function new(x:Float, y:Float, Width:Int = 0, Height:Int = 0, ?Properties:Wheelproperties, Radius:Float = 60, Speed:Float = 1, Color:FlxColor, ?CenterOnWindow:Bool = false){
    super(x, y);
    this.makeGraphic(Width, Height, FlxColor.TRANSPARENT); //background of the wheel, the real sprite is made using FlxSpriteUtil since its a circle.
    this.drawCircle(this.getGraphicMidpoint().x, this.getGraphicMidpoint().y, Radius, Color, null, null); //create the actual circle
    spd = Speed;
    //if(CenterOnWindow){ //TODO: make work when window is implemented
    //    this.x = FlxG.width/2 - this.width/2;
    //    this.y = FlxG.height/2 - this.height/2;
    //}

    if(Properties != null){
        if(Properties.isSeeThrough){
            this.drawCircle(this.getGraphicMidpoint().x, this.getGraphicMidpoint().y, Radius-Properties.lineThickness, Properties.bgColor, null, null); //create smaller illusion circle
        }else{
            trace('loadingWheel${this.ID} was not set to be transparent.');
        }
    }
 }

 override public function update(elapsed:Float){
    super.update(elapsed);
    this.angle += (1*spd); //make spin, speed is adjustable through the main create function
 }
}