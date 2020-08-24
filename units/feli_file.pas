unit feli_file;

{$mode objfpc}

interface

uses 
    fpjson,
    jsonparser;

type 
    FeliFileAPI = class(TObject)
    public
        class function get(path: ansiString; defaultValue: ansiString = ''): ansiString; static;
        class procedure put(path, payload: ansiString); static;
        class procedure debug; static;
    end;



implementation
uses
    feli_logger,
    feli_constants,
    sysutils;



class function FeliFileAPI.get(path: ansiString; defaultValue: ansiString = ''): ansiString; static;
var
    f: TextFile;
    line, all_lines: ansiString;

begin
    all_lines := defaultValue;
    if not FileExists(path) then 
        begin
            result := all_lines;
        end 
    else 
        begin
            assign(f, path);
            reset(f);

            while not eof(f) do
                begin
                    readln(f, line);
                    all_lines := all_lines + line + lineSeparator;
                end;
            
            close(f);
            result := all_lines;
        end;
end;

class procedure FeliFileAPI.put(path, payload: ansiString); static;
var
    f: TextFile;
begin
    if not FileExists(path) then FileCreate(path);    
    
    assign(f, path);
    rewrite(f);
    writeln(f, payload);
    close(f);
end;

class procedure FeliFileAPI.debug; static;
begin
    FeliLogger.info(format('[FeliFileAPI.debug]', []));
end;

end.
