program main;

{$mode objfpc}


uses
    feli_stack_tracer,
    feli_logger,
    sysutils;


var
    firstNum, secondNum: double;
    resultNum: double;
    hasError: boolean;

procedure test2();
begin
    FeliStackTrace.trace('begin', 'procedure test2();');
    
    FeliLogger.info('Note: This procedure is useless');
    if (Random(2) < 1) then
        FeliLogger.error('Random between 0 and 1 resulted in 0, bad')
    else
        FeliLogger.success('Random between 0 and 1 resulted in 1, good');

    FeliStackTrace.trace('end', 'procedure test2();');
end;

procedure test();
begin
    FeliStackTrace.trace('begin', 'procedure test();');

    FeliLogger.log('Nothing to see here');
    FeliLogger.info('Note: This uselss procedure calls another useless procedure');
    test2();

    FeliStackTrace.trace('end', 'procedure test();');
end;


function divideNumByNum(num1, num2: real; var hasError: boolean): real;
begin
    FeliStackTrace.trace('begin', 'function divideNumByNum(num1, num2: real; var hasError: boolean): real;');

    FeliLogger.info('Note: divideNumByNum calls a useless procedure');
    test();
    hasError := false;
    try
        result := num1 / num2;
    except
        on E: Exception do
        begin
            FeliLogger.error(E.message);
            hasError := true;
        end;
    end;

    FeliStackTrace.trace('end', 'function divideNumByNum(num1, num2: real; var hasError: boolean): real;');
end;

begin
    FeliStackTrace.reset();
    FeliStackTrace.trace('begin', 'main');
    Randomize();

    FeliLogger.info('Feli Stack Tracer Demo');
    
    {
        Equation 50 / 25
        Expected result = 2
    }

    firstNum := 50;
    secondNum := 25;

    FeliLogger.info(format('Attemping to divide %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    resultNum := divideNumByNum(firstNum, secondNum, hasError);
    if (not hasError) then
        FeliLogger.success(format('Result Number is %s', [FloatToStr(resultNum)]))
    else
        FeliLogger.error(format('Error while dividing %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    
    
    FeliStackTrace.breakPoint();

    {
        Equation 25 / 0
        Expected error = Division by zero
    }
    
    firstNum := 25;
    secondNum := 0;

    FeliLogger.info(format('Attemping to divide %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    resultNum := divideNumByNum(firstNum, secondNum, hasError);
    if (not hasError) then
        FeliLogger.debug(format('Result Number is %s', [resultNum]))
    else
        FeliLogger.error(format('Error while dividing %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));


    FeliStackTrace.trace('end', 'main');
    readln();
end.