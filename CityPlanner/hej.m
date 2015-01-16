% Example of transfering data from one figure to another
function hej(h)
%clear all 
%close all
    %h = axes;    % The axes we want to transfer to

    od = openfig('umea_map.fig','reuse','invisible');  % Load our saved figure
    %get(get(x,'CurrentAxes'))
    % This command displays all the options we can
    %   transfer over, for this example, I'll just transfer the data
    datahandles = get(get(od,'CurrentAxes'),'Children');
    for ii = 1:length(datahandles)
        set(datahandles(ii),'Parent',h);
    end

    % Close the other figure
    close(od)
end