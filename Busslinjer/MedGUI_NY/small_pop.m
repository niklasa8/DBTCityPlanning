function small_pop(hObject,handles,pop);
    %contents = get(pop,'String'); 
    content = get(pop,'Value');
    set(pop,'Value',content);
    guidata(hObject, handles);