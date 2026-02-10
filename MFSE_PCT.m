%%% MATLAB GUI GENERATION FUNCTIONS %%%
function varargout = MFSE_PCT(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MFSE_PCT_OpeningFcn, ...
    'gui_OutputFcn',  @MFSE_PCT_OutputFcn, ...
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

function MFSE_PCT_OpeningFcn(hObject, ~, handles, varargin)
global data
global patches %#ok<*NUSED>
global cali
global system
global jtableobj
global TableHandle

set(groot,'defaultUicontrolBackgroundColor',[0.91 0.91 0.91]);
set(groot,'defaultUicontrolFontName','Century gothic');
set(groot,'defaultUIControlFontSize',11);
set(groot,'defaultUitableFontName','Century gothic');
set(groot,'defaultUitableFontSize',11);
set(groot,'defaultAxesFontName','Century gothic');
set(groot,'defaultTextFontName','Century gothic');
set(groot,'defaultTextFontSize',11);
set(groot,'defaultUipanelFontName','Century gothic');
set(groot,'defaultUipanelFontSize',11);

system.temp.Cancel=false;
system.temp.current_load_path=[pwd '\'];
system.temp.current_save_path=[pwd '\'];

data.header.Projectname='';
data.header.Dimensions=[0 0 0];
data.header.Voxelsize=1;
data.header.Comment='none';

system.corollary.patch_margin=0.5;
system.corollary.light_ambient=0.5;
system.corollary.light_specular=0;
system.corollary.light_diffuse=0.75;
system.corollary.colormap=lines(4096);
system.corollary.normal_gaussian_parms=[3,3,3,0.65];
system.corollary.smooth_gaussian_parms=[5,5,5,3];

handles.output = hObject;
guidata(hObject, handles);
axis off

function varargout = MFSE_PCT_OutputFcn(~, ~, handles)
varargout{1} = handles.output;
%place_GUI_element(handles.MFSE_PCTWindow,1)

function MFSE_PCTWindow_CloseRequestFcn(hObject, ~, ~) %#ok<*DEFNU>
delete(hObject);

function MFSE_PCTWindow_DeleteFcn(~, ~, ~)

%%% Menu functions %%%

function show_manual_Callback(~, ~, ~)
winopen('MFSE_Manual.pdf')

function show_tutorial_Callback(~, ~, ~)
winopen('MFSE_Tutorial.pdf')

%%% general GUI functions %%%
function populate_table(handles,retain_selection)
global data
global system

dummytable=cell(size(data.Labeltable,1),16);
dummytable(:,1)=cellstr(num2str(data.Labeltable.Label));
dummytable(:,2)=num2cell(data.Labeltable.Active);
dummytable(:,3)=cellstr(num2str(data.Labeltable.MorphoUnit));
dummytable(:,4)=cellstr(num2str(data.Labeltable.Layer));
dummytable(:,5)=data.Labeltable.Class;
dummytable(:,6)=data.Labeltable.Group;
dummytable(:,7)=data.Labeltable.Type;
dummytable(:,8)=data.Labeltable.Name;
dummytable(:,9)=cellstr('normal'); % Visu normal
dummytable(:,10)=num2cell(system.TempLabeltable.show); % show
dummytable(:,11)=num2cell(data.Labeltable.Patches);
dummytable(:,12)=cellstr(num2str(data.Labeltable.Volume));
dummytable(:,13)=cellstr(num2str(round(data.Labeltable.PrimaryAxis,2),3));
dummytable(:,14)=cellstr(num2str(round(data.Labeltable.Solidity,3),4));
dummytable(:,15)=cellstr(num2str(round(data.Labeltable.Extent,3),4));
dummytable(:,16)=cellstr(num2str(round(system.TempLabeltable.Distance,2),3));
handles.total_labels.String=num2str(size(data.Labeltable,1));
handles.active_labels.String=num2str(sum(data.Labeltable.Active));
handles.morphounits.String=num2str(numel(unique(data.Labeltable.MorphoUnit))-1);
handles.MainTable.Data=dummytable;
if ~retain_selection
    system.selected_patches=false(size(data.Labeltable.Label,1),1);
    handles.selected_labels.String=[];
end

function ingest_Seg_structure (Seg,MFSEsystem,handles)
global data
global cali
global system
global jtableobj

data=Seg;
system=MFSEsystem;

populate_table(handles,false);
handles.projectname.String=data.header.Projectname;
handles.dimensions.String=[num2str(data.header.Dimensions(1)) ' / ' num2str(data.header.Dimensions(2)) ' / ' num2str(data.header.Dimensions(3))];
handles.shellsource.String=data.header.BasicShellSegmentationSource;
handles.labelsource.String=data.header.PrimaryLumenSegmentationSource;
handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
handles.comment.String=data.header.Comment;

handles.Show_shell.Value=0;
handles.shell_color.Enable='on';
handles.shell_opacity.Enable='on';
handles.save_msd.Enable='on';
system.selected_patches=false(size(data.Labeltable.Label,1),1);
populate_graph(handles);
handles.Axes.View=system.temp.view;
camlight (cali,'headlight');
handles.SPI_panel.Visible='on';
handles.MC_panel.Visible='on';
handles.SH_panel.Visible='on';
handles.PLA_panel.Visible='on';
handles.ALA_panel.Visible='on';
handles.LO_panel.Visible='on';
handles.LD_panel.Visible='on';
handles.MA_panel.Visible='on';
jtableobj=findjobj(handles.MainTable);

function main_table_CellEditCallback(~, eventdata, handles)
global patches
global data
global system
global jtableobj

cheat={'off' 'on'};
Label=str2num(handles.MainTable.Data{eventdata.Indices(1),1});
cname=['L' num2str(Label,'%04u')];
curTpos=jtableobj.getVerticalScrollBar.getValue;
switch eventdata.Indices(2)
    case 2  % status active
        data.Labeltable.Active(data.Labeltable.Label==Label)=eventdata.EditData;
        if ~eventdata.EditData
            handles.MainTable.Data{eventdata.Indices(1),10}=false;
            patches.(cname).Visible='off';
            handles.active_labels.String=num2str(sum(data.Labeltable.Active));
        end
    case 3  % Morphological unit
        data.Labeltable.MorphoUnit(data.Labeltable.Label==Label)=str2num(eventdata.EditData);
    case 5  % Class
        data.Labeltable.Class(data.Labeltable.Label==Label)={eventdata.EditData};
    case 6  % Group
        data.Labeltable.Group(data.Labeltable.Label==Label)={eventdata.EditData};
    case 7  % Type
        data.Labeltable.Type(data.Labeltable.Label==Label)={eventdata.EditData};
    case 8  % Name
        data.Labeltable.Name(data.Labeltable.Label==Label)={eventdata.EditData};
    case 9 % display type
        if strcmp(eventdata.NewData,'voxels')
            ec=color_mod(system.corollary.colormap(Label,:),0.25,'darker');
        else
            ec='none';
        end
        patches=rmfield(patches,cname);
        delete(findobj(handles.Axes,'Tag',cname));
        patches.(cname)=patch(handles.Axes,data.patchdata.(cname).(eventdata.NewData),'Tag',cname,'FaceColor',system.corollary.colormap(Label,:),'ButtonDownFcn',@patchhittest,'EdgeColor',ec,'FaceLighting','gouraud','SpecularStrength',0,'AmbientStrength',0.5,'DiffuseStrength',0.75,'Visible',cheat{handles.MainTable.Data{eventdata.Indices(1),2}+1}); %'BackFaceLighting','lit'
    case 10 % to show or not to show
        patches.(cname).Visible=cheat{eventdata.EditData+1};
        system.TempLabeltable.show(system.TempLabeltable.Label==Label)=eventdata.EditData;
end
jtableobj.getVerticalScrollBar.setValue(curTpos);

function main_table_CellSelectionCallback(~, eventdata, handles)
global patches
global data
global system
global jtableobj

if system.temp.hit_from_patch
    selected_labels=handles.MainTable.Data(jtableobj.getViewport.getView.getSelectedRows+1,1);
    if size(selected_labels,1)>1
        s=num2str(selected_labels{1});
        for k=2:size(selected_labels,1)
            s=[s ' ' num2str(selected_labels{k})]; %#ok<AGROW>
        end
        handles.selected_labels.String=s;
    else
        if ~isempty(selected_labels)
            handles.selected_labels.String=num2str(selected_labels{1});
        end
    end
else
    selected_labels=handles.MainTable.Data(unique(eventdata.Indices(:,1)));
    if size(selected_labels,1)>0
        if size(selected_labels,1)>1
            s=num2str(selected_labels{1});
            for k=2:size(selected_labels,1)
                s=[s ' ' num2str(selected_labels{k})]; %#ok<AGROW>
            end
            handles.selected_labels.String=s;
        else
            handles.selected_labels.String=selected_labels{1};
        end
        
        currently_selected=data.Labeltable.Label(system.selected_patches);
        to_be_flagged=str2num(cell2mat(selected_labels));
        
        patches_to_flag=to_be_flagged(~ismember(to_be_flagged,currently_selected));
        patches_to_unflag=currently_selected(~ismember(currently_selected,to_be_flagged));
        
        for i=1:numel(patches_to_flag)
            system.selected_patches(data.Labeltable.Label==patches_to_flag(i))=true;
            cname=['L' num2str(patches_to_flag(i),'%04u')];
            patches.(cname).EdgeColor=[0 0 0];
        end
        for i=1:numel(patches_to_unflag)
            system.selected_patches(data.Labeltable.Label==patches_to_unflag(i))=false;
            cname=['L' num2str(patches_to_unflag(i),'%04u')];
            patches.(cname).EdgeColor='none';
        end
    end
end
system.temp.hit_from_patch=false;

function comment_Callback(hObject, ~, handles)
global data
data.header.Comment=hObject.String;
update_header(handles)

function progress_check(handles)

if any(handles.DI_status.BackgroundColor&[0 1 0])
    handles.BSS_from_RAW.Enable='on';
    handles.CL_from_RAW.Enable='on';
else
    handles.BSS_from_RAW.Enable='off';
    handles.CL_from_RAW.Enable='off';
end

if ~isempty(handles.shellsource.String)
    handles.BSS_validate.Enable='on';
else
    handles.BSS_validate.Enable='off';
end

if ~isempty(handles.labelsource.String)
    handles.CL_validate.Enable='on';
else
    handles.CL_validate.Enable='off';
end

if any(handles.BSS_status.BackgroundColor&[0 1 0])
    handles.createCL.Enable='on';
else
    handles.createCL.Enable='off';
end

if any(handles.PN_status.BackgroundColor&handles.DI_status.BackgroundColor&handles.BSS_status.BackgroundColor&handles.CL_status.BackgroundColor&[0 1 0])
    handles.Create.Enable='on';
else
    handles.Create.Enable='off';
end

function PN_enter_Callback(~, ~, handles)
global data

prompt = {'Please enter a valid project name:'};
dlgtitle = 'Project information';
fieldsize = [1 100];
definput = {data.header.Projectname};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
if ~isempty(answer)
    if ~isempty(regexp(answer{1}, '[/\*:?"<>|]', 'once'))
        % error message
    else
        data.header.Projectname=answer{1};
        handles.projectname.String=data.header.Projectname;
        handles.PN_status.BackgroundColor=[0 1 0];
    end
    progress_check(handles)
end

function DI_enter_Callback(~, ~, handles)
global data

prompt = {'Enter length of segmentation data in X dimension [vx]:','Enter length of segmentation data in Y dimension [vx]:','Enter length of segmentation data in Z dimension [vx]:','Enter cubic resolution [µm]:'};
dlgtitle = 'Dimensional information';
fieldsize = [1 60; 1 60; 1 60;1 60];

definput = {num2str(data.header.Dimensions(1)),num2str(data.header.Dimensions(2)),num2str(data.header.Dimensions(3)),num2str(data.header.Voxelsize)};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
if ~isempty(answer)
    if isnumeric(str2num(answer{1}))&&isnumeric(str2num(answer{2}))&&isnumeric(str2num(answer{3}))&&isnumeric(str2num(answer{4}))
        dimensions=[str2num(answer{1}) str2num(answer{2}) str2num(answer{3})];
        if any(dimensions<2)||any(dimensions>2000)
            % error not expected size
        else
            voxelsize=str2num(answer{4});
            if isnumeric(voxelsize)&&voxelsize>0
                data.header.Dimensions=dimensions;
                data.header.Voxelsize=voxelsize;
                handles.dimensions.String=[answer{1} ' / ' answer{2} ' / ' answer{3}];
                handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
                handles.DI_status.BackgroundColor=[0 1 0];
            else
                % error voxelsize
            end
        end
        
        
    else
        % error not numeric
    end
end
progress_check(handles)

function BSS_from_GIPL_Callback(~, ~, handles)
global system
global data

pathname=system.temp.current_load_path;
[BSfilename, pathname] = uigetfile({'*.gipl'},'Select a file containing the basic shell segmentation in GIPL format',pathname);
if isequal(BSfilename,0) || isequal(pathname,0)
    return
else
    handles.BSS_status.BackgroundColor=[1 0 0];
    handles.CL_status.BackgroundColor=[1 0 0];
    h=custom_msgbox('Please wait a few seconds...loading data','','none',[],false);
    [V,~]=load_gipl(fullfile(pathname, BSfilename));
    % check for incongruency
    data.BSS=logical(V);
    sliderdim=size(V,3);
    set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
    imagesc(handles.Axes,data.BSS(:,:,round(sliderdim/2)));
    axis(handles.Axes,'off');
    handles.shellsource.String=BSfilename;
    handles.image_data_selector.String='Shell segmentation';
    system.temp.current_load_path=pathname;
    handles.imageslider.Visible='on';
end
delete(h);
progress_check(handles)

function imageslider_Callback(hObject, ~, handles)
global data
if size(handles.image_data_selector.String,1)>1
    selection=handles.image_data_selector.String{handles.image_data_selector.Value,:};
else
    selection=handles.image_data_selector.String;
end
switch selection
    case 'Shell segmentation'
        imagesc(handles.Axes,data.BSS(:,:,round(hObject.Value)))
    case 'Lumen labels'
        imagesc(handles.Axes,data.PCL(:,:,round(hObject.Value)))
end
axis(handles.Axes,'off');

function BSS_from_RAW_Callback(~, ~, handles)
global data
global system

pathname=system.temp.current_load_path;
[BSfilename, pathname] = uigetfile({'*.raw'},'Select a binary file containing the basic shell segmentation',pathname);
if isequal(BSfilename,0) || isequal(pathname,0)
    return
else
    datatypelist={'int8','int16','uint8','uint16'};
    [dtindx,dt] = listdlg('PromptString',{'Select the binary data type',''},'SelectionMode','single','ListString',datatypelist);
    dataorderlist={'Little-endian','Big-endian'};
    [doindx,do] = listdlg('PromptString',{'Select the binary data byte order type',''},'SelectionMode','single','ListString',dataorderlist);
    if dt&&do
        handles.BSS_status.BackgroundColor=[1 0 0];
        handles.CL_status.BackgroundColor=[1 0 0];
        h=custom_msgbox('Please wait a few seconds...loading data','','none',[],false);
        fid=fopen(fullfile(pathname, BSfilename),'r');
        V=fread(fid,datatypelist{dtindx}, lower(dataorderlist{doindx}(1)));
        fclose (fid);
        V=reshape(V,data.header.Dimensions);
        data.BSS=logical(V);
        sliderdim=size(V,3);
        set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
        imagesc(handles.Axes,data.BSS(:,:,round(sliderdim/2)));
        axis(handles.Axes,'off');
        handles.shellsource.String=BSfilename;
        handles.image_data_selector.String='Shell segmentation';
        system.temp.current_load_path=pathname;
        handles.imageslider.Visible='on';
        delete(h);
    else
        return
    end
end
progress_check(handles)

function BSS_validate_Callback(~, ~, handles)
handles.BSS_status.BackgroundColor=[0 1 0];
progress_check(handles);

function CL_from_GIPL_Callback(~, ~, handles)
global system
global data

pathname=system.temp.current_load_path;
[CLfilename, pathname] = uigetfile({'*.gipl'},'Select a file containing the primary chamber label segmentation in GIPL format',pathname);
if isequal(CLfilename,0) || isequal(pathname,0)
    return
else
    handles.CL_status.BackgroundColor=[1 0 0];
    [V,Header]=load_gipl(fullfile(pathname, CLfilename));
    % check for incongruency
    data.PCL=logical(V);
    sliderdim=size(V,3);
    set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
    imagesc(handles.Axes,data.PCL(:,:,round(sliderdim/2)))
    if ~contains(handles.image_data_selector.String,'Lumen lables')
        handles.image_data_selector.String={handles.image_data_selector.String; 'Lumen lables'};
    end
    handles.image_data_selector.Value=find(strcmp(handles.image_data_selector.String,'Lumen labels'));
    system.temp.current_load_path=pathname;
end
progress_check(handles);

function CL_from_RAW_Callback(~, ~, handles)
global data
global system

pathname=system.temp.current_load_path;
[CLfilename, pathname] = uigetfile({'*.raw'},'Select a file containing the primary chamber label segmentation in RAW format',pathname);
if isequal(CLfilename,0) || isequal(pathname,0)
    return
else
    datatypelist={'int8','int16','uint8','uint16'};
    [dtindx,dt] = listdlg('PromptString',{'Select the binary data type',''},'SelectionMode','single','ListString',datatypelist);
    dataorderlist={'Little-endian','Big-endian'};
    [doindx,do] = listdlg('PromptString',{'Select the binary data byte order type',''},'SelectionMode','single','ListString',dataorderlist);
    if dt&&do
        handles.CL_status.BackgroundColor=[1 0 0];
        h=custom_msgbox('Please wait a few seconds...loading data','','none',[],false);
        fid=fopen(fullfile(pathname, CLfilename),'r');
        V=fread(fid,datatypelist{dtindx}, lower(dataorderlist{doindx}(1)));
        fclose (fid);
        V=reshape(V,data.header.Dimensions);
        handles.labelsource.String=CLfilename;
        data.PCL=V;
        labels=unique(V);
        labels(labels==0)=[];
        handles.total_labels.String=num2str(numel(labels));
        sliderdim=size(V,3);
        set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
        imagesc(handles.Axes,data.PCL(:,:,round(sliderdim/2)))
        if ~contains(handles.image_data_selector.String,'Lumen labels')
            handles.image_data_selector.String={handles.image_data_selector.String; 'Lumen labels'};
        end
        handles.image_data_selector.Value=find(strcmp(handles.image_data_selector.String,'Lumen labels'));
        handles.imageslider.Visible='on';
        system.temp.current_load_path=pathname;
    else
        return
    end
end
delete(h);
progress_check(handles);

function CL_validate_Callback(~, ~, handles)
handles.CL_status.BackgroundColor=[0 1 0];
progress_check(handles);

function import_ITK_Labels_MenuCallback(~, ~, handles)

function import_GIPL_MenuCallback(~, ~, handles)
global data
global system

[filename, pathname] = uigetfile('*.gipl','Select a segmentation data file');
if isequal(filename,0) || isequal(pathname,0)
    return
else
    h=custom_msgbox('Please wait a few seconds...loading data','','none',[],false);
    old_Labeltable=data.Labeltable;
    data=rmfield(data,{'Shell' 'volumedata','Labeltable'});
    info=gipl_read_header(fullfile(pathname, filename));
    [V] = gipl_read_volume(info);
    labellist=unique(V);
    delete (h)
    h=custom_waitbar('Please wait...generating shell patch',[],false);
    labellist(labellist==0)=[]; % delete empty label
    labellist(labellist==65535)=[]; % delete shell label
    Shell=V;
    Shell(Shell~=65535)=0;
    Shell=logical(Shell);
    data.basicshell.Shell_binary=Shell;
    
    SubVsm=smooth3(Shell*10,'gaussian');
    data.basicshell.volumedata=isosurface(SubVsm,0.975);
    
    C=regionprops3(Shell,'Centroid','Volume');
    data.basicshell.Centroid=C.Centroid(C.Volume==max(C.Volume),:);
    data.basicshell.ShellParms=struct;
    data.basicshell.Volume=max(C.Volume);
    data.current_center=C.Centroid(C.Volume==max(C.Volume),:);
    delete(h);
    
    h=custom_waitbar('Please wait...generating chamber lumen patches',[],false);
    data.Primarylabelfield=V;
    data.Primarylabelfield(data.Primarylabelfield==65535)=0;
    
    for i=1:numel(labellist)
        SubV=V;
        SubV(SubV~=labellist(i))=0;
        SubV=logical(SubV);
        SubVsm=smooth3(SubV*10,'gaussian');
        fv=isosurface(SubVsm,0.975);
        s=regionprops3(SubV,'Volume','Centroid','Extent','PrincipalAxisLength','Orientation', 'Solidity','SurfaceArea');
        maxvol=find(s.Volume==max(s.Volume),1,'first');
        Dataentry=s(maxvol,1:7); %#ok<FNDSB>
        Dataentry(1,8)={labellist(i)};
        Dataentry(1,9)={''};
        Dataentry(1,10)={pdistance(s.Centroid,C.Centroid)};
        Dataentry(1,11)={true(1,1)};
        Dataentry(1,12)={true(1,1)};
        Dataentry(1,13)={false(1,1)};
        Dataentry(1,14)={size(s,1)};
        Dataentry(1,15)={[]};
        Dataentry(1,16)={[]};
        Dataentry(1,17)={[]};
        Dataentry(1,18)={[]};
        Dataentry(1,19)={NaN(1,1)};
        Dataentry(1,20)={NaN(1,1)};
        data.Datatable(i,:)=Dataentry;
        data.patchdata.(['L' num2str(labellist(i),'%04u')])=fv;
        waitbar(i/numel(labellist),h);
    end
    data.Labeltable.Properties.VariableNames={'Volume','Centroid','Extent','PrincipalAxisLength','Orientation','Solidity','SurfaceArea','Label','Name','distance','active','show','show_overlay','patches','externa_cutoff','smoothed','appendages_removed','porespace_filled','ShellWidth','ShellDensity'};
    for i=1:size(data.Labeltable,1)
        if any(ismember(old_Labeltable.Label,data.Labeltable.Label(i)))
            data.Labeltable.Name(i)=old_Labeltable.Name(ismember(old_Labeltable.Label,data.Labeltable.Label(i)));
            data.Labeltable.Active(i)=old_Labeltable.Active(ismember(old_Labeltable.Label,data.Labeltable.Label(i)));
            data.Labeltable.show(i)=old_Labeltable.show(ismember(old_Labeltable.Label,data.Labeltable.Label(i)));
        end
    end
    cla(handles.Axes);
    populate_graph(handles);
    handles.total_labels.String=num2str(size(data.Labeltable,1));
    handles.Active_labels.String=num2str(sum(data.Labeltable.Active));
    populate_table(handles,false);
    delete (h)
    h=custom_msgbox({['Segmentation data file ' filename ' has been reimported'];'All labels (including the shell) have been overwritten and derived parameters been reset!'},'','none',[],true);
end

function [Volume,Header]=load_gipl(filename)

f=fopen(filename,'rb','ieee-be');
offset=256; % header size
%get the file size
fseek(f,0,'eof');
fsize = ftell(f);
fseek(f,0,'bof');

sizes=fread(f,4,'ushort')';
if(sizes(4)==1)
    maxdim=3;
else
    maxdim=4;
end
sizes=sizes(1:maxdim);
image_type=fread(f,1,'ushort');
scales=fread(f,4,'float')';
scales=scales(1:maxdim);
patient=fread(f,80, 'uint8=>char')';
matrix=fread(f,20,'float')';
orientation=fread(f,1, 'uint8')';
par2=fread(f,1, 'uint8')';
voxmin=fread(f,1,'double');
voxmax=fread(f,1,'double');
origin=fread(f,4,'double')';
origin=origin(1:maxdim);
pixval_offset=fread(f,1,'float');
pixval_cal=fread(f,1,'float');
interslicegap=fread(f,1,'float');
user_def2=fread(f,1,'float');
magic_number= fread(f,1,'uint');
if (magic_number~=4026526128)
    error('file corrupt - or not big endian');
end

if(image_type==1)
    voxelbits=1;
elseif(image_type==7||image_type==8)
    voxelbits=8;
elseif(image_type==15||image_type==16)
    voxelbits=16;
elseif(image_type==31||image_type==32||image_type==64)
    voxelbits=32;
elseif(image_type==65)
    voxelbits=64;
end

datasize=prod(sizes)*(voxelbits/8);
fseek(f,fsize-datasize,'bof');
volsize(1:3)=sizes;

if(image_type==1)
    Volume = logical(fread(f,datasize,'bit1'));
elseif(image_type==7)
    Volume = int8(fread(f,datasize,'char'));
elseif(image_type==8)
    Volume = uint8(fread(f,datasize,'uchar'));
elseif(image_type==15)
    Volume = int16(fread(f,datasize,'short'));
elseif(image_type==16)
    Volume = uint16(fread(f,datasize,'ushort'));
elseif(image_type==31)
    Volume = uint32(fread(f,datasize,'uint'));
elseif(image_type==32)
    Volume = int32(fread(f,datasize,'int'));
elseif(image_type==64)
    Volume = single(fread(f,datasize,'float'));
elseif(image_type==65)
    Volume = double(fread(f,datasize,'double'));
end

fclose(f);
Volume = reshape(Volume,volsize);
Header=struct('filename',filename,'filesize',fsize,'sizes',sizes,'scales',scales,'image_type',image_type,'patient',patient,'matrix',matrix,'orientation',orientation,'voxel_min',voxmin,'voxel_max',voxmax,'origing',origin,'pixval_offset',pixval_offset,'pixval_cal',pixval_cal,'interslicegap',interslicegap,'user_def2',user_def2,'par2',par2,'offset',offset);

function d=pdistance(C1,C2)
d=sqrt(double((C1(1)-C2(1))^2+(C1(2)-C2(2))^2+(C1(3)-C2(3))^2));

function Create_Callback(~, ~, handles)
global system
global data

default=[data.header.Projectname  '_raw'];
[filename, pathname] = uiputfile('*.msd','Save segmentation project as',fullfile(system.temp.current_save_path,default));
if isequal(filename,0) || isequal(pathname,0)
    return
else
            
    system.current_save_path=pathname;
    
    segmentation=struct();
    segmentation.header.Projectname=data.header.Projectname;
    handles.projectname.String=segmentation.header.Projectname;
    segmentation.header.Voxelsize=data.header.Voxelsize;
    segmentation.header.Dimensions=data.header.Dimensions;
    segmentation.header.Comment=handles.comment.String;
    segmentation.header.BasicShellSegmentationSource=handles.shellsource.String;
    segmentation.header.PrimaryLumenSegmentationSource=handles.labelsource.String;
    
    segmentation.Labeltable=table;
    segmentation.Labelfield=zeros([data.header.Dimensions 1],'uint16');
    segmentation.Labelfield(:,:,:,1)=uint16(data.PCL);
    h=custom_waitbar('Please wait...generating shell patch',[],false);
    
    Shell=data.BSS;
    segmentation.basicshell.Binary=data.BSS;
    SubVsm=smooth3(double(Shell),'gaussian');
    segmentation.basicshell.patchdata=isosurface(SubVsm,system.corollary.patch_margin);
    C=regionprops3(Shell,'Centroid','Volume');
    segmentation.basicshell.Centroid=C.Centroid(C.Volume==max(C.Volume),:);
    system.temp.current_center=segmentation.basicshell.Centroid;
    delete(h);
    
    h=custom_waitbar('Please wait...generating chamber lumen patches',[],false);
    labellist=unique(segmentation.Labelfield(:,:,:,1));
    temp_distance=zeros(numel(labellist)-1,1);
    for i=2:numel(labellist)
        labelname=['L' num2str(labellist(i),'%04u')];
        SubV=data.PCL;
        SubV(SubV~=labellist(i))=0;
        SubV=logical(SubV);
        SubVsm=smooth3(SubV,'gaussian',system.corollary.normal_gaussian_parms(1:3),system.corollary.normal_gaussian_parms(4)); % default is size 3 sd 0.65
        fv=isosurface(SubVsm,system.corollary.patch_margin);
        segmentation.patchdata.(labelname).normal=fv;
        SubVsm=smooth3(SubV,'gaussian',system.corollary.smooth_gaussian_parms(1:3),system.corollary.smooth_gaussian_parms(4));
        fv=isosurface(SubVsm,system.corollary.patch_margin);
        segmentation.patchdata.(labelname).smoothed=fv;
        s=regionprops3(SubV,'Volume','Centroid','Extent','PrincipalAxisLength','ConvexVolume', 'Solidity','SurfaceArea','EquivDiameter','Orientation');
        distSubV=bwdist(SubV);
        distSubV(distSubV~=1)=0;
        sd=regionprops3(distSubV,'VoxelList');
        v=[];
        f=[];
        for k=1:size(sd,1)
            [vert, fac] = voxel_image(sd.VoxelList{k});
            v=[v;vert]; %#ok<AGROW>
            f=[f;fac]; %#ok<AGROW>
        end
        segmentation.patchdata.(labelname).voxels.vertices=v;
        segmentation.patchdata.(labelname).voxels.faces=f;
        maxvol=find(s.Volume==max(s.Volume),1,'first');
        Dataentry(1,1)={labellist(i)}; % Label
        if any(contains(fieldnames(data),'ITable'))
            idx=data.ITable.Label==labellist(i);
            if any(idx)
                Dataentry(1,2)={data.ITable.active(idx)}; % Active
                Dataentry(1,3)={data.ITable.MorphoUnit(idx)}; % MorphoUnit
                Dataentry(1,4)={1}; % Layer
                Dataentry(1,5)=data.ITable.Class(idx); % Class
                Dataentry(1,6)=data.ITable.Group(idx); % Group
                Dataentry(1,7)=data.ITable.Type(idx); % Type
                Dataentry(1,8)=data.ITable.Name(idx); % Name
            else
                Dataentry(1,2)={true(1,1)}; % Active
                Dataentry(1,3)={0}; % MorphoUnit
                Dataentry(1,4)={1}; % Layer
                Dataentry(1,5)={'Unclassified'}; % Class
                Dataentry(1,6)={''}; % Group
                Dataentry(1,7)={''}; % Type
                Dataentry(1,8)={''}; % Name
            end
        else
            Dataentry(1,2)={true(1,1)}; % Active
            Dataentry(1,3)={0}; % MorphoUnit
            Dataentry(1,4)={1}; % Layer
            Dataentry(1,5)={'Unclassified'}; % Class
            Dataentry(1,6)={''}; % Group
            Dataentry(1,7)={''}; % Type
            Dataentry(1,8)={''}; % Name
        end
        temp_distance(i-1)=pdistance(s.Centroid(maxvol,:),system.temp.current_center);
        segmentation.Labeltable(i-1,:)=Dataentry;
        segmentation.volumedata.(labelname).Patches=size(s,1);
        segmentation.volumedata.(labelname).Volume=s.Volume(maxvol);
        segmentation.volumedata.(labelname).Centroid=s.Centroid(maxvol,:);
        segmentation.volumedata.(labelname).PrincipalAxisLength=s.PrincipalAxisLength(maxvol,:);
        segmentation.volumedata.(labelname).Orientation=s.Orientation(maxvol,:);
        segmentation.volumedata.(labelname).SurfaceArea=s.SurfaceArea(maxvol);
        segmentation.volumedata.(labelname).Solidity=s.Solidity(maxvol);
        segmentation.volumedata.(labelname).Extent=s.Extent(maxvol);
        segmentation.volumedata.(labelname).ConvexVolume=s.ConvexVolume(maxvol);
        segmentation.volumedata.(labelname).Extent=s.Extent(maxvol);
        segmentation.volumedata.(labelname).EquivDiameter=s.EquivDiameter(maxvol);
        waitbar(i/numel(labellist),h);
    end
    delete (h);
    
    segmentation.Labeltable.Properties.VariableNames=[{'Label'},{'Active'},{'MorphoUnit'},{'Layer'},{'Class'},{'Group'},{'Type'},{'Name'}];
    system.TempLabeltable=table;
    system.TempLabeltable.Label=segmentation.Labeltable.Label;
    system.TempLabeltable.show=true(numel(labellist)-1,1);
    system.TempLabeltable.selected=false(numel(labellist)-1,1);
    system.TempLabeltable.Distance=temp_distance;
    
    segmentation.display=system.corollary; %#ok<STRNU>
    
    save(fullfile(pathname, filename),'segmentation','-mat','-v7.3');
    custom_msgbox(['Segmentation data file ' regexprep(filename,'_','\\_') ' has been created'],'','none',[],true);
end

function update_header(handles)
global data

if any(contains(fieldnames(data),'ITable'))       
    handles.total_labels.String=num2str(size(data.ITable,1));
    handles.active_labels.String=num2str(sum(data.ITable.active));
    handles.classes.String=num2str(numel(unique(data.ITable.Class))- strcmp(unique(data.ITable.Class(:)),''));
    handles.groups.String=num2str(numel(unique(data.ITable.Group))- strcmp(unique(data.ITable.Group(:)),''));
    handles.types.String=num2str(numel(unique(data.ITable.Type))- strcmp(unique(data.ITable.Type(:)),''));
    handles.morphounits.String=num2str(sum((unique(data.ITable.MorphoUnit)>0))); 
end

function all_from_MSD_Callback(~, ~, handles)
global data
global system

pathname=system.temp.current_load_path;
[filename, pathname] = uigetfile({'*.msd'},'Select a segmentation data file',pathname);
if isequal(filename,0) || isequal(pathname,0)
    return
else
    system.temp.current_load_path=pathname;
    X=load(fullfile(pathname, filename),'-mat');
    Xnames=fieldnames(X);
    if contains(Xnames,'Seg')
        data.header.Projectname=filename(1:end-4);
        data.header.Voxelsize=X.Seg.header.Voxelsize;
        data.header.Dimensions=size(X.Seg.primary_shell.Binary);
        handles.shellsource.String='Legacy MSD file';
        handles.labelsource.String='Legacy MSD file';
        data.BSS=X.Seg.primary_shell.Binary;
        data.PCL=X.Seg.Labelfield;
        data.ITable=table;
        data.ITable.Label=X.Seg.Labeltable.Label;
        data.ITable.active=X.Seg.Labeltable.active;
        data.ITable.MorphoUnit=X.Seg.Labeltable.MorphoUnit;
        data.ITable.Layer(:)=1;
        data.ITable.Class(:)={''};
        data.ITable.Group(:)={''};
        data.ITable.Type(:)={''};
        data.ITable.Name=X.Seg.Labeltable.Name;
        % show MU and active
        for i=1:size(data.ITable,1)
            handles.Maintable.Data(i,1)={data.ITable.Label(i)};
            handles.Maintable.Data(i,2)={data.ITable.active(i)};
            handles.Maintable.Data(i,3)={data.ITable.MorphoUnit(i)};
            handles.Maintable.Data(i,4)={1};
            handles.Maintable.Data(i,8)=data.ITable.Name(i);
        end
    elseif contains(Xnames,'D')
        data.header.Projectname=filename(1:end-4);
        data.header.Voxelsize=X.D.Voxelsize;
        data.header.Dimensions=size(X.D.Shell.Shell_binary);
        handles.shellsource.String='Legacy MSD file';
        handles.labelsource.String='Legacy MSD file';
        data.BSS=X.D.Shell.Shell_binary;
        data.PCL=X.D.Labelfield;
        data.ITable=table;
        data.ITable.Label=X.D.Datatable.Label;
        data.ITable.active=X.D.Datatable.active;
        data.ITable.MorphoUnit(:)=0;
        data.ITable.Layer(:)=1;
        data.ITable.Class(:)={''};
        data.ITable.Group(:)={''};
        data.ITable.Type(:)={''};
        data.ITable.Name=X.D.Datatable.Name;
        % show MU and active
        for i=1:size(data.ITable,1)
            handles.Maintable.Data(i,1)={data.ITable.Label(i)};
            handles.Maintable.Data(i,2)={data.ITable.active(i)};
            handles.Maintable.Data(i,3)={0};
            handles.Maintable.Data(i,4)={1};
            handles.Maintable.Data(i,8)=data.ITable.Name(i);
        end
    end
    labels=unique(data.PCL);
    labels(labels==0)=[];
    handles.total_labels.String=num2str(numel(labels));
    sliderdim=size(data.PCL,3);
    set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
    imagesc(handles.Axes,data.PCL(:,:,round(sliderdim/2)))
    handles.projectname.String=data.header.Projectname;
    handles.dimensions.String=[num2str(data.header.Dimensions(1)) ' / ' num2str(data.header.Dimensions(2)) ' / ' num2str(data.header.Dimensions(3))];
    handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
    handles.DI_status.BackgroundColor=[0 1 0];
    handles.PN_status.BackgroundColor=[0 1 0];
    handles.image_data_selector.String={'Shell segmentation'; 'Lumen labels'};
    handles.image_data_selector.Value=2;
    handles.imageslider.Visible='on';
    handles.LabelPanel.Visible='on';
    system.temp.current_load_path=pathname;
end
update_header(handles);
progress_check(handles);

function DI_from_GIPL_Callback(~, ~, handles)
global data
global system

pathname=system.temp.current_load_path;
[BSfilename, pathname] = uigetfile({'*.gipl'},'Select a GIPL with the segmentation project dimensional information',pathname);
if isequal(BSfilename,0) || isequal(pathname,0)
    return
else
    [~,Header]=load_gipl(fullfile(pathname, BSfilename));
    dummy=strsplit(BSfilename,{' '});
    projectname=strtrim(dummy{1});
    data.header.Projectname=projectname;
    handles.projectname.String=data.header.Projectname;
    handles.PN_status.BackgroundColor=[0 1 0];
    data.header.Dimensions=Header.sizes;
    data.header.Voxelsize=Header.scales(1);
    handles.dimensions.String=[num2str(Header.sizes(1)) ' / ' num2str(Header.sizes(2)) ' / ' num2str(Header.sizes(3))];
    handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
    handles.DI_status.BackgroundColor=[0 1 0];
    system.temp.current_load_path=pathname;
end
progress_check(handles);

function image_data_selector_Callback(~, ~, handles)
global data
if numel(handles.image_data_selector.String)>1
    str=handles.image_data_selector.String{handles.image_data_selector.Value,:};
else
    str=handles.image_data_selector.String;
end
switch str
    case 'Shell segmentation'
        imagesc(handles.Axes,data.BSS(:,:,round(handles.imageslider.Value)))
    case 'Lumen labels'
        imagesc(handles.Axes,data.PCL(:,:,round(handles.imageslider.Value)))
end

function DI_from_header_Callback(~, ~, handles)
global data
global system

pathname=system.temp.current_load_path;
[filename, pathname] = uigetfile('*.*','Select a file containing the project name, dimensions, resolution in the file name',pathname);
if isequal(filename,0) || isequal(pathname,0)
    return
else
    try
        dummy=strsplit(filename,{' '});
        projectname=strtrim(dummy{1});
        dummy=strsplit(filename,{'[' ']'});
        info=dummy{2};
        dummy=strsplit(info,'-');
        dummy2=strsplit(dummy{1},'x');
        dimensions=[str2num(dummy2{1}) str2num(dummy2{2}) str2num( dummy2{3})];
        dummy2=strsplit(strtrim(dummy{2}),' ');
        voxelsize=str2num(dummy2{1});
        dummy2=strsplit(strtrim(dummy{3}),' ');
        byteorder=dummy2{2};
        if isnumeric(dimensions(1))&&isnumeric(dimensions(2))&&isnumeric(dimensions(3))&&isnumeric(voxelsize)
            if any(dimensions<2)||any(dimensions>2000)
                % error not expected size
            else
                data.header.Projectname=projectname;
                handles.projectname.String=data.header.Projectname;
                handles.PN_status.BackgroundColor=[0 1 0];
                data.header.Dimensions=dimensions;
                data.header.Voxelsize=voxelsize;
                handles.dimensions.String=[num2str(data.header.Dimensions(1)) ' / ' num2str(data.header.Dimensions(2)) ' / ' num2str(data.header.Dimensions(3))];
                handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
                handles.DI_status.BackgroundColor=[0 1 0];
                system.temp.current_load_path=pathname;
            end
        end
    catch
        return
    end
end
progress_check(handles);

function createCL_Callback(~, ~, handles)
global data

prompt = {'Enter size of gaussian smoothing kernel [vx]:','Enter standard deviation of gaussian smoothing kernel []:','Enter number of smoothing iterations []:'};
dlgtitle = 'Segmentation information';
fieldsize = [1 60; 1 60; 1 60];
definput = {'5','2','2'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
if ~isempty(answer)
    h=custom_msgbox('Please wait a few seconds...generating chamber lumina','','none',[],false);
    filtsize=str2num(answer{1});
    filtsd=str2num(answer{2});
    filtit=str2num(answer{3});
    DistMap=bwdist(data.BSS);
    V=double(DistMap);
    for k=1:filtit
        V=smooth3(V,'gaussian',filtsize,filtsd);
    end
    V(data.BSS)=-100;
    L=watershed(-V,26);
    L2=fill_watershed_ridge(L,V);
    L2(data.BSS)=0;
    L2=remove_all_boundary_labels(L2);
    data.PCL=L2;
    handles.labelsource.String='generated by MFSE';
    labels=unique(data.PCL);
    labels(labels==0)=[];
    handles.total_labels.String=num2str(numel(labels));
    
    sliderdim=size(V,3);
    set(handles.imageslider,'Min',1,'Max',sliderdim,'Value',round(sliderdim/2),'Sliderstep',[1/sliderdim 1/sliderdim]);
    imagesc(handles.Axes,data.PCL(:,:,round(sliderdim/2)))
    
    if ~contains(handles.image_data_selector.String,'Lumen labels')
        handles.image_data_selector.String={handles.image_data_selector.String; 'Lumen labels'};
    end
    handles.image_data_selector.Value=find(strcmp(handles.image_data_selector.String,'Lumen labels'));
    handles.imageslider.Visible='on';
    handles.CL_status.BackgroundColor=[1 0 0];
    delete (h);
    progress_check(handles)
end

function Vout=remove_all_boundary_labels(Vin)
dims=size(Vin);

query=false(dims);
query(1,:,:)=true;
query(:,1,:)=true;
query(:,:,1)=true;
query(dims(1),:,:)=true;
query(:,dims(2),:)=true;
query(:,:,dims(3))=true;
Q=Vin(query);
L=unique(Q);
L(L==0)=[];
M=ismember(Vin,L);
Vout=Vin;
Vout(M)=0;

function MFSE_PCTWindow_WindowScrollWheelFcn(~, eventdata, handles)
if any(handles.Axes.DataAspectRatio~=1)
    val=handles.imageslider.Value+(eventdata.VerticalScrollCount*eventdata.VerticalScrollAmount);
    if val>handles.imageslider.Max
        handles.imageslider.Value=handles.imageslider.Max;
    elseif val<handles.imageslider.Min
        handles.imageslider.Value=handles.imageslider.Min;
    else
        handles.imageslider.Value=val;
    end
    imageslider_Callback(handles.imageslider,0, handles);
end

function fully_filled_WatershedImage = fill_watershed_ridge(WatershedImage,OrgImage)

dims=size(WatershedImage);
Base = [+1 +1 0 ; +1 -1 0 ; +1 0 +1 ; +1 0 -1; +1 0 0 ; 0 +1 0 ; 0 -1 0 ; 0 +1 +1 ; 0 0 +1 ; 0 -1 +1 ; 0 +1 -1 ; 0 0 -1 ; 0 -1 -1 ; -1 +1 0 ; -1 -1 0 ; -1 0 +1 ; -1 0 -1 ; -1 0 0];                

weight=1./sqrt(sum(abs(Base),2));
RidgeImage=logical(OrgImage>0)&~logical(WatershedImage);

VolNums=unique(WatershedImage(WatershedImage>0));
filled_WatershedImage=WatershedImage;
DistanceImage=bwdist(RidgeImage);
s=regionprops3(RidgeImage,'VoxelList','VoxelIdxList');

ridgelums=vertcat(s.VoxelList{:});
ridgelumsIDX=vertcat(s.VoxelIdxList{:});

waitlist=zeros(size(ridgelums,1),1);
pairlist=zeros(size(ridgelums,1),numel(VolNums));

k=1;
for i=1:size(ridgelums,1)        
    neighbours = Base + repmat([ridgelums(i,2) ridgelums(i,1) ridgelums(i,3)],[18 1]);
    vneighbours=all(neighbours>0,2)&neighbours(:,1)<=dims(1)&neighbours(:,2)<=dims(2)&neighbours(:,3)<=dims(3);      
    curLev=DistanceImage(ridgelumsIDX(i));
    Nindices=sub2ind(dims,neighbours(vneighbours,1),neighbours(vneighbours,2),neighbours(vneighbours,3)); % changed
    Levels=DistanceImage(Nindices)-curLev;
    Levels=1./(Levels.*weight(vneighbours));
    Properties=WatershedImage(Nindices);
    FProps=unique(Properties);
    FProps(FProps==0)=[];
    NLevelsVN=zeros(numel(FProps),1);
    for n=1:numel(FProps)
        NLevelsVN(n)=sum(Levels(Properties==FProps(n)));
    end
    if sum(NLevelsVN==max(NLevelsVN))>1        
        waitlist(k)=ridgelumsIDX(i);
        pairlist(k,1:numel(FProps(NLevelsVN==max(NLevelsVN))))=FProps(NLevelsVN==max(NLevelsVN))';
        k=k+1;
    else
        filled_WatershedImage(ridgelumsIDX(i))=FProps(NLevelsVN==max(NLevelsVN));    
    end
        
end
fully_filled_WatershedImage=filled_WatershedImage;

pairlist(~(waitlist>0),:)=[];
waitlist(~(waitlist>0))=[];
[combs,~,combgroup]=unique(pairlist,'rows');

for i=1:size(combs,1)
    Voxind=find(ismember(combgroup,i));
    Voxtodist=numel(Voxind);
    Vols=combs(i,combs(i,:)>0);
    NLevelsVN=zeros(numel(Vols),1);
    for k=1:numel(Vols)
        NLevelsVN(k)=sum(sum(sum(ismember(WatershedImage,Vols(k)))));
    end
    Volratio=NLevelsVN./sum(NLevelsVN);
    attribs=round(Voxtodist*Volratio);    
    p=1;
    for k=1:numel(attribs)        
            fully_filled_WatershedImage(waitlist(Voxind(p:p+attribs(k)-1)))=Vols(k);
            p=p+attribs(k);        
    end
end

function Clear_Callback(~, ~, handles)
global data

data.header.Projectname='';
data.header.Dimensions=[0 0 0];
data.header.Voxelsize=1;
data.header.Comment='none';
data.PCL=[];
data.BSS=[];
handles.shellsource.String='';
handles.labelsource.String='';
handles.projectname.String='';
handles.active_labels.String='';
handles.total_labels.String='';
handles.dimensions.String='';
handles.comment.String='none';
handles.voxelsize.String='1';
handles.PN_status.BackgroundColor=[1 0 0];
handles.DI_status.BackgroundColor=[1 0 0];
handles.CL_status.BackgroundColor=[1 0 0];
handles.BSS_status.BackgroundColor=[1 0 0];
handles.image_data_selector.Value=1;
handles.image_data_selector.String='None';
handles.imageslider.Visible='off';
delete(handles.Axes.Children);
progress_check(handles)

function Import_Legacy_Menu_Callback(hObject, eventdata, handles)
