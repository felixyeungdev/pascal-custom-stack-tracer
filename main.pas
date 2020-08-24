program main;

{$mode objfpc}


uses
    feli_stack_tracer,
    sysutils;


var
    firstNum, secondNum: double;
    resultNum: double;
    hasError: boolean;

procedure test2();
begin
    FeliStackTracer.trace('begin', 'procedure test2();');
    
    FeliStackTracer.logger.info('Note: This procedure is useless');
    if (Random(2) < 1) then
        FeliStackTracer.logger.error('Random between 0 and 1 resulted in 0, bad')
    else
        FeliStackTracer.logger.success('Random between 0 and 1 resulted in 1, good');

    FeliStackTracer.trace('end', 'procedure test2();');
end;

procedure test();
begin
    FeliStackTracer.trace('begin', 'procedure test();');

    FeliStackTracer.logger.log('Nothing to see here');
    FeliStackTracer.logger.info('Note: This uselss procedure calls another useless procedure');
    test2();

    FeliStackTracer.trace('end', 'procedure test();');
end;


function divideNumByNum(num1, num2: real; var hasError: boolean): real;
begin
    FeliStackTracer.trace('begin', 'function divideNumByNum(num1, num2: real; var hasError: boolean): real;');

    FeliStackTracer.logger.info('Note: divideNumByNum calls a useless procedure');
    test();
    hasError := false;
    try
        result := num1 / num2;
    except
        on E: Exception do
        begin
            FeliStackTracer.logger.error(E.message);
            hasError := true;
        end;
    end;

    FeliStackTracer.trace('end', 'function divideNumByNum(num1, num2: real; var hasError: boolean): real;');
end;

begin
    FeliStackTracer.reset();
    FeliStackTracer.trace('begin', 'main');
    Randomize();
    FeliStackTracer.logger.info('Feli Stack Tracer Demo');
    
    {
        Equation 50 / 25
        Expected result = 2
    }

    firstNum := 50;
    secondNum := 25;

    FeliStackTracer.logger.info(format('Attemping to divide %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    resultNum := divideNumByNum(firstNum, secondNum, hasError);
    if (not hasError) then
        FeliStackTracer.logger.success(format('Result Number is %s', [FloatToStr(resultNum)]))
    else
        FeliStackTracer.logger.error(format('Error while dividing %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    
    
    FeliStackTracer.breakPoint();

    {
        Equation 25 / 0
        Expected error = Division by zero
    }
    
    firstNum := 25;
    secondNum := 0;

    FeliStackTracer.logger.info(format('Attemping to divide %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));
    resultNum := divideNumByNum(firstNum, secondNum, hasError);
    if (not hasError) then
        FeliStackTracer.logger.debug(format('Result Number is %s', [resultNum]))
    else
        FeliStackTracer.logger.error(format('Error while dividing %s by %s', [FloatToStr(firstNum), FloatToStr(secondNum)]));


    FeliStackTracer.trace('end', 'main');
    readln();
end.