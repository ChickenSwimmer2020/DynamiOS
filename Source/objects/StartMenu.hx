package objects;

import objects.shell.ShellMenu;

class StartMenu extends FlxSpriteGroup{
    public var open:Bool = false;
    public var tweening:Bool = false;

    public var background:FlxSprite;
    public var background2:FlxSprite;

    public var powericon:FlxText;
    public var powerButton:FlxButton;
    public var shellToggle:Bool = false;

    public function new(x:Float, y:Float){
        super(x, y);

        background = new FlxSprite(x, y).makeGraphic(500, 69 * 10, FlxColor.fromString('0x1f1f1f')); //hehe, nice.
        background2 = new FlxSprite(x, y + 590).makeGraphic(500, 100, FlxColor.fromString('0x181818'));
        powericon = new FlxText(400, 630, 32, '', 32, true);
        powerButton = new FlxButton(400, 630, '', ()->{toggleShell('power'); shellToggle = !shellToggle; });
        powerButton.loadGraphic('assets/ui/buttonSQR.png', true, 20, 20);
        powerButton.scale.set(2.1, 2.1);
        powerButton.updateHitbox();
        powerButton.visible = false;
        powericon.font = 'assets/fonts/SEGMDL2.TTF';
        add(background);
        add(background2);

        add(powericon);
        add(powerButton);

        var shellmnu:ShellMenu = new ShellMenu(0, 0, {
        tabs: 4, 
        parent: powerButton,
        tabNames: [
            'Lock',
            'Sleep',
            'Shut Down',
            'Restart'
        ],
        tabFunctions: [
            ()->{trace('Locked');},
            ()->{trace('Sleeped');},
            ()->{trace('Shut Downed');},
            ()->{trace('Restarted');}
        ],
        alignment: 'TOP',
        tabIconsTXT: [
            ["character" => "", "font" => "assets/fonts/SEGMDL2.TTF"],
            ["character" => "", "font" => "assets/fonts/SEGMDL2.TTF"],
            ["character" => "", "font" => "assets/fonts/SEGMDL2.TTF"],
            ["character" => "", "font" => "assets/fonts/SEGMDL2.TTF"]
        ]
        });
        add(shellmnu);
        

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

    private function toggleShell(type:String){
    }

}