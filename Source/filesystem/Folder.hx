package filesystem;

class Folder extends FileObj {
    public var contents:Map<String, FileObj>;
    override public function new() {
        super();
        this.contents = new Map();
    }
}