unit feli_stack_tracer;

{$mode objfpc}

interface
uses fpjson, feli_logger;

type
    FeliStackTracer = class(TObject)
        public
            type
                logger = FeliLogger;
            class procedure trace(kind, name: ansiString); static;
            class procedure reset(); static;
            class procedure out(load: String; newLine: boolean = true); static;
            class procedure breakPoint(); static;
        end;

function simpleSpaceReplaceText(str: ansiString): ansiString;


implementation
uses
    feli_file,
    feli_constants,
    feli_config,
    sysutils;

function simpleSpaceReplaceText(str: ansiString): ansiString;
var
    i: integer;
    tempStr: ansiString;
begin
    tempStr := '';
    
    for i := 1 to length(str) do
        begin
            if ((i - 1) mod 4) = 0  then
                tempStr := tempStr + '|'
            else
                tempStr := tempStr + ' ';
        end;
    
    result := tempStr;
end;

class procedure FeliStackTracer.trace(kind, name: ansiString); static;
var
    tempString, spaces: ansiString;
    i, depth: integer;
    tempDir: ansiString;
    
begin
    if (FeliConfig.getIsDebug()) then begin
        spaces := '';
        tempDir := getTempDir();
        tempString := FeliFileAPI.get(tempDir + stackTraceDepthPath, '0');
        depth := StrToInt(trim(tempString));
        case kind of
            'begin': depth := depth + 1;
            'end': depth := depth - 1;
        end;
        if ((depth - 3) <> 0) then for i := 0 to (depth - 3) do spaces := spaces + '| ';
        case kind of
            'begin': depth := depth + 1;
            'end': depth := depth - 1;
        end;
        tempString := kind;
        if (tempString = 'end') then tempString := ' end ';
        spaces := simpleSpaceReplaceText(spaces);
        writeln(format('%s[%s] %s', [spaces, tempString, name]));
        FeliFileAPI.put(tempDir + stackTraceDepthPath, IntToStr(depth));
    end;
end;

class procedure FeliStackTracer.out(load: String; newLine: boolean = true); static;
var
    tempString, spaces: ansiString;
    i, depth: integer;
    tempDir: ansiString;

begin
    tempDir := getTempDir();
    spaces := '';
    tempString := FeliFileAPI.get(tempDir + stackTraceDepthPath);
    depth := StrToInt(trim(tempString));
    if ((depth - 4) <> 0) then for i := -2 to (depth - 4) do spaces := spaces + '| ';
    if (tempString = 'end') then tempString := ' end ';
    spaces := simpleSpaceReplaceText(spaces);
    if newLine then 
        writeln(format('%s%s', [spaces, load]))
    else
        write(format('%s%s', [spaces, load]));

end;

class procedure FeliStackTracer.reset(); static;
var
    tempDir: ansiString;
begin
    tempDir := getTempDir();
    FeliFileAPI.put(tempDir + stackTraceDepthPath, '1');
end;

class procedure FeliStackTracer.breakPoint(); static;
begin
    if (FeliConfig.getIsDebug()) then
        begin
            FeliStackTracer.out('Break Point Hit. Press Enter to continue', false);
            readln();
        end;
end;


end.