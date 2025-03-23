package filesystem;

import haxe.io.Bytes;

class File extends FileObj {
    public var name:String;
    public var contents:Bytes;

    override public function new(name:String, contents:Bytes) {
        super();
        this.name = name;
        this.contents = contents;
    }
}