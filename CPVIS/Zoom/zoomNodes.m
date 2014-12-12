function zoomNodes(h_ax,h_nodes)
    % h_ax - handle till kartans axlar.
    % h_nodes - handle till samtliga noder i plotten.

    ax = axis(h_ax);

    % Ursprunglig punktstorlek.
    set(h_nodes,'MarkerSize',min([35,1/(ax(4)-ax(3))]));
        
    h_z = zoom;
    set(h_z,'ActionPostCallback',@zoomCallBack);
    set(h_z,'Enable','on');
    % Exekvera denna funktion när det zoomas i figuren.
    function zoomCallBack(~, evd)

        ax = axis(evd.Axes);

        % Ändra storlek på punkterna utifrån de nya axlarna.
        set(h_nodes,'MarkerSize',min([35,1/(ax(4)-ax(3))]));
    end
end
