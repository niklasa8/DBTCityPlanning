function [c,cont]=color_pop(hObject,handles,pop);%hObject,eventData,
handles = guidata(hObject);
contents = get(pop,'String'); 
cont= get(pop,'Value');
content = contents{cont};
switch content

    case 'Yellow'
        c='y';
    case 'Red'
        c='r';
    case 'Green'
        c='g';
    case 'Orange'
        c=[1.0 0.4 0.0];
    case 'Blue'
        c='b';
    case 'Cyan'
        c='c';
    case 'Magenta'
        c='m';
    case 'Brown'
        c=[0.5 0.0 0.0];
    case 'Purple'
        c=[0.7 0.0 1.0];
    case 'Grey'
        c=[0.5714 0.5714 0.5714];
    case 'Pink'
        c=[1.0000 0 0.5000];
    case 'Black' 
        c='k';
    case 'White'
        c='w';

guidata(hObject,handles);
end


    
