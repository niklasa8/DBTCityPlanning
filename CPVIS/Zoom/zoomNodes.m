function zoomNodes(redll,bluell,greenll)
    % redll - röda punkter i matris med två rader.
    % bluell - blå punkter i matris med två rader.
    % greenll - gröna punkter i matris med två rader.

    hold on
    
    hpr = plot(redll(1,:),redll(2,:),'r.');
    hpb = plot(bluell(1,:),bluell(2,:),'.');
    hpg = plot(greenll(1,:),greenll(2,:),'g.');

    % Axlar...
    %axis([0,1,0,1]);
    ax = axis;

    % Ursprunglig punktstorlek.
    set(hpr,'MarkerSize',5/(ax(4)-ax(3)));
    set(hpb,'MarkerSize',5/(ax(4)-ax(3)));
    set(hpg,'MarkerSize',5/(ax(4)-ax(3)));
    
    h = zoom;
    set(h,'ActionPostCallback',@zoomCallBack);
    set(h,'Enable','on');

    % Exekvera denna funktion när det zoomas i figuren.
    function zoomCallBack(~, evd)

        ax = axis(evd.Axes);

        % Ändra storlek på punkterna utifrån de nya axlarna.      
        set(hpr,'MarkerSize',5/(ax(4)-ax(3)));
        set(hpb,'MarkerSize',5/(ax(4)-ax(3)));
        set(hpg,'MarkerSize',5/(ax(4)-ax(3)));
    end
end