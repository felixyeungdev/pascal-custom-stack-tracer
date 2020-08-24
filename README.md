# Pascal Custom Stack Tracer
Custom Stack Tracer is intended to be used during development only,
logic and code behind Custom Stack Tracer could be quite messy,
but it does it's job during development

## Demo
### Stack Tracer Turned Off
![alt text][demo-off]

### Stack Tracer Turned On
![alt text][demo-on]

[demo-off]: demo-off.png "Stack Tracer Off"
[demo-on]: demo-on.png "Stack Tracer On"


## Usage
### Initialise
Add `demo.cfg` to project root with file content of
```jsonc
{
    "application-terminal-log": boolean, // true for enabling saving logs from FeliLogger
    "debug": boolean // true for enabling stack tracer
}
```

### To Use
Add following code between after `begin` and before `end`, replace string with your own identifier, for example the function/procedure name
```pascal
 FeliStackTrace.trace('begin', string);
 
 // Your code

 FeliStackTrace.trace('end', string);
```

### Reset
Reset FeliStackTrace before use with
```pascal
FeliStackTrace.reset();
```
put this after the main begin
```pascal
begin
    FeliStackTrace.reset();
    // Your code
end.
```

----

> Note: `begin` should follow with `end`
