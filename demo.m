%% Example 1: Simple bar (Default options)
disp('Example 1: Simple bar')

n = 150;

% Initialize progress bar and get handle:
upd = textprogressbar(n);

for i = 1:n
    % Perform task:
    pause(0.05);
    
    % Update progress bar using handle:
    upd(i);
end

%% Example 2: Custom bar (Setting optional parameters)
disp('Example 2: The bar is customizable...')

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


%% Example 3: Outside a loop.
disp('Example 3: I can use it outside a loop too...')

n = 100;
% Initialize progress bar:
upd = textprogressbar(n, 'showremtime', false);

% Perform some tasks;
pause(1);
upd(n/10);
pause(1);
upd(2*n/10);

% And then some more:
pause(2);
upd(5*n/10);
pause(1);
upd(n);
