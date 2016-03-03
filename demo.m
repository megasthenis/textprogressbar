%% Textprogressbar Examples
% A demonstration of the textprogressbar module.

%% Example 1: Simple bar (Out of the box settings)

% Number of items:
n = 150;

% Initialize progress bar:
upd = textprogressbar(n);

for i = 1:n
    % Perform task:
    pause(0.05);
    % Update progress bar:
    upd(i);
end


%% Example 2: Customized configuration

% Number of items:
n = 150;

% Initialize progress bar with optinal parameters:
upd = textprogressbar(n, 'barlength', 20, ...
                         'updatestep', 10, ...
                         'startmsg', 'Waiting... ',...
                         'endmsg', ' Finally!', ...
                         'showbar', true, ...
                         'showremtime', true, ...
                         'showactualnum', true, ...
                         'barsymbol', '+', ...
                         'emptybarsymbol', '-');
for i = 1:n
   pause(0.05);
   upd(i);
end

%% Example 3: We can even hide the progress bar

% Number of items:
n = 300;

% Initialize progress bar with optinal parameters:
upd = textprogressbar(n, 'barlength', 20, ...
                         'updatestep', 20, ...
                         'startmsg', 'Completed ',...
                         'endmsg', ' Done.', ...
                         'showbar', false, ...
                         'showremtime', true, ...
                         'showactualnum', false, ...
                         'barsymbol', '+', ...
                         'emptybarsymbol', '-');
for i = 1:n
   pause(0.05);
   upd(i);
end

