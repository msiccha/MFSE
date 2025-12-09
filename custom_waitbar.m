<<<<<<< HEAD
function h = custom_waitbar(String,cancel,CancelFunc)
if cancel
    h = waitbar(0,String,'DockControls','off','Resize','off','Visible','off','Color',get(0,'defaultUicontrolBackgroundColor'),'CreateCancelBtn',CancelFunc);
    set(h.Children(2).Title,'FontName',get(0,'DefaultUicontrolFontName'),'FontSize',get(0,'DefaultUicontrolFontSize'));
else
    h = waitbar(0,String,'DockControls','off','Resize','off','Visible','off','Color',get(0,'defaultUicontrolBackgroundColor'));
    set(h.Children.Title,'FontName',get(0,'DefaultUicontrolFontName'),'FontSize',get(0,'DefaultUicontrolFontSize'));
end
h.Visible='on';
waitbar(0,h);
end

=======
function h = custom_waitbar(String,cancel,CancelFunc)
if cancel
    h = waitbar(0,String,'DockControls','off','Resize','off','Visible','off','Color',get(0,'defaultUicontrolBackgroundColor'),'CreateCancelBtn',CancelFunc);
    set(h.Children(2).Title,'FontName',get(0,'DefaultUicontrolFontName'),'FontSize',get(0,'DefaultUicontrolFontSize'));
else
    h = waitbar(0,String,'DockControls','off','Resize','off','Visible','off','Color',get(0,'defaultUicontrolBackgroundColor'));
    set(h.Children.Title,'FontName',get(0,'DefaultUicontrolFontName'),'FontSize',get(0,'DefaultUicontrolFontSize'));
end
h.Visible='on';
waitbar(0,h);
end

>>>>>>> 61e6384e4a8c693c52892cc7529d68f3154c5178
