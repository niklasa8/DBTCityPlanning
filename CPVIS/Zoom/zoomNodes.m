function zoomNodes(redll,bluell,greenll)
    % redll - r�da punkter i matris med tv� rader.
    % bluell - bl� punkter i matris med tv� rader.
    % greenll - gr�na punkter i matris med tv� rader.

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

    % Exekvera denna funktion n�r det zoomas i figuren.
    function zoomCallBack(~, evd)

        ax = axis(evd.Axes);

        % �ndra storlek p� punkterna utifr�n de nya axlarna.      
        set(hpr,'MarkerSize',5/(ax(4)-ax(3)));
        set(hpb,'MarkerSize',5/(ax(4)-ax(3)));
        set(hpg,'MarkerSize',5/(ax(4)-ax(3)));
    end
end