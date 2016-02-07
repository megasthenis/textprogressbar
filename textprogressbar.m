function upd = textprogressbar(n, varargin)
% UPD = TEXTPROGRESSBAR(N) creates a progress bar for monitoring a task 
% comprising N steps, e.g., the N rounds of an iteration. It returns a
% function handle that is used to update and render the progress bar.
%
% Input:
%  n (int): the number of tasks monitored by the progress bar; e.g., the
%           number of rounds of an iteration. Must be positive.
%
% Returns:
%   upd (function): A function used to update/render the progress bar.
%                   The function takes an argument i <= n and renders the
%                   text accordingly.
%
% Optional Parameters:
%   barlength (int): length of the progress bar. Must be positive.
%                    (Default value is 20 characters.)
%   updstep (int): minimum number of progress (update) steps between
%                     consecutive bar re-renderings. This controls how
%                     frequently the bar is rendered to reduce the overhead
%                     due to bar updating. It is especially useful when bar
%                     is used for loops with large number of rounds and
%                     short execution time per round.
%                     (Default value is 10 steps.)
%   startmsg (string): message to be displayed before the progress bar.
%                      (Default is 'Running: '.)
%   endmsg (string): message to be displayed after progress bar.
%                    (Default is ' Done.')
%   showremtime (logical): show an estimate of the remaining time.
%                          (Default is true.)
%   showpercentage (logical): show percentage completed.
%                             (Default is true.)
%   showactualnum (logical): show actual number of items completed.
%                            (Default is false.)
%   showfinaltime (logical): show total running time when completed.
%                            (Default is true.)
%   barsymbol (char): Symbol (character) to be used for the progress bar.
%                     Must be a single character.
%                     (Default is '='.)
%   emptybarsymbol (char): Symbol (character) to be used for the empty
%                          (non-completed) part of the progress bar.
%                          Must be a single character.
%                          (Default is ' '.)
%
% Example:
%
%   n = 150;
%   upd = textprogressbar(n);
%   for i = 1:n
%      pause(0.05);
%      upd(i);
%   end
%

    % Default Parameter values:
    defaultbarCharLen = 20;
    defaultUpdStep = 10;
    defaultstartMsg = 'Running: ';
    defaultendMsg = ' Done.';
    defaultShowremTime = true;
    defaultshowPercentage = true;
    defaultshowActualNum = false;
    defaultshowFinalTime = true;
    defaultbarCharSymbol = '=';
    defaultEmptybarCharSymbol = ' ';
    
    % Auxiliary functions for checking parameter values:
    ischarsymbol = @(c) (ischar(c) && length(c) == 1);
    ispositiveint = @(x) (isnumeric(x) && mod(x, 1) == 0 && x > 0);
 
    % Register input parameters:
    p = inputParser;
    addRequired(p,'n', ispositiveint);
    addParameter(p, 'barlength', defaultbarCharLen, ispositiveint)
    addParameter(p, 'updatestep', defaultUpdStep, ispositiveint)
    addParameter(p, 'startmsg', defaultstartMsg, @ischar)
    addParameter(p, 'endmsg', defaultendMsg, @ischar)
    addParameter(p, 'showremtime', defaultShowremTime, @islogical)
    addParameter(p, 'showpercentage', defaultshowPercentage, @islogical)
    addParameter(p, 'showactualnum', defaultshowActualNum, @islogical)
    addParameter(p, 'showfinaltime', defaultshowFinalTime, @islogical)
    addParameter(p, 'barsymbol', defaultbarCharSymbol, ischarsymbol)
    addParameter(p, 'emptybarsymbol', defaultEmptybarCharSymbol, ischarsymbol)
    
    % Parse input arguments:
    parse(p, n, varargin{:});
    n = p.Results.n;
    barCharLen = p.Results.barlength;
    updStep = p.Results.updatestep;
    startMsg = p.Results.startmsg;
    endMsg = p.Results.endmsg;
    showremTime = p.Results.showremtime;
    showPercentage = p.Results.showpercentage;
    showActualNum = p.Results.showactualnum;
    showFinalTime = p.Results.showfinaltime;
    barCharSymbol = p.Results.barsymbol;
    emptybarCharSymbol = p.Results.emptybarsymbol;
    
    % Initialize progress bar:
    bar = ['[', repmat(emptybarCharSymbol, 1, barCharLen), ']'];
    del_bar = repmat('\b', 1, barCharLen+2);
    
    nextRenderPoint = 0;
    barCharsPrinted = 0;
    startTime = tic;
    remTime = Inf;
    remTimeStr = ' --:--:--';
    percentStr = '   0%';
    
    % Initalize block for actual number of completed items:
    actualNumDigitLen = numel(num2str(n));
    actualNumFormat = sprintf(' %%%dd/%d', actualNumDigitLen, n);
    actualNumStr = sprintf(actualNumFormat, 0);
    
    % Initial render (empty bar):
    fprintf('%s', startMsg);  % Starting message
    fprintf('%s', bar);
    
    if showActualNum
        fprintf('%s', actualNumStr)
    end
    if showPercentage
        fprintf('%s', percentStr);
    end
    if showremTime
       fprintf('%s', remTimeStr);
    end

        % Function to update the status of the progress bar:
        function update(i)

            if i < nextRenderPoint
                return;
            end
            
            nextRenderPoint = min([nextRenderPoint + updStep, n]);
            
            if showremTime
                % Delete remaining time block:
                fprintf(repmat('\b', [1, length(remTimeStr)]));
            end

            if showPercentage
                % Delete percentage block:
                fprintf(repmat('\b', [1, length(percentStr)]));
            end
            
            if showActualNum
                % Delete actual num block:
                fprintf(repmat('\b', [1, length(actualNumStr)]));
            end
    
            % Update progress bar (only if needed):
            barsToPrint = floor( i / n * barCharLen );    
            if barsToPrint > barCharsPrinted
                % Delete progress bar:
                fprintf(del_bar);
                
                % Update bar status:
                bar((2+barCharsPrinted):(1+barsToPrint)) = barCharSymbol;
                barCharsPrinted = barsToPrint;
                
                % Render progress bar:
                fprintf(bar);
            end
            
            % Check if done:
            if i >= n
                fprintf('%s', endMsg);
                
                if showFinalTime
                    fprintf(' [%d seconds]', round(toc(startTime)))
                end
                
                fprintf('\n');
                return;
            end
            
            if showActualNum
                % Delete actual num block:
                actualNumStr = sprintf(actualNumFormat, i);
                fprintf('%s', actualNumStr);
            end
            
            if showPercentage
                % Render percentage block:
                percentage = floor(i / n * 100);
                percentStr = sprintf(' %3d%%', percentage);
                fprintf('%s', percentStr);
            end
                
            % Print remaining time block:
            if showremTime
               t = toc(startTime);
               remTime = t/ i * (n-i);
               remTimeStr = time2str(remTime);
               fprintf('%s', remTimeStr);
            end
            
        end
    
    upd = @update;

end

% Auxiliary functions
function timestr = time2str(t)

    [hh, mm, tt] = sec2hhmmss(t);
    timestr = sprintf(' %02d:%02d:%02d', hh, mm, tt);

end

function [hh, mm, ss] = sec2hhmmss(t)
    hh = floor(t / 3600);
    t = t - hh * 3600;
    mm = floor(t / 60);
    ss = round(t - mm * 60);
end