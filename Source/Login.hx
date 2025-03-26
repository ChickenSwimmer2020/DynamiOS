package;

import flixel.util.FlxTimer;
import flixel.text.FlxInputText;
import openfl.display.Stage;
import openfl.display.Window;

using StringTools;
using flixel.util.FlxStringUtil;

class Login extends FlxState{
    public var background:FlxSprite = new FlxSprite(0, 0);
    public var overlay:FlxSprite = new FlxSprite(0, 0);
    public var uPicContainer:FlxSprite = new FlxSprite(0, 200);
    public var username:FlxText = new FlxText(0, 500, 0, '', 24, true);
    public var passwordinput:FlxInputText = new FlxInputText(0, 1000, 500, '', 24, FlxColor.BLACK, FlxColor.WHITE, true);
    public var passwordinput_cover:FlxInputText = new FlxInputText(0, 1000, 0, '', 24, FlxColor.BLACK, FlxColor.WHITE, true);
    public var loginbutton:FlxButton;
    public var incorrectpassword:FlxText;
    public var tmr:FlxTimer = new FlxTimer();

    public var password:String = '';
    public var password2:String = '';
    public var textlenght:Int;
    public var attempts:Int = 3;

    override public function create(){
        super.create();
        @:privateAccess
        background.makeGraphic(FlxG.width, FlxG.height, FlxColor.CYAN);
        add(background);
        for(i in 0...30){
            var stripe:FlxSprite = new FlxSprite(0, if( i > 0) i * 40 else 0 * 5).makeGraphic(FlxG.width, 30, FlxColor.fromString('0xFF008686'));
            add(stripe);
            if(stripe.y > FlxG.height) //prevent more stripes from actually being rendered if not needed.
                stripe.destroy();
        }
        overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.5;
        add(overlay);

        uPicContainer.makeGraphic(300, 300, FlxColor.GRAY);
        uPicContainer.screenCenter(X);
        add(uPicContainer);

        username.text = "$username";
        username.screenCenter(X);
        add(username);

        passwordinput.screenCenter(X);
        add(passwordinput);
        
        add(passwordinput_cover);
        passwordinput_cover.x = passwordinput.x;
        passwordinput_cover.editable = false;
        passwordinput_cover.visible = false;

        loginbutton = new FlxButton(0, 1035, 'login', ()->{checkLogin(password);});
        loginbutton.x = passwordinput.x;
        loginbutton.x += 420;
        add(loginbutton);

        incorrectpassword = new FlxText(0, passwordinput.y - 50, 0, 'Password is incorrect.\nyou have [$attempts] attempts left', 12, true);
        incorrectpassword.screenCenter(X);
        incorrectpassword.alignment = CENTER;
        incorrectpassword.visible = false;
        add(incorrectpassword);
        
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        password = passwordinput.text;

        if(passwordinput.text.length > 0){
            passwordinput_cover.visible = true;
        }


        for(i in 0...password.length){
            if(password2.length < password.length){
                password2 += '#';
            }
        }
        passwordinput_cover.text = password2;

        if(FlxG.keys.anyJustPressed([BACKSPACE])){
            password2 = password2.substr(0, password2.length - 1);
        }
        if(attempts == -1){
            attempts = -999;
            FlxG.mouse.cursor.visible = false;
            for(object in this.members){
                if(Std.isOfType(object, FlxSprite)){
                    var obj:FlxSprite = cast object;
                    obj.visible = false;
                    obj.active = false;
                }
            }
            var text:FlxText = new FlxText(0, 0, 0, 'YOU HAVE BEEN LOCKED OUT.\nplease restart the application and try again', 48, true);
            text.screenCenter(XY);
            text.alignment = CENTER;
            add(text);
        }
    }

    private function checkLogin(password:String){
        if(password != Global.userPassword){
            if(attempts != -1){
                trace('password is incorrect');
                if(attempts > 1)
                    incorrectpassword.text = 'Password is incorrect.\nyou have [$attempts] attempts left';
                else{
                    incorrectpassword.text = 'Password is incorrect.\nthis is your final chance. [$attempts] attempt remains';
                    incorrectpassword.screenCenter(X);
                }
                attempts -= 1;
                passwordinput.text = '';
                passwordinput_cover.text = '';
                password = '';
                password2 = '';
                incorrectpassword.visible = true;
                if(!tmr.active){
                    incorrectpassword.alpha = 1;
                    incorrectpassword.visible = true;
                    FlxTween.cancelTweensOf(incorrectpassword);
                    tmr.start(2, function(tmr:FlxTimer){
                        FlxTween.tween(incorrectpassword, {alpha: 0}, 2, { ease: FlxEase.circIn, onComplete: function(twn:FlxTween) {
                            incorrectpassword.visible = false;
                            incorrectpassword.alpha = 1;
                        }});
                    });
                }else{
                    incorrectpassword.alpha = 1;
                    incorrectpassword.visible = true;
                    FlxTween.cancelTweensOf(incorrectpassword);
                    tmr.cancel();
                    tmr.start(2, function(tmr:FlxTimer){
                        FlxTween.tween(incorrectpassword, {alpha: 0}, 2, { ease: FlxEase.circIn, onComplete: function(twn:FlxTween) {
                            incorrectpassword.visible = false;
                            incorrectpassword.alpha = 1;
                        }});
                    });
                }
            }
        }else
            FlxG.switchState(()-> new Playstate());
    }
}