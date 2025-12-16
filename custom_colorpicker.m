function varargout = custom_colorpicker(varargin)
% custom_colorpicker MATLAB code for custom_colorpicker.fig
%      custom_colorpicker, by itself, creates a new custom_colorpicker or raises the existing
%      singleton*.
%
%      H = custom_colorpicker returns the handle to a new custom_colorpicker or the handle to
%      the existing singleton*.
%
%      custom_colorpicker('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in custom_colorpicker.M with the given input arguments.
%
%      custom_colorpicker('Property','Value',...) creates a new custom_colorpicker or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before custom_colorpicker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to custom_colorpicker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help custom_colorpicker

% Last Modified by GUIDE v2.5 09-Dec-2025 14:45:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @custom_colorpicker_OpeningFcn, ...
                   'gui_OutputFcn',  @custom_colorpicker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function custom_colorpicker_OpeningFcn(hObject, ~, handles, varargin)
global Col
global Systemdata
guidata(hObject, handles);

%% error check varargin
OldCol=[0.5 0.5 0.5];
if nargin>3
    if isnumeric(varargin{1})
        OldCol=cell2mat(varargin);
    end
end

handles.OldC.BackgroundColor=OldCol;
handles.NewC.BackgroundColor=OldCol;

Col=OldCol;
r = (0:120)'/120;
theta = pi*(-120:120)/120;
X = r*cos(theta);
Y = r*sin(theta);
C = zeros(size(X));

Systemdata.ColorWheel=zeros([size(X),3]);
H=linspace(0,1,size(X,2));
S=linspace(0,1,numel(r));
V=zeros(numel(r),1);
V(:)=1;
Systemdata.ColorWheel(:,:,1)=repmat(H,numel(r),1);
Systemdata.ColorWheel(:,:,2)=repmat(S',1,size(X,2));
Systemdata.ColorWheel(:,:,3)=repmat(V,1,size(X,2));
p=pcolor(X,Y,C,'Parent',handles.axes1);
set (p,'LineStyle','none','CDataMapping','direct','FaceColor','texturemap');

p.CData=hsv2rgb(Systemdata.ColorWheel);
handles.axes1.Color=[0.91 0.91 0.91];
handles.axes1.XAxis.Visible='off';
handles.axes1.YAxis.Visible='off';
uiwait(handles.figure1);

function Intensity_Callback(hObject, ~, handles)
global Systemdata

V=zeros(size(Systemdata.ColorWheel,1),1);
V(:)=hObject.Value;
Systemdata.ColorWheel(:,:,3)=repmat(V,1,size(Systemdata.ColorWheel,2));
handles.axes1.Children.CData=hsv2rgb(Systemdata.ColorWheel);


function varargout = custom_colorpicker_OutputFcn(~, ~, ~) 
global Col;
varargout{1} = Col;

function OK_Callback(~, ~, handles)
global Col
Col=handles.NewC.BackgroundColor;
delete(handles.figure1);

function Cancel_Callback(~, ~, handles)
global Col
Col=handles.OldC.BackgroundColor;
delete(handles.figure1);

function figure1_WindowButtonMotionFcn(hObject, ~, handles)
loc=get(hObject, 'CurrentPoint');
loc=loc-[170,330];
loc=sqrt(loc(1)^2+loc(2)^2);
if loc<=150
    handles.figure1.Pointer='cross';
else
    handles.figure1.Pointer='arrow';
end

function figure1_WindowButtonDownFcn(hObject, ~, handles)
if strcmp(handles.figure1.Pointer,'cross')
    loc=get(hObject, 'CurrentPoint');
    loc=loc-[170,330];    
    R=sqrt(loc(1)^2+loc(2)^2);
    h=(atan2(loc(2),loc(1))+pi())/(2*pi());
    sv=handles.Intensity.Value;
    handles.NewC.BackgroundColor=hsv2rgb(h,R/150,sv);  
end
