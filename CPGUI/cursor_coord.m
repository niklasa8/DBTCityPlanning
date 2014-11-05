function coordinates = cursor_coord(hObject,eventData,handles)
handles = guidata(hObject);
coordinates = get(gca,'CurrentPoint');
set(handles.text2,'string',{'Cursor Pixels',num2str(coordinates(1,1))...
                               num2str(coordinates(1,2))});                        
end

