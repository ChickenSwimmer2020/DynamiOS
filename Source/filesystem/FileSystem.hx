package filesystem;

import filesystem.File;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.BytesBuffer;

using StringTools;

typedef FileData = {filePath:String, fileContents:Bytes};

class FileSystem
{
    public static var files:Map<String, FileObj> = [];

    private static function navigateDirectory(path:String, createMissing:Bool = false):Folder {
        var parts = path.split("/");
        var currentFolder:Folder = null;
        var currentPath = "";
        
        // Handle root folder.
        if (parts.length > 0 && parts[0] == "") {
            parts.shift();
            currentPath = "/";
            if (FileSystem.files.get("/") == null) {
                var rootFolder = new Folder();
                FileSystem.files.set("/", rootFolder);
                currentFolder = rootFolder;
            } else {
                currentFolder = cast FileSystem.files.get("/");
            }
        }
        
        for (i in 0...parts.length) {
            var folderName = parts[i];
            if (folderName == "") continue;
            if (currentPath == "" || currentPath == "/")
                currentPath += folderName;
            else
                currentPath += "/" + folderName;
            
            var folder:Folder = null;
            if (currentFolder == null) {
                if (FileSystem.files.exists(currentPath)) {
                    var fileObj = FileSystem.files.get(currentPath);
                    if (Std.isOfType(fileObj, Folder)) {
                        folder = cast fileObj;
                    } else {
                        throw '$currentPath is a file, not a folder';
                    }
                } else if (createMissing) {
                    folder = new Folder();
                    FileSystem.files.set(currentPath, folder);
                } else {
                    throw 'Path ' + currentPath + ' does not exist';
                }
                currentFolder = folder;
            } else {
                if (currentFolder.contents.exists(folderName)) {
                    var fileObj = currentFolder.contents.get(folderName);
                    if (Std.isOfType(fileObj, Folder)) {
                        folder = cast fileObj;
                    } else {
                        throw '$folderName is a file, not a folder';
                    }
                } else if (createMissing) {
                    folder = new Folder();
                    currentFolder.contents.set(folderName, folder);
                } else {
                    throw 'Folder ' + folderName + ' does not exist in ' + currentPath;
                }
                currentFolder = folder;
            }
        }
        return currentFolder;
    }
    
    private static function navigatePath(path:String, createMissing:Bool = false):{ parent:Folder, fileName:String } {
        while (path.length > 0 && path.charAt(0) == "/") {
            path = path.substr(1);
        }
        while (path.length > 0 && path.charAt(path.length - 1) == "/") {
            path = path.substr(0, path.length - 1);
        }
        
        var parts = path.split("/");
        if (parts.length == 0) {
            throw 'Invalid file path';
        }
        
        var fileName = parts.pop();
        
        if (!FileSystem.files.exists("/")) {
            if (createMissing) {
                FileSystem.files.set("/", new Folder());
            } else {
                throw 'Root folder does not exist';
            }
        }
        var currentFolder:Folder = cast FileSystem.files.get("/");
        
        for (i in 0...parts.length) {
            var folderName = parts[i];
            if (folderName == "") continue;
            if (!currentFolder.contents.exists(folderName)) {
                if (createMissing) {
                    currentFolder.contents.set(folderName, new Folder());
                } else {
                    throw 'Path ' + folderName + ' does not exist';
                }
            }
            var nextFolder = currentFolder.contents.get(folderName);
            if (!Std.isOfType(nextFolder, Folder)) {
                throw folderName + ' is a file, not a folder';
            }
            currentFolder = cast nextFolder;
        }
        
        return { parent: currentFolder, fileName: fileName };
    }
    
    

    //----------------- FILE OPERATIONS -----------------//
    public static function getFile(filePath:String):File {
        var pathInfo = navigatePath(filePath);
        var parent = pathInfo.parent;
        var fileName = pathInfo.fileName;
        
        if (parent != null) {
            if (parent.contents.exists(fileName)) {
                var file = parent.contents.get(fileName);
                if (Std.isOfType(file, File)) {
                    return cast file;
                } else {
                    throw '$fileName is a folder, not a file';
                }
            }
        } else {
            throw 'Invalid file path structure: $filePath';
        }
        
        throw 'File $filePath does not exist';
    }

    public static function getContent(filePath:String):String {
        return getFile(filePath).contents.toString();
    }

    public static function getBytes(filePath:String):Bytes {
        return getFile(filePath).contents;
    }

    public static function saveContent(filePath:String, content:String) {
        saveBytes(filePath, Bytes.ofString(content));
    }

    public static function saveBytes(filePath:String, bytes:Bytes) {
        try {
            var file = getFile(filePath);
            file.contents = bytes;
        } catch (e:Dynamic) {
            var pathInfo = navigatePath(filePath, true);
            var parent = pathInfo.parent;
            var fileName = pathInfo.fileName;
            
            if (parent != null) {
                var newFile = new File(fileName, bytes);
                parent.contents.set(fileName, newFile);
            } else {
                throw 'Invalid file path structure: $filePath';
            }
        }
    }

    public static function appendBytes(filePath:String, bytes:Bytes) {
        try {
            var file = getFile(filePath);
            var buffer = new haxe.io.BytesBuffer();
            buffer.add(file.contents);
            buffer.add(bytes);
            file.contents = buffer.getBytes();
        } catch (e:Dynamic) {
            saveBytes(filePath, bytes);
        }
    }

    public static function appendContent(filePath:String, content:String) {
        appendBytes(filePath, Bytes.ofString(content));
    }

    public static function copyTo(startFilePath:String, targetFilePath:String) {
        var file = getFile(startFilePath);
        var targetPathInfo = navigatePath(targetFilePath, true);
        var targetParent = targetPathInfo.parent;
        var targetFileName = targetPathInfo.fileName;
        
        if (targetParent != null) {
            var newFile = new File(targetFileName, file.contents);
            targetParent.contents.set(targetFileName, newFile);
        } else {
            throw 'Invalid target path structure: $targetFilePath';
        }
    }

    public static function moveTo(startFilePath:String, targetFilePath:String) {
        copyTo(startFilePath, targetFilePath);
        rmFile(startFilePath);
    }

    //----------------- FILE SYSTEM OPERATIONS -----------------//
    public static function makeDir(dirPath:String) {
        var parts = dirPath.split("/");
        var currentPath = "";
        var currentFolder:Folder = null;
        
        if (parts.length > 0 && parts[0] == "") {
            parts.shift();
            currentPath = "/";
            if (!FileSystem.files.exists("/")) {
                var rootFolder = new Folder();
                FileSystem.files.set("/", rootFolder);
                currentFolder = rootFolder;
            } else {
                var fileObj = FileSystem.files.get("/");
                if (Std.isOfType(fileObj, Folder)) {
                    currentFolder = cast fileObj;
                } else {
                    throw 'Root is a file, not a folder';
                }
            }
        } else {
            if (!FileSystem.files.exists("/")) {
                var rootFolder = new Folder();
                FileSystem.files.set("/", rootFolder);
                currentFolder = rootFolder;
            } else {
                currentFolder = cast FileSystem.files.get("/");
            }
        }
        
        for (i in 0...parts.length) {
            var folderName = parts[i];
            if (folderName == "") continue;
            
            if (currentPath == "" || currentPath == "/")
                currentPath += folderName;
            else
                currentPath += "/" + folderName;
            
            if (currentFolder == null) {
                throw 'Invalid path structure, cannot create directory: ' + dirPath;
            } else {
                if (!currentFolder.contents.exists(folderName)) {
                    var newFolder = new Folder();
                    currentFolder.contents.set(folderName, newFolder);
                    currentFolder = newFolder;
                } else {
                    var fileObj = currentFolder.contents.get(folderName);
                    if (Std.isOfType(fileObj, Folder)) {
                        currentFolder = cast fileObj;
                    } else {
                        throw '$folderName is a file, not a folder';
                    }
                }
            }
        }
    }
    

    public static function rmDir(dirPath:String) {
        if (dirPath == "/" || dirPath == "") {
            FileSystem.files.remove("/");
            return;
        }
        
        try {
            var parts = dirPath.split("/");
            var dirName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            if (FileSystem.files.exists(parentPath)) {
                var parentObj = FileSystem.files.get(parentPath);
                if (Std.isOfType(parentObj, Folder)) {
                    var parent = cast(parentObj, Folder);
                    parent.contents.remove(dirName);
                } else {
                    var pathInfo = navigatePath(parentPath);
                    var parent = pathInfo.parent;
                    if (parent != null && parent.contents.exists(dirName)) {
                        parent.contents.remove(dirName);
                    } else {
                        throw 'Cannot remove directory: parent folder not found';
                    }
                }
            } else {
                throw 'Parent directory does not exist: $parentPath';
            }
        } catch (e:Dynamic) {
            trace('Error removing directory $dirPath: $e');
            throw 'Failed to remove directory: $e';
        }
    }

    public static function setDir(dirPath:String, folder:Folder) {
        if (dirPath == "/" || dirPath == "") {
            FileSystem.files.set("/", folder);
            return;
        }
        
        try {
            var parts = dirPath.split("/");
            var dirName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            makeDir(parentPath);
            
            var parentObj = FileSystem.files.get(parentPath);
            if (Std.isOfType(parentObj, Folder)) {
                var parent = cast(parentObj, Folder);
                parent.contents.set(dirName, folder);
            } else {
                throw 'Parent is not a folder: $parentPath';
            }
        } catch (e:Dynamic) {
            trace('Error setting directory $dirPath: $e');
            throw 'Failed to set directory: $e';
        }
    }

    public static function dirExists(dirPath:String):Bool {
        if (dirPath == "/" || dirPath == "") {
            return FileSystem.files.exists("/");
        }
        
        try {
            var parts = dirPath.split("/");
            var dirName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            if (FileSystem.files.exists(parentPath)) {
                var parentObj = FileSystem.files.get(parentPath);
                if (Std.isOfType(parentObj, Folder)) {
                    var parent = cast(parentObj, Folder);
                    return parent.contents.exists(dirName) && 
                           Std.isOfType(parent.contents.get(dirName), Folder);
                }
            }
            
            return false;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function makeFile(path:String, name:String, makeDirectory:Bool = false, ?fileContent:Dynamic):File {
        var content:Bytes = Bytes.alloc(0);
        if (fileContent != null)
            content = Std.isOfType(fileContent, String) ? Bytes.ofString(fileContent) : fileContent;
        
        if (makeDirectory) {
            makeDir(path);
        }
        
        var fullPath = (path.endsWith("/") ? path + name : path + "/" + name);
        var newFile = new File(name, content);
        
        try {
            var folder:Folder = navigateDirectory(path, makeDirectory);
            if (folder != null) {
                folder.contents.set(name, newFile);
            } else {
                throw 'Invalid directory structure: ' + path;
            }
        } catch (e:Dynamic) {
            if (makeDirectory) {
                throw 'Error creating file ' + fullPath + ': ' + e;
            } else {
                throw 'File path ' + path + ' does not exist.';
            }
        }
        
        return newFile;
    }


    public static function rmFile(path:String) {
        try {
            var parts = path.split("/");
            var fileName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            if (FileSystem.files.exists(parentPath)) {
                var parentObj = FileSystem.files.get(parentPath);
                if (Std.isOfType(parentObj, Folder)) {
                    var parent = cast(parentObj, Folder);
                    parent.contents.remove(fileName);
                    return;
                } else {
                    throw 'Parent is not a folder: $parentPath';
                }
            } else {
                throw 'Parent directory does not exist: $parentPath';
            }
        } catch (e:Dynamic) {
            trace('Error removing file $path: $e');
            throw 'Failed to remove file: $e';
        }
    }

    public static function setFile(path:String, file:File) {
        try {
            var parts = path.split("/");
            var fileName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            if (!dirExists(parentPath) && parentPath != "/") {
                makeDir(parentPath);
            }
            
            var parentObj = FileSystem.files.get(parentPath);
            if (Std.isOfType(parentObj, Folder)) {
                var parent = cast(parentObj, Folder);
                parent.contents.set(fileName, file);
            } else {
                throw 'Parent is not a folder: $parentPath';
            }
        } catch (e:Dynamic) {
            trace('Error setting file $path: $e');
            throw 'Failed to set file: $e';
        }
    }

    public static function fileExists(filePath:String):Bool {
        try {
            var parts = filePath.split("/");
            var fileName = parts.pop();
            var parentPath = parts.join("/");
            
            if (parentPath == "") parentPath = "/";
            
            if (FileSystem.files.exists(parentPath)) {
                var parentObj = FileSystem.files.get(parentPath);
                if (Std.isOfType(parentObj, Folder)) {
                    var parent = cast(parentObj, Folder);
                    return parent.contents.exists(fileName) && 
                           Std.isOfType(parent.contents.get(fileName), File);
                }
            }
            
            return false;
        } catch (e:Dynamic) {
            return false;
        }
    }


    //----------------- FILE SYSTEM SAVING/LOADING -----------------//
    public static function saveFileSystem(fileName:String) {
        var files:Array<Dynamic> = [];
        for (fileKey => fileObj in FileSystem.files) {
            if (fileKey == "/") {
                var rootFolder:Folder = cast fileObj;
                files = files.concat(lookThroughFolders(rootFolder, ""));
            } else if (Std.isOfType(fileObj, File)) {
                var file:File = cast fileObj;
                files.push([fileKey, file.contents]);
            } else if (Std.isOfType(fileObj, Folder)) {
                var folder:Folder = cast fileObj;
                files = files.concat(lookThroughFolders(folder, fileKey + "/"));
            }
        }
        var finalFiles:Array<FileData> = flattenFiles(files);
        var bytesOutput = new BytesOutput();

        bytesOutput.writeString("DYNAMIOS");

        for (file in finalFiles) {
            var pathBytes = Bytes.ofString(file.filePath);
            bytesOutput.writeInt32(pathBytes.length);
            bytesOutput.write(pathBytes);

            bytesOutput.writeInt32(file.fileContents.length);
            bytesOutput.write(file.fileContents);
        }

        var outputBytes = bytesOutput.getBytes();
        sys.io.File.saveBytes(fileName, outputBytes);
    }

    public static function loadFileSystem(fileName:String) {
        var bytes = sys.io.File.getBytes(fileName);
        var bytesInput = new BytesInput(bytes);

        var header = bytesInput.readString(8);
        if (header != "DYNAMIOS") {
            throw "The file system is not a valid DynamiOS file system.";
        }

        try {
            while (bytesInput.position < bytes.length) {
                var pathLength = bytesInput.readInt32();
                var pathBytes = bytesInput.read(pathLength);
                var path = pathBytes.toString();

                var contentLength = bytesInput.readInt32();
                var contentBytes = bytesInput.read(contentLength);

                storeFile(path, contentBytes);
            }
        } catch (e:Dynamic) {
            throw "The file system is not a valid DynamiOS file system.";
        }
    }

    static function storeFile(path:String, contents:Bytes) {
        // Remove any leading slash so "test.txt" and "/test.txt" are equivalent.
        if(StringTools.startsWith(path, "/"))
            path = path.substr(1);
    
        var parts = path.split("/");
        
        // If the file is in the root (no directory parts)
        if(parts.length == 1) {
            if (!FileSystem.files.exists("/")) {
                FileSystem.files.set("/", new Folder());
            }
            var rootFolder:Folder = cast FileSystem.files.get("/");
            var fileName = parts[0];
            rootFolder.contents.set(fileName, new filesystem.File(fileName, contents));
            return;
        }
        
        // Otherwise, start at the root folder.
        if (!FileSystem.files.exists("/")) {
            FileSystem.files.set("/", new Folder());
        }
        var folder:Folder = cast FileSystem.files.get("/");
        var current:Map<String, FileObj> = folder.contents;
        for (i in 0...parts.length - 1) {
            var folderName = parts[i];
            if (!current.exists(folderName)) {
                current.set(folderName, new Folder());
            }
            var folder:Folder = cast current.get(folderName);
            current = folder.contents;
        }
        var fileName = parts[parts.length - 1];
        current.set(fileName, new filesystem.File(fileName, contents));
    }
    

    static function flattenFiles(input:Array<Dynamic>):Array<FileData> {
        var result:Array<FileData> = [];
        for (item in input) {
            if (Std.isOfType(item, Array)) {
                var arr:Array<Dynamic> = cast item;
                if (arr.length == 2 && Std.isOfType(arr[0], String) && Std.isOfType(arr[1], Bytes)) {
                    result.push({ filePath: arr[0], fileContents: arr[1] });
                } else {
                    result = result.concat(flattenFiles(arr));
                }
            }
        }
        return result;
    }

    static function lookThroughFolders(folder:Folder, basePath:String):Array<Dynamic> {
        var files:Array<Dynamic> = [];
        for (fileName => fileObj in folder.contents) {
            var currentPath = basePath + fileName;
            if (Std.isOfType(fileObj, File)) {
                var file:filesystem.File = cast fileObj;
                files.push([currentPath, file.contents]);
            } else if (Std.isOfType(fileObj, Folder)) {
                var subFolder:Folder = cast fileObj;
                files = files.concat(lookThroughFolders(subFolder, currentPath + "/"));
            }
        }
        return files;
    }
}