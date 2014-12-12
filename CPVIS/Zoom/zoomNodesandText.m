function zoomNodesandText(h_ax,h_nodes)

    % h_ax - handle till kartans axlar.
    % h_nodes - handle till samtliga noder i plotten.
    
    ax = axis(h_ax);

    % Ursprunglig punktstorlek.
    set(h_nodes,'MarkerSize',min([35,1/(ax(4)-ax(3))]));
    % Text och ursprunglig textposition.
    h_text = text('String',' © OpenStreetMaps bidragsgivare ','FontSize',7);
    set(h_text,'Position',[ax(2), ax(3)],'HorizontalAlignment','left','VerticalAlignment','bottom');
    set(h_text,'BackgroundColor','white','Margin',1,'Rotation',90);
    h_p = pan;
    set(h_p,'ActionPostCallback',@panCallBack);
    set(h_p,'Enable','on');
    % Exekvera denna funktion när det panas i figuren.
    function panCallBack(~, evd)

        ax = axis(evd.Axes);

        % Ändra storlek på punkterna utifrån de nya axlarna.
        set(h_nodes,'MarkerSize',min([35,1/(ax(4)-ax(3))]));
        % Ändra textens position utifrån de nya axlarna.
        set(h_text,'Position',[ax(2), ax(3)]);
    end
    
    h_z = zoom;
    set(h_z,'ActionPostCallback',@zoomCallBack);
    set(h_z,'Enable','on');
    % Exekvera denna funktion när det zoomas i figuren.
    function zoomCallBack(~, evd)

        ax = axis(evd.Axes);

        % Ändra storlek på punkterna utifrån de nya axlarna.
        set(h_nodes,'MarkerSize',min([35,0.75/(ax(4)-ax(3))]));
        % Ändra textens position utifrån de nya axlarna.
        set(h_text,'Position',[ax(2), ax(3)]);
    end
end
