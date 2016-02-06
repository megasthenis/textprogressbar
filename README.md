# textprogressbar
A text progress bar for Matlab's command window.

```matlab
n = 150;

% Initialize progress bar and get handle:
upd = textprogressbar(n);

for i = 1:n
    % Perform task:
    pause(0.05);
    
    % Update progress bar using handle:
    upd(i);
end
```
