# textprogressbar
A lightweight, customizable text progress bar to monitor the execution of a long task,
such as a loop with large number of iterations, in Matlab's command line.

###### Careful:
* No printing while using the progress bar.
* When monitoring a loop, if each round is too fast, the bar rendering may incur too much of an overhead. Use the optional `updatestep` parameter to adjust how frequently the bar should be re-rendered.

What does it look like?
-----------------------
![Where is the demo gif?](demo.gif)


Examples
--------
Use the bar right out of the box:
```matlab
n = 150; % the size of the loop (total number of items tracked)

% Initialize progress bar and get handle:
upd = textprogressbar(n);

for i = 1:n
    % Perform a task (Caution! No printing when using the progres bar):
    pause(0.05);
    
    % Update (re-render) the progress bar:
    upd(i);
end
```

or customize it to make life a little better:
```matlab
n = 150;

% Initialize progress bar with optinal parameters:
upd = textprogressbar(n, 'barlength', 20, ...
                         'updatestep', 10, ...
                         'startmsg', 'Waiting... ',...
                         'endmsg', ' Yay!', ...
                         'showbar', true, ...
                         'showremtime', true, ...
                         'showactualnum', true, ...
                         'barsymbol', '+', ...
                         'emptybarsymbol', '-');
for i = 1:n
   pause(0.05);
   upd(i);
end
```

How To Use
----------

Download the source from [here](https://github.com/megasthenis/textprogressbar/archive/master.zip), unzip, and place the extracted folder in your Matlab path (or just place `textprogressbar.m` in your project directory, _i.e.,_ in the same directory as the script that will be using the bar. It might help to also see [here](http://www.mathworks.com/help/matlab/ref/addpath.html?requestedDomain=www.mathworks.com).


Other
-----

### Implementation details
Textprogressbar is implemented using Matlab's nested-function feature: invoking `textprogressbar(n)` initializes and renders an array divided into fixe length blocks (corresponding to the visible segments, e.g., the bar or the percentage of completed items) and returns a handle (pointer) to a nested function which can be used to update and re-render the progress bar.
Certain architectural choices were made to address inconsistencies between the command line of Matlab's -desktop and -nodesktop environment.

_Why not an Object Oriented approach?_ Although Matlab supports an OO architecture, I found it to be much slower compared to the nested-function implementation; the objective is to have a light-weight progress bar that allows monitoring the progress of a long task without incurring a substantial overhead.

### Tested
In OSX and Ubuntu Linux on Matlab 2013b and 2015b.

### Bugs, comments, suggestions?
Shoot me an email at megas@utexas.edu.

