# textprogressbar
A text progress bar for Matlab's command window.

## Examples

This is a simple example using textprogressbar to track the progress of a loop.
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

## Other

### Implementation details
Textprogressbar is implemented using Matlab's nested-function feature: invoking `textprogressbar(n)` initializes and renders an empty progress bar and returns a handle (pointer) to a nested function which can be used to update the status and re-render the progress bar.
Why not an Object Oriented approach? Although Matlab supports an OO architecture, I found it to be much slower compared to the nested-function implementation; the objective is to have a light-weight progress bar that allows monitoring the progress of a long task without incurring a substantial overhead.