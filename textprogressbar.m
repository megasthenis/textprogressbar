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
%   updatestep (int): minimum number of progress (update) steps between
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
    defaultBarLength = 20;
    defaultUpdStep = 10;
    defaultStartMsg = 'Running: ';
    defaultEndMsg = ' Done.';
    defaultShowRemTime = true;
    defaultShowPercentage = true;
    defaultShowActualNum = false;
    defaultShowFinalTime = true;
    defaultBarSymbol = '=';
    defaultEmptyBarSymbol = ' ';
    
    % Auxiliary functions for checking parameter values:
    ischarsymbol = @(c) (ischar(c) && length(c) == 1);
    ispositiveint = @(x) (isnumeric(x) && mod(x, 1) == 0 && x > 0);
 
    % Register input parameters:
    p = inputParser;
    addRequired(p,'n', ispositiveint);
    addParameter(p, 'barlength', defaultBarLength, ispositiveint)
    addParameter(p, 'updatestep', defaultUpdStep, ispositiveint)
    addParameter(p, 'startmsg', defaultStartMsg, @ischar)
    addParameter(p, 'endmsg', defaultEndMsg, @ischar)
    addParameter(p, 'showremtime', defaultShowRemTime, @islogical)
    addParameter(p, 'showpercentage', defaultShowPercentage, @islogical)
    addParameter(p, 'showactualnum', defaultShowActualNum, @islogical)
    addParameter(p, 'showfinaltime', defaultShowFinalTime, @islogical)
    addParameter(p, 'barsymbol', defaultBarSymbol, ischarsymbol)
    addParameter(p, 'emptybarsymbol', defaultEmptyBarSymbol, ischarsymbol)
    
    % Parse input arguments:
    parse(p, n, varargin{:});
    n = p.Results.n;
    barlength = p.Results.barlength;
    updatestep = p.Results.updatestep;
    startmsg = p.Results.startmsg;
    endmsg = p.Results.endmsg;
    showremtime = p.Results.showremtime;
    showpercentage = p.Results.showpercentage;
    showactualnum = p.Results.showactualnum;
    showfinaltime = p.Results.showfinaltime;
    barsymbol = p.Results.barsymbol;
    emptybarsymbol = p.Results.emptybarsymbol;
    
    % Initialize progress bar:
    bar = ['[', repmat(emptybarsymbol, 1, barlength), ']'];
    del_bar = repmat('\b', 1, barlength+2);
    
    next_render = 0;
    bars_printed = 0;
    starttime = tic;
    remtime = Inf;
    remtime_str = ' --:--:--';
    percentage_str = '   0%';
    
    actualnumdigits = numel(num2str(n));
    actualnumformat = sprintf(' %%%dd/%d', actualnumdigits, n);
    actualnum_str = sprintf(actualnumformat, 0);
    
    % Initial render (empty bar):
    fprintf('%s', startmsg);  % Starting message
    fprintf('%s', bar);
    if showactualnum
        fprintf('%s', actualnum_str)
    end
    if showpercentage
        fprintf('%s', percentage_str);
    end
    if showremtime
       fprintf('%s', remtime_str);
    end

        % Function to update the status of the progress bar:
        function update(i)

            if i < next_render
                return;
            end
            
            next_render = min([next_render + updatestep, n]);
            
            if showremtime
                % Delete remaining time block:
                fprintf(repmat('\b', [1, length(remtime_str)]));
            end

            if showpercentage
                % Delete percentage block:
                fprintf(repmat('\b', [1, length(percentage_str)]));
            end
            
            if showactualnum
                % Delete actual num block:
                fprintf(repmat('\b', [1, length(actualnum_str)]));
            end
    
            % Update progress bar if needed:
            bars = floor( i / n * barlength );    
            if bars > bars_printed
                % Delete progress bar:
                fprintf(del_bar);
                
                % Update bar status:
                bar((2+bars_printed):(1+bars)) = barsymbol;
                bars_printed = bars;
                
                % Render progress bar:
                fprintf(bar);
            end
            
            % Check if done:
            if i >= n
                fprintf('%s', endmsg);
                
                if showfinaltime
                    fprintf(' [%d seconds]', round(toc(starttime)))
                end
                
                fprintf('\n');
                return;
            end
            
            if showactualnum
                % Delete actual num block:
                actualnum_str = sprintf(actualnumformat, i);
                fprintf('%s', actualnum_str);
            end
            
            if showpercentage
                % Render percentage block:
                percentage = floor(i / n * 100);
                percentage_str = sprintf(' %3d%%', percentage);
                fprintf('%s', percentage_str);
            end
                
            % Print remaining time block:
            if showremtime
               t = toc(starttime);
               remtime = t/ i * (n-i);
               remtime_str = time2str(remtime);
               fprintf('%s', remtime_str);
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