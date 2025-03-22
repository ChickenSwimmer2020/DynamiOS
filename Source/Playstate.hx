package;

import flixel.FlxCamera;
import objects.DesktopIcon;
import objects.WindowFunctionality;
import objects.Taskbar.TaskBar;
import objects.LoadingWheel;
import objects.Window;

class Playstate extends FlxState{
    var test1:Window;

    var windowCounter:Int = 0;

    var array:Array<String> = ['test window 1', 'Test Applcation Version: ${Application.current.meta.get('version')}'];

    private var SHELLCAM:FlxCamera;

    public static var instance:Playstate;

    public function new(){
        super();
        instance = this;

        SHELLCAM = new FlxCamera(0, 0, FlxG.width, FlxG.height);
        SHELLCAM.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.add(SHELLCAM, false);

        var icon:DesktopIcon = new DesktopIcon(500, 500, 'assets/icons/explorer.png', 'Files', {_bgColor: FlxColor.WHITE, _title: 'File Explorer', _program: 'explorer', _icon: 'assets/icons/explorer_wincow.png'});
        add(icon);

        var testspri:FlxSprite = new FlxSprite(0, 0).makeGraphic(100, 100, FlxColor.RED);
        add(testspri);

        var loadwheel = new LoadingWheel(0, 0, 100, 100, {isSeeThrough: true, bgColor: FlxColor.WHITE, lineThickness: 12}, 24, 25, FlxColor.BLUE, true);
        add(loadwheel);

        var createWindow:FlxButton = new FlxButton(0, 0, "Create Window", ()->{
            test1 = new Window(640, 480, {_bgColor: FlxColor.RED, _title: array[new FlxRandom().int(0, 1)]});
            add(test1);
            test1.loadUI(test1, {_functionality: new WindowFunctionality(test1.x, test1.y, 'explorer', test1), _icon: 'assets/icons/explorer_wincow.png'});
        });
        add(createWindow);

        var taskbar:TaskBar = new TaskBar(FlxG.width, 20, {_bgColor: FlxColor.GRAY});
        taskbar.y = FlxG.height - taskbar.height + 80;
        add(taskbar);
        taskbar.camera = SHELLCAM;

    }

    var overlappingWindows:Array<Window> = [];
    var windowIndex:Array<Int> = [];
    var hightestIndex:Int = 0;
    override public function update(elapsed:Float){
        super.update(elapsed);

        windowCounter = 0;
        for(object in this.members){
            if(Std.isOfType(object, Window)){
                windowCounter++;
                FlxG.watch.addQuick('windows:', windowCounter);
            }
            
        }
        
        if(FlxG.mouse.justPressed){
            overlappingWindows = [];
            windowIndex = [];
            hightestIndex = 0;
            for(object in this.members){
                if(Std.isOfType(object, Window)){
                    var obj:Window = cast object;
                    if(FlxG.mouse.overlaps(obj)){
                        overlappingWindows.push(obj);
                    }
                }
            }
            for(window in overlappingWindows){
                windowIndex.push(members.indexOf(window));
            }
            for(index in windowIndex){
                if(index > hightestIndex){
                    hightestIndex = index;
                }
            }
            Global.currentlySelectedWindow = members[hightestIndex].ID;

            if(Std.isOfType(members[hightestIndex], Window)){
                var temp:Window = cast members[hightestIndex];
                members.remove(temp);
                members.insert(windowCounter, temp);
            }
        }


    }
}