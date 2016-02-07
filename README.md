# textprogressbar
A (hopefully lightweight) text progress bar to monitor the execution of a long task,
such as a loop with large number of iterations, in Matlab's command line.

##### Careful:
* No printing while using the progress bar.
* When monitoring a loop, if each round is too fast, the bar rendering may incur too much of an overhead. Use the optional `updatestep` parameter to adjust how frequently the bar should be re-rendered.

## Examples

This is a simple example using textprogressbar to track the progress of a loop:
```matlab
n = 150; % the size of the loop (total number of steps tracked).

% Initialize progress bar and get handle:
upd = textprogressbar(n);

for i = 1:n
    % Perform a task (Caution! No printing when using the progres bar):
    pause(0.05);
    
    % Update (re-render) the progress bar:
    upd(i);
end
```
And a second example, customizing the progress bar:
```matlab
n = 150;
% Initialize progress bar with optinal parameters:
upd = textprogressbar(n, 'barlength', 20, ...
                         'updatestep', 10, ...
                         'startmsg', 'Waiting... ',...
                         'endmsg', ' Yay!', ...
                         'showremtime', false, ...
                         'barsymbol', '+', ...
                         'emptybarsymbol', '-');
for i = 1:n
   pause(0.05);
   upd(i)
end
```

## Other

### Implementation details
Textprogressbar is implemented using Matlab's nested-function feature: invoking `textprogressbar(n)` initializes and renders an empty progress bar and returns a handle (pointer) to a nested function which can be used to update the status and re-render the progress bar.

_Why not an Object Oriented approach?_ 
Although Matlab supports an OO architecture, I found it to be much slower compared to the nested-function implementation; the objective is to have a light-weight progress bar that allows monitoring the progress of a long task without incurring a substantial overhead.