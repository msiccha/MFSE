function varargout=custom_msgbox(varargin)
%MSGBOX Message box.
%   msgbox(Message) creates a message box that automatically wraps
%   Message to fit an appropriately sized Figure.  Message is a string
%   vector, string matrix or cell array.
%
%   msgbox(Message,Title) specifies the title of the message box.
%
%   msgbox(Message,Title,Icon) specifies which Icon to display in
%   the message box.  Icon is 'none', 'error', 'help', 'warn', or
%   'custom'. The default is 'none'.
%
%   msgbox(Message,Title,'custom',IconData,IconCMap) defines a
%   customized icon.  IconData contains image data defining the icon;
%   IconCMap is the colormap used for the image.
%
%   msgbox(Message,...,CreateMode) specifies whether a message box is modal
%   or non-modal. Valid values for CreateMode are 'modal', 'non-modal', and
%   'replace'. If CreateMode is 'modal' or 'replace', the first available
%   message box with the specified title is updated to reflect the new
%   properties of the message box. All other such message boxes are deleted.
%   If CreateMode is 'non-modal', the message-box is not replaced and a new
%   handle is created. The default value for CreateMode is 'non-modal'.
%
%   CreateMode may also be a structure with fields WindowStyle and
%   Interpreter.  WindowStyle may be any of the values above.
%   Interpreter may be 'tex' or 'none'.  The default value for the
%   Interpreter is 'none';
%
%   h = msgbox(...) returns the handle of the box in h.
%
%   To make msgbox block execution until the user responds, include the
%   string 'modal' in the input argument list and wrap the call to
%   msgbox with UIWAIT.
%
%   Examples:
%       %An example which blocks execution until the user responds:
%       uiwait(msgbox('String','Title','modal'));
%
%       %An example using a custom Icon is:
%       Data=1:64;Data=(Data'*Data)/64;
%       h=msgbox('String','Title','custom',Data,hot(64))
%
%       %An example which reuses the existing msgbox window:
%       CreateStruct.WindowStyle='replace';
%       CreateStruct.Interpreter='tex';
%       h=msgbox('X^2 + Y^2','Title','custom',Data,hot(64),CreateStruct);
%
%   See also DIALOG, ERRORDLG, HELPDLG, INPUTDLG, LISTDLG,
%            QUESTDLG, TEXTWRAP, UIWAIT, WARNDLG.

%  Copyright 1984-2010 The MathWorks, Inc.

ScreenPos=get(groot, 'ScreenSize');
BodyTextString = varargin{1};

% setup defaults
TitleString=' ';
IconString ='none';
IconData   =[];
IconCMap   =[];
CustomCallback='delete(gcbf)';
Location ='Center';
CreateButton=true;

switch nargin
    case 2
        TitleString=varargin{2};
    case 3
        TitleString=varargin{2};
        IconString=varargin{3};
    case 4
        TitleString=varargin{2};
        IconString=varargin{3};
        IconData = varargin{4};
    case 5
        TitleString=varargin{2};
        IconString=varargin{3};
        IconData=varargin{4};
        CreateButton=varargin{5};       
    case 6
        TitleString=varargin{2};
        IconString=varargin{3};
        IconData =varargin{4};
        CreateButton=varargin{5};        
        CustomCallback=varargin{6};        
    case 7
        TitleString=varargin{2};
        IconString=varargin{3};
        IconData =varargin{4};
        CreateButton=varargin{5};        
        CustomCallback=varargin{6};
        Location=varargin{7};
end

IconString=lower(IconString);
switch(IconString)
    case {'custom'}
        % check for icon data
        if isempty(IconData)
            error(message('MATLAB:msgbox:icondata'))
        end
        if ~isnumeric(IconData)
            error(message('MATLAB:msgbox:IncorrectIconDataType'))
        end
        if ~isnumeric(IconCMap)
            error(message('MATLAB:msgbox:IncorrectIconColormap'))
        end
    case {'none','help','warn','error'}
        % icon String OK
    otherwise
        warning(message('MATLAB:msgbox:iconstring'));
        IconString='none';
end

%%%%%%%%%%%%%%%%%%%%%
%%% Set Positions %%%
%%%%%%%%%%%%%%%%%%%%%
DefFigPos=get(0,'DefaultFigurePosition');

% generate figure
figureHandle=dialog('Name',TitleString,'Pointer','arrow','Units','points','Visible','off','KeyPressFcn',@doKeyPress,'WindowStyle','normal','Toolbar','none','HandleVisibility','on');

Font.FontUnits='points';
Font.FontSize=get(0,'DefaultUicontrolFontSize');
Font.FontName=get(0,'DefaultUicontrolFontName');
Font.FontWeight=get(figureHandle,'DefaultUicontrolFontWeight');
StFont = Font;
StFont.FontWeight=get(figureHandle, 'DefaultTextFontWeight');


FigColor=get(0,'defaultUicontrolBackgroundColor');
MsgTxtBackClr=FigColor;

MsgOff=7;
IconWidth = 32 * 72/get(groot,'ScreenPixelsPerInch');
IconHeight = 32 * 72/get(groot,'ScreenPixelsPerInch');

if strcmp(IconString,'none')
    FigWidth=125;
    MsgTxtWidth=FigWidth-2*MsgOff;
else
    FigWidth=190;
    MsgTxtWidth=FigWidth-2*MsgOff-IconWidth;
end
FigHeight=50;
DefFigPos(3:4)=[FigWidth FigHeight];

if CreateButton
    OKWidth=40;
    OKHeight=17;
else
    OKWidth=0;
    OKHeight=0;
end

AxesHandle=axes('Parent',figureHandle,'Position',[0 0 1 1],'Visible','off');
texthandle = text('Parent',AxesHandle,'Units','points','String',BodyTextString,StFont,'HorizontalAlignment' ,'left','VerticalAlignment','bottom','Interpreter','tex','Tag','MessageBox');

textExtent = get(texthandle, 'Extent');
MsgTxtWidth=textExtent(3);
MsgTxtHeight=textExtent(4);

if ~strcmp(IconString,'none')
    MsgTxtXOffset=IconWidth+2*MsgOff;
    FigWidth=MsgTxtXOffset+MsgTxtWidth+MsgOff;
    IconXOffset=MsgOff;
    % Center Vertically around icon
    if IconHeight>MsgTxtHeight
        IconYOffset=OKHeight+2*MsgOff;
        MsgTxtYOffset=IconYOffset+(IconHeight-MsgTxtHeight)/2;
        FigHeight=IconYOffset+IconHeight+MsgOff;
        % center around text
    else
        MsgTxtYOffset=OKHeight+2*MsgOff;
        IconYOffset=MsgTxtYOffset+(MsgTxtHeight-IconHeight)/2;
        FigHeight=MsgTxtYOffset+MsgTxtHeight+MsgOff;
    end
else
    FigWidth=MsgTxtWidth+2*MsgOff;
    MsgTxtYOffset=+OKHeight+2*MsgOff;
    FigHeight=MsgTxtYOffset+MsgTxtHeight+MsgOff;
    MsgTxtXOffset=MsgOff;        
end

if CreateButton
    OKXOffset=(FigWidth-OKWidth)/2;
    OKYOffset=MsgOff;
    okPos = [ OKXOffset OKYOffset OKWidth OKHeight];
    OKHandle=uicontrol(figureHandle,Font,'Style','pushbutton','Units','points','Position',okPos,'Callback',CustomCallback,'KeyPressFcn',@doKeyPress,'String',getString(message('MATLAB:uistring:popupdialogs:OK')),'HorizontalAlignment','center','Tag','OKButton');
    set(OKHandle,'Position',[OKXOffset OKYOffset OKWidth OKHeight]);
end

MsgTxtHeight=FigHeight-MsgOff-MsgTxtYOffset;
MsgTxtForeClr=[0 0 0];
DefFigPos(3:4)=[FigWidth FigHeight];
% insert placement here
set(figureHandle,'Position',DefFigPos);

txtPos = [ MsgTxtXOffset MsgTxtYOffset 0 ];
set(texthandle, 'Position',txtPos);

set(figureHandle,'Units','pixel');
FigPos=get(figureHandle,'Position');

if ~strcmp(Location,'Center')
    switch Location
        case 'NorthWest'
            DefFigPos(1)=50;
            DefFigPos(2)=ScreenPos(4)-FigPos(4)-50;                           
        case 'NorthEast'
            DefFigPos(1)=ScreenPos(3)-FigPos(3)-50;
            DefFigPos(2)=ScreenPos(4)-FigPos(4)-50;                           
        case 'SouthWest'
            DefFigPos(1)=50;
            DefFigPos(2)=50;            
        case 'SouthEast'
            DefFigPos(1)=ScreenPos(3)-FigPos(3)-50;
            DefFigPos(2)=50;
    end
else
    DefFigPos(1)=(ScreenPos(3)-FigPos(3))/2;
    DefFigPos(2)=(ScreenPos(4)-FigPos(4))/2;    
end
    DefFigPos(3:4)=FigPos(3:4);
set(figureHandle,'Position',DefFigPos);

%IconYOffset=FigHeight-MsgOff-IconHeight;

if ~strcmp(IconString,'none')
    % create an axes for the icon
    iconPos = [IconXOffset IconYOffset IconWidth IconHeight];
    IconAxes=axes(                                   ...
        'Parent'          ,figureHandle               , ...
        'Units'           ,'points'                , ...
        'Position'        ,iconPos                 , ...
        'Tag'             ,'IconAxes'                ...
        );

    if ~strcmp(IconString,'custom')
        % Cases where IconString will be one of 'help','warn' or 'error'
        Img = setupStandardIcon(IconAxes, IconString);        
    else
        % place the icon - if this fails, rethrow the error
        % after deleting the figure
        try
            Img=image('CData',IconData,'Parent',IconAxes);
            set(figureHandle, 'Colormap', IconCMap);
        catch ex
            delete(figureHandle);
            rethrow(ex);
        end
    end
    if ~isempty(get(Img,'XData')) && ~isempty(get(Img,'YData'))
        set(IconAxes          , ...
            'XLim'            ,get(Img,'XData')+[-0.5 0.5], ...
            'YLim'            ,get(Img,'YData')+[-0.5 0.5]  ...
            );
    end

    set(IconAxes          , ...
        'Visible'         ,'off'       , ...
        'YDir'            ,'reverse'     ...
        );

end % if ~strcmp

% make sure we are on screen
movegui(figureHandle)
set(figureHandle,'HandleVisibility','callback','Visible','on');

% make sure the window gets drawn even if we are in a pause
drawnow
if nargout==1
    varargout{1}=figureHandle;
end

end

%%%%% doKeyPress
function doKeyPress(obj, evd)
    switch(evd.Key)
        case {'return','space','escape'}
            delete(ancestor(obj,'figure'));
    end
end

function Img = setupStandardIcon(ax, iconName)
[iconData, alphaData] = matlab.ui.internal.dialog.DialogUtils.imreadDefaultIcon(iconName);  
Img=image('CData',iconData,'Parent',ax);
if ~isempty(alphaData)
    set(Img, 'AlphaData', alphaData)
end
end
