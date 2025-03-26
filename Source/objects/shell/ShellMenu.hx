package objects.shell;

import flixel.FlxObject;

/**
 * the options of creating a shell menu, stored in a typdef so it can more easily be created for use in the OS
 * @param parent object to parent this menu to \<Dynamic\>
 * @param tabs how many tabs to give the shell menu \<Int\>
 * @param tabNames the names of the tabs \<Array\> == [String]
 * @param tabFunctions what each tab will do when clicked \<Array\> == [Void->Void]
 * @param tabIconsSPR \<\<OPTIONAL\>\> icons of the options in sprite form, auto sized and such. \<Array\> == [String]
 * @param tabIconsTXT \<\<OPTIONAL\>\> the icons of the tabs, set as a map for fonts and such. \<Array\> == [Map\<String, String\>]
 * @param tabIconsTXT_MAP01 Character to use \<String\>
 * @param tabIconsTXT_MAP02 Font to use, most likely segoeUIMDL2.ttf \<String\>
 * @param alignment alignment of the shell menu \<String\>
 * @since 0.0.1
 */
typedef ShellOptions = {
    var parent:Dynamic;
    var tabs:Int;
    var tabNames:Array<String>;
    var tabFunctions:Array<Void->Void>;
    var ?tabIconsSPR:Array<String>;
    var ?tabIconsTXT:Array<Map<String, String>>;
    var alignment:String;
}

class ShellMenu extends FlxSpriteGroup{
    public var align:String;
    public function new(x:Float, y:Float, Options:ShellOptions){
        super(x, y);

        switch(Options.alignment){
            case 'TOP':
                align = 'TOP';
            case 'BOTTOM':
                align = 'BOTTOM';
            case 'LEFT':
                align = 'LEFT';
            case 'RIGHT':
                align = 'RIGHT';
            default:
                trace('alignment not choosen. HOW');
                align = 'TOP';
        }

        for(i in 0...Options.tabs){
            var btn:FlxButton = new FlxButton(0, if(i > 0) 20 * i else 0, '${Options.tabNames[i]}', Options.tabFunctions[i]);
            add(btn);
            btn.label.x += 100;
            btn.label.alignment = LEFT;
            if(Options.tabIconsSPR != null){
                var ICN:FlxSprite = new FlxSprite(0, if(i > 0) 20 * i else 0).loadGraphic('assets/icons/shell/${Options.tabIconsSPR[i]}.png');
                ICN.setGraphicSize(16, 16);
                add(ICN);
            }
            if(Options.tabIconsTXT != null){
                var ICN:FlxText = new FlxText(5, if(i > 0) 20 * i + 2 else 2, btn.width, '', 12, true);
                ICN.text = '${Options.tabIconsTXT[i].get("character")}';
                add(ICN);
                ICN.font = '${Options.tabIconsTXT[i].get("font")}';
            }
            
        }


        if(Options.parent != null){
            if(Std.isOfType(Options.parent, FlxObject)){
                var obj:FlxObject = cast Options.parent;
                switch(align){ //should work?
                    case 'TOP':
                        this.x = obj.getMidpoint().x - width/2;
                        this.y = obj.y - height;
                    case 'BOTTOM':
                        this.x = obj.getMidpoint().x - width/2;
                        this.y = obj.y - this.height;
                    case 'LEFT':
                        this.x = obj.x;
                        this.y = obj.getMidpoint().y - height;
                    case 'RIGHT':
                        this.x = obj.x - (obj.x * 2);
                        this.y = obj.getMidpoint().y - height;
                }
            }
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> a93b6642acc2241fdc84c9194ee85bf87074d88b
