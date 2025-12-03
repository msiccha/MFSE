%%% MATLAB GUI GENERATION FUNCTIONS %%%
function varargout = MFSE_Main(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MFSE_Main_OpeningFcn, ...
    'gui_OutputFcn',  @MFSE_Main_OutputFcn, ...
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

function MFSE_Main_OpeningFcn(hObject, ~, handles, varargin)
global data
global patches %#ok<*NUSED>
global cali
global system
global jtableobj
global GlobalHandles

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

pinfo=parcluster;

load('MFSE_preferences.dat','-mat','system');
system.temp.hit_from_patch=false;
system.temp.shift_pressed=false;
system.temp.control_pressed=false;
system.temp.cancel=false;
system.temp.current_load_path=[pwd '\'];
system.temp.current_save_path=[pwd '\'];
system.temp.current_export_path=[pwd '\'];
system.temp.settingsGUI_active=false;
system.temp.has_external_AO=false;
system.temp.view=[-37.5,30];
system.temp.revert_filename=[];
system.temp.available_pworkers=pinfo.NumWorkers;
system.temp.current_center=[0 0 0];
system.temp.filename=[];
system.temp.LastSort={'Label','ascend'};
system.temp.hit_from_table_renew=false;

if strcmp(system.static.startup_parallel_cluster,'true')
    evalc('ppool=parpool(pinfo,round(system.static.pworkers_to_use*pinfo.NumWorkers))');
    ppool.IdleTimeout=120; %#ok<STRNU>
end

%system.corollary.patch_margin=0.5;
%system.corollary.light_ambient=0.5;
%system.corollary.light_specular=0;
%system.corollary.light_diffuse=0.75;
%system.corollary.colormap=lines(4096);
%system.corollary.normal_gaussian_parms=[3,3,3,0.65];
%system.corollary.smooth_gaussian_parms=[5,5,5,3];

%system.static.pworkers_ratio_to_use=0.5;
%system.static.startup_parallel_cluster='false';
%system.static.TableOptParmList=table({'PrincipalAxisLength';'PrincipalAxisLength';'PrincipalAxisLength';'PrincipalAxisLength';'PrincipalAxisLength';'PrincipalAxisLength';'ConvexVolume';'Extent';'SurfaceArea';'Solidity';'EquivDiameter'},[1;1;2;2;3;3;1;1;1;1;1],[false;true;false;true;false;true;false;false;false;false;false],[0;1;0;2;0;3;0;0;0;0;0],[0;1;0;1;0;1;0;0;0;0;0],{'1st principal axis length';'1st principal axis length';'2nd principal axis length';'2nd principal axis length';'3rd principal axis length';'3rd principal axis length';'Convex Volume';'Extent';'Surface area';'Solidity';'Circle equivalent diameter'},{'[vx]';'[µm]';'[vx]';'[µm]';'[vx]';'[µm]';'[vx³]';'[]';'[vx²]';'[]';'[vx]'},{'1st Axis [vx]';'1st Axis [µm]';'2nd Axis [vx]';'2nd Axis [µm]';'3rd Axis [vx]';'3rd Axis [µm]';'Conv. vol. [vx³]';'Extent []';'Surf. area [vx²]';'Solidity []';'CED [vx]'},[true;false;false;false;false;false;false;false;false;true;false]);
%system.static.TableOptParmList.Properties.VariableNames={'RegionPropsName','RegionPropsIndex','Transformed','SourceIdx','Scale','LongName','Unit','ShortName','Set'};

%system.defaults.patch_margin=0.5;
%system.defaults.light_ambient=0.5;
%system.defaults.light_specular=0;
%system.defaults.light_diffuse=0.75;
%system.defaults.OptParmList=[true;false;false;false;false;false;true;false];

handles.output = hObject;
handles.Axes.Color=handles.frame_color.BackgroundColor;
handles.Axes.XAxis.Color=handles.axes_color.BackgroundColor;
handles.Axes.YAxis.Color=handles.axes_color.BackgroundColor;
handles.Axes.ZAxis.Color=handles.axes_color.BackgroundColor;
handles.Axes.MinorGridColor=handles.axes_color.BackgroundColor;
handles.Axes.GridColor=handles.axes_color.BackgroundColor;
handles.Axes.XAxis.Visible='off';
handles.Axes.YAxis.Visible='off';
handles.Axes.ZAxis.Visible='off';
handles.Axes.XGrid='off';
handles.Axes.YGrid='off';
handles.Axes.ZGrid='off';
handles.Axes.XMinorGrid='off';
handles.Axes.YMinorGrid='off';
handles.Axes.ZMinorGrid='off';
handles.Axes.XAxis.TickLabels={''};
handles.Axes.YAxis.TickLabels={''};
handles.Axes.ZAxis.TickLabels={''};

axis(handles.Axes,'off');
guidata(hObject, handles);
cali=[];
GlobalHandles.MainTableHandle=handles.MainTable;
GlobalHandles.SelectedFieldHandle=handles.selected_labels;

function varargout = MFSE_Main_OutputFcn(~, ~, handles)
varargout{1} = handles.output;
%place_GUI_element(handles.MainGUIWindow,1)

function MainGUIWindow_CloseRequestFcn(~, ~, ~) %#ok<*DEFNU>
selection = questdlg('Exit application? Any unsaved data will be lost!','Exit ','Yes', 'No','No');
switch selection
    case 'Yes'        
        evalc('delete(gcp(''nocreate''))');
        close all force
    case 'No'
        return
end

function MainGUIWindow_DeleteFcn(~, ~, ~)
close all force

%%% Menu callback functions %%%
function load_msd_MenuCallback(~, ~, handles)
global data
global system
global patches

if ~isempty(data)
    selection = questdlg('Any unsaved data will be lost!','Load project','Continue', 'Cancel','Cancel');
    switch selection
        case 'Continue'
            load_continue=true;
        case 'Cancel'
            load_continue=false;
    end
else
    load_continue=true;
end

if load_continue
    [filename, pathname] = uigetfile([system.temp.current_load_path '*.msd'],'Select a segmentation data file');
    if isequal(filename,0) || isequal(pathname,0)
        return
    else
        system.temp.current_load_path=pathname;
        data=[];
        patches=[];
        cla(handles.Axes);
        h=custom_msgbox('Please wait a few seconds...loading data','','none',[],false);
        load(fullfile(pathname, filename),'-mat','segmentation');
        ingest_segmentation_struct(segmentation,handles);
        system.temp.has_external_AO=false;      
        handles.export_GIPL.Enable='on';
        handles.export_RAW.Enable='on';
        handles.import_AO.Enable='on';
        handles.import_AO.Checked='off';
        handles.MainGUIWindow.Name=['MicroFossil Segmentation Editor           '  filename];
        system.temp.revert_filename=fullfile(pathname, filename);
        system.temp.filename=filename;
        handles.group_show.Value=1;
        handles.class_show.Value=1;
        handles.MU_show.Value=1;
        handles.layer_show.Value=1;
        delete (h)
    end
end

function revert_msd_Callback(~, ~, handles)
global data
global system
global patches

if ~isempty(data)
    selection = questdlg('Changes since the last save will be undone!','Revert project','Continue', 'Cancel','Cancel');
    switch selection
        case 'Continue'
            load_continue=true;
        case 'Cancel'
            load_continue=false;
    end
else
    load_continue=true;
end

if load_continue
    data=[];
    patches=[];
    cla(handles.Axes);
    h=custom_msgbox('Please wait a few seconds...reverting  data','','none',[],false);
    load(system.temp.revert_filename,'-mat','segmentation');
    ingest_segmentation_struct(segmentation,handles);
    system.temp.has_external_AO=false;    
    handles.export_GIPL.Enable='on';
    handles.export_RAW.Enable='on';
    handles.import_AO.Enable='on';
    handles.import_AO.Checked='off';
    [~, system.temp.filename]=fileparts(system.temp.revert_filename);    
    delete (h)
end

function import_legacy_MSD_MenuCallback(~, ~, handles)
global data
global system
global patches

if ~isempty(data)
    selection = questdlg('Any unsaved data will be lost!','Load project','Continue', 'Cancel','Cancel');
    switch selection
        case 'Continue'
            load_continue=true;
        case 'Cancel'
            load_continue=false;
    end
else
    load_continue=true;
end

if load_continue
    [filename, pathname] = uigetfile([system.temp.current_load_path '*.msd'],'Select a legacy segmentation data file');
    if isequal(filename,0) || isequal(pathname,0)
        return
    else
        h=custom_msgbox('Please wait a few seconds...importing data','','none',[],false);
        
        system.temp.current_load_path=pathname;
        data=[];
        patches=[];
        cla(handles.Axes);
        
        X=load(fullfile(pathname, filename),'-mat');
        Xnames=fieldnames(X);
        if any(contains(Xnames,'Seg'))
            OldVarNames=X.Seg.Labeltable.Properties.VariableNames;
            if any(contains(OldVarNames,'Type_1'))
                data.header.Projectname='no name';
                data.header.Voxelsize=X.Seg.header.Voxelsize;
                data.header.Dimensions=size(X.Seg.Labelfield);
                data.header.Comment=reshape(X.Seg.header.Comment',1,numel(X.Seg.header.Comment));
                data.header.BasicShellSegmentationSource='Legacy MSD file';
                data.header.PrimaryLumenSegmentationSource='Legacy MSD file';
                
                data.Labeltable=table();
                data.Labeltable.Label=X.Seg.Labeltable.Label;
                data.Labeltable.Active=X.Seg.Labeltable.active;
                data.Labeltable.MorphoUnit=X.Seg.Labeltable.MorphoUnit;
                data.Labeltable.Layer=ones(size(X.Seg.Labeltable,1),1);
                data.Labeltable.Class=repmat({'Lumen'},size(X.Seg.Labeltable,1),1);
                data.Labeltable.Group=X.Seg.Labeltable.Type_2;
                data.Labeltable.Type=X.Seg.Labeltable.Type_3;
                data.Labeltable.Name=X.Seg.Labeltable.Name;
                
                data.basicshell.Binary=X.Seg.primary_shell.Binary;
                data.basicshell.patchdata=X.Seg.primary_shell.volumedata;
                data.basicshell.Centroid=X.Seg.primary_shell.Centroid;
            else
                data.header=X.Seg.header;
                data.Labeltable=X.Seg.Labeltable(:,1:8);
                data.basicshell=X.Seg.basicshell;
                for k=1:size(data.Labeltable,1)
                    if strcmp(data.Labeltable.Class(k),'')
                        data.Labeltable.Class(k)={'Unclassified'};
                    end
                end
            end            
            max_used_dim=0;
            for i=1:size(X.Seg.Labelfield,4)
                if any(any(any(X.Seg.Labelfield(:,:,:,i))))
                    max_used_dim=i;
                end
            end            
            data.Labelfield=X.Seg.Labelfield(:,:,:,1:max_used_dim);
                                    
        elseif contains(Xnames,'D')
            data.header.Projectname='no name';
            data.header.Voxelsize=X.D.Voxelsize;
            data.header.Dimensions=size(X.D.Labelfield);
            data.header.Comment=reshape(X.D.Comment',1,numel(X.D.Comment));
            data.header.BasicShellSegmentationSource='Legacy MSD file';
            data.header.PrimaryLumenSegmentationSource='Legacy MSD file';
            
            data.Labeltable=table();
            data.Labeltable.Label=X.D.Datatable.Label;
            data.Labeltable.Active=X.D.Datatable.active;
            data.Labeltable.MorphoUnit=zeros(size(X.D.Datatable,1),1);
            data.Labeltable.Layer=ones(size(X.D.Datatable,1),1);
            data.Labeltable.Class=repmat({'Unclassified'},size(X.D.Datatable,1),1);
            data.Labeltable.Group=repmat({''},size(X.D.Datatable,1),1);
            data.Labeltable.Type=repmat({''},size(X.D.Datatable,1),1);
            data.Labeltable.Name=X.D.Datatable.Name;
            
            data.basicshell.Binary=X.D.Shell.Shell_binary;
            data.basicshell.patchdata=X.D.Shell.VolumeData;
            data.basicshell.Centroid=X.D.Shell.Centroid;
            
            data.Labelfield(:,:,:,1)=X.D.Labelfield;                                                                   
            
        end
        delete (h);
        recalculate_patches()
        data.display=system.corollary;
        ingest_segmentation_struct(data,handles);
        handles.export_GIPL.Enable='on';
        handles.export_RAW.Enable='on';
        handles.import_AO.Enable='on';
        handles.import_AO.Checked='off';
        handles.MainGUIWindow.Name=['MicroFossil Segmentation Editor           '  filename];
        system.temp.revert_filename=fullfile(pathname, filename);
        delete (h)
                        
    end
end

function show_manual_MenuCallback(~, ~, ~)
path=getenv('ProgramFiles');
winopen([path '\MFSE\application\MFSE_Manual.pdf']);

function show_tutorial_MenuCallback(~, ~, ~)
path=getenv('ProgramFiles');
winopen([path '\MFSE\application\MFSE_Tutorial.pdf']);

function save_msd_MenuCallback(~, ~, handles)
global data
global system

segmentation=data; %#ok<*NASGU>
segmentation.display=system.corollary;

[filename, pathname] = uiputfile('*.msd','Save segmentation data as', fullfile(system.temp.current_save_path,system.temp.filename));
if isequal(filename,0) || isequal(pathname,0)
    return
else
    save(fullfile(pathname, filename),'segmentation','-mat','-v7.3');
    h=custom_msgbox(['Segmentation project has been saved as ' filename],'','none',[],true);
    handles.MainGUIWindow.Name=['MicroFossil Segmentation Editor           '  filename];
    system.temp.current_save_path=pathname;
    system.temp.revert_filename=fullfile(pathname, filename);
    system.temp.filename=filename;
end

function Open_PCT_MenuCallback(~, ~, ~)
global data
if ~isempty(data)
    selection = questdlg('Any unsaved data will be lost!','Project Creation Tool','Continue', 'Cancel','Cancel');
    switch selection
        case 'Continue'
            pcontinue=true;
        case 'Cancel'
            pcontinue=false;
    end
else
    pcontinue=true;
end
if pcontinue
    % clear and disable everything
    MFSE_PCT()
end

function import_AO_MenuCallback(~, ~, handles)
global system
global data
global supplementary

[filename, pathname] = uigetfile([system.temp.current_load_path '*.raw'],'Select the RAW file containg the externally calculated ambient occlusion data');

if isequal(filename,0) || isequal(pathname,0)
    return
else
    system.temp.current_load_path=pathname;
    h=custom_msgbox('Please wait a few seconds...loading ambient occlusion data file','','help',[],false);
    try    
    fid=fopen(fullfile (pathname,filename),'r');
    AC=fread(fid,'float32');
    supplementary.AmbientOcclusion=reshape(AC,data.header.Dimensions);
    system.temp.has_external_AO=true;
    handles.import_AO.Checked='on';
    catch
        e=custom_msgbox('Error encountered during import of Ambient Occlusion data file!','','error',[],true);
    end    
    delete (h);
end

%%% View and select GUI functions %%%
function toggle_mode_Callback(hObject, ~, handles)
cheat={'off' 'on'};
btext={'Select','View'};
rotate3d(handles.Axes,cheat{~hObject.Value+1});
hObject.String=btext{~hObject.Value+1};
hFigure = ancestor(handles.Axes, 'Figure');
hManager = uigetmodemanager(hFigure);
[hManager.WindowListenerHandles.Enabled] = deal(false);  % HG2
set(hFigure, 'WindowKeyPressFcn', []);
set(hFigure, 'KeyPressFcn',@(hObject,eventdata)MFSE_Main('MainGUIWindow_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));

function filter=assemble_label_filter(handles)

if iscell(handles.layer_show.String)
    sLayer=handles.layer_show.String{handles.layer_show.Value};
else
    sLayer=handles.layer_show.String;
end
if iscell(handles.class_show.String)
    sClass=handles.class_show.String{handles.class_show.Value};
else
    sClass=handles.class_show.String;
end
if iscell(handles.MU_show.String)
    sMU=handles.MU_show.String{handles.MU_show.Value};
else
    sMU=handles.MU_show.String;
end
if iscell(handles.group_show.String)
    sGroup=handles.group_show.String{handles.group_show.Value};
else
    sGroup=handles.group_show.String;
end

sMUops=handles.MU_operation.Value;
sLayerops=handles.layer_operation.Value;
sClassops=handles.class_operation.Value;
sGroupops=handles.group_operation.Value;

if ~strcmp(sMU,'Any')
    MU=str2num(sMU); %#ok<*ST2NM>
    switch sMUops
        case 1
            selMU=str2double(string((handles.MainTable.Data(:,5))))<=MU;
        case 2
            selMU=str2double(string((handles.MainTable.Data(:,5))))>=MU;
        case 3
            selMU=str2double(string((handles.MainTable.Data(:,5))))==MU;
        case 4
            selMU=str2double(string((handles.MainTable.Data(:,5))))~=MU;
    end
else
    selMU=true(size(handles.MainTable.Data,1),1);
end

if ~strcmp(sLayer,'Any')
    Layer=str2num(sLayer);
    switch sLayerops
        case 1
            selLayer=str2num(cell2mat(handles.MainTable.Data(:,4)))<=Layer;
        case 2
            selLayer=str2num(cell2mat(handles.MainTable.Data(:,4)))>=Layer;
        case 3
            selLayer=str2num(cell2mat(handles.MainTable.Data(:,4)))==Layer;
        case 4
            selLayer=str2num(cell2mat(handles.MainTable.Data(:,4)))~=Layer;
    end
else
    selLayer=true(size(handles.MainTable.Data,1),1);
end

if ~strcmp(sClass,'Any')
    switch sClassops
        case 1
            selClass=strcmp(handles.MainTable.Data(:,7),sClass);
        case 2
            selClass=~strcmp(handles.MainTable.Data(:,7),sClass);
    end
else
    selClass=true(size(handles.MainTable.Data,1),1);
end

if ~strcmp(sGroup,'Any')
    switch sGroupops
        case 1
            selGroup=strcmp(handles.MainTable.Data(:,8),sGroup);
        case 2
            selGroup=~strcmp(handles.MainTable.Data(:,8),sGroup);
    end
else
    selGroup=true(size(handles.MainTable.Data,1),1);
end
filter=selMU&selLayer&selClass&selGroup;

function hide_all_Callback(~, ~, handles)
global patches
global data
global system

for i=1:numel(system.TempLabeltable.Label)
    cname=['L' num2str(system.TempLabeltable.Label(i),'%04u')];
    patches.(cname).Visible='off';
end
handles.MainTable.Data(:,3)={false};
system.TempLabeltable.show(:)=false;
check_operations(handles);

function show_all_Callback(~, ~, handles)
global patches
global data
global system

for i=1:numel(system.TempLabeltable.Label)
    cname=['L' num2str(system.TempLabeltable.Label(i),'%04u')];
    patches.(cname).Visible='on';
end
handles.MainTable.Data(:,3)={true};
system.TempLabeltable.show(:)=true;
check_operations(handles);

function hide_Callback(~, ~, handles)
global patches
global data
global system

filter=assemble_label_filter(handles);

if handles.show_active.Value
    filter=filter&logical(cell2mat(handles.MainTable.Data(:,2)));
end

for i=1:numel(data.Labeltable.Label)
    cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
    if filter(i)
        patches.(cname).Visible='off';
        handles.MainTable.Data(i,3)={false};
        system.TempLabeltable.show(i)=false;
    end
end
check_operations(handles);

function show_Callback(~, ~, handles)
global patches
global data
global system

filter=assemble_label_filter(handles);

if handles.show_active.Value
    filter=filter&logical(cell2mat(handles.MainTable.Data(:,2)));
end

if handles.show_only.Value % show filter und unshow inversion
    for i=1:numel(data.Labeltable.Label)
        cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
        if filter(i)
            patches.(cname).Visible='on';
            handles.MainTable.Data(i,3)={true};
            system.TempLabeltable.show(i)=true;
        else
            patches.(cname).Visible='off';
            handles.MainTable.Data(i,3)={false};
            system.TempLabeltable.show(i)=false;
        end
    end
else % just show filter
    for i=1:numel(data.Labeltable.Label)
        if filter(i)
            cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
            patches.(cname).Visible='on';
            handles.MainTable.Data(i,3)={true};
            system.TempLabeltable.show(i)=true;
        end
    end
end
check_operations(handles);

function show_selection_Callback(~, ~, handles)
global patches
global data
global system

currently_selected=str2num(handles.selected_labels.String);
system.hit_from_table_renew=true;
for i=1:numel(data.Labeltable.Label)
    cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
    if any(ismember(currently_selected,data.Labeltable.Label(i)))
        patches.(cname).Visible='on';
        handles.MainTable.Data(i,3)={true};
        system.TempLabeltable.show(i)=true;
    else
        patches.(cname).Visible='off';
        handles.MainTable.Data(i,3)={false};
        system.TempLabeltable.show(i)=false;
    end
end
check_operations(handles);

function invert_selection_Callback(~, ~, handles)
global patches
global data
global system

currently_selected=str2num(handles.selected_labels.String);
inversion=data.Labeltable.Label(~(ismember(data.Labeltable.Label,currently_selected)));
label='';

for i=1:numel(data.Labeltable.Label)
    cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
    if any(ismember(inversion,data.Labeltable.Label(i)))
        patches.(cname).EdgeColor=[0 0 0];
        system.TempLabeltable.selected(system.TempLabeltable.Label==data.Labeltable.Label(i))=true;
        label=[label ' ' num2str(data.Labeltable.Label(i))];        %#ok<AGROW>
    else
        patches.(cname).EdgeColor='none';
        system.TempLabeltable.selected(system.TempLabeltable.Label==data.Labeltable.Label(i))=false;
    end
end
handles.selected_labels.String=strtrim(label);
check_operations(handles);

function select_visible_Callback(~, ~, handles)
global system
global patches

fn=fieldnames(patches);
label='';

for i=1:size(system.TempLabeltable,1)
    cname=['L' num2str(system.TempLabeltable.Label(i),'%04u')];
    if system.TempLabeltable.show(i)
        patches.(cname).EdgeColor=[0 0 0];
        label=[label ' ' num2str(system.TempLabeltable.Label(i))];        %#ok<AGROW>
        system.TempLabeltable.selected(i)=true;
    else
        patches.(cname).EdgeColor='none';
        system.TempLabeltable.selected(i)=false;
    end
end
handles.selected_labels.String=strtrim(label);
system.TempLabeltable.selected=system.TempLabeltable.show;
check_operations(handles);

function show_shell_Callback(hObject, ~, ~)
global patches

cheat={'off' 'on'};
patches.Shellpatch.Visible=cheat{hObject.Value+1};

function shell_color_Callback(hObject, ~, ~)
global patches

col=CustomColorPicker(hObject.BackgroundColor);
set(hObject,'BackGroundColor',col);
patches.Shellpatch.FaceColor=col;

function shell_opacity_Callback(hObject, ~, ~)
global patches

patches.Shellpatch.FaceAlpha=hObject.Value;

function show_frame_Callback(hObject, ~, handles)
if hObject.Value==1
    handles.Axes.Color=handles.frame_color.BackgroundColor;
    handles.show_axes.Enable='on';
    axis(handles.Axes,'on');
else
    handles.show_axes.Enable='off';
    handles.show_axes.Value=0;
    handles.show_axeslabels.Enable='off';
    handles.show_axeslabels.Value=0;
    handles.show_grid.Enable='off';
    handles.show_grid.Value=0;
    handles.Axes.XAxis.Visible='off';
    handles.Axes.YAxis.Visible='off';
    handles.Axes.ZAxis.Visible='off';
    handles.Axes.XGrid='off';
    handles.Axes.YGrid='off';
    handles.Axes.ZGrid='off';
    handles.Axes.XMinorGrid='off';
    handles.Axes.YMinorGrid='off';
    handles.Axes.ZMinorGrid='off';
    axis(handles.Axes,'off');
end

function frame_color_Callback(hObject, ~, handles)
col=CustomColorPicker(hObject.BackgroundColor);
set(hObject,'BackGroundColor',col);
handles.Axes.Color=col;

function show_axes_Callback(hObject, ~, handles)
if hObject.Value==1
    handles.Axes.Box='on';
    handles.Axes.XAxis.Visible='on';
    handles.Axes.YAxis.Visible='on';
    handles.Axes.ZAxis.Visible='on';
    handles.Axes.XAxis.MinorTick='on';
    handles.Axes.YAxis.MinorTick='on';
    handles.Axes.ZAxis.MinorTick='on';
    handles.show_axeslabels.Enable='on';
    handles.show_grid.Enable='on';
else
    handles.Axes.Box='off';
    handles.show_axeslabels.Enable='off';
    handles.show_axeslabels.Value=0;
    handles.show_grid.Enable='off';
    handles.show_grid.Value=0;
    handles.Axes.XAxis.Visible='off';
    handles.Axes.YAxis.Visible='off';
    handles.Axes.ZAxis.Visible='off';
    handles.Axes.XGrid='off';
    handles.Axes.YGrid='off';
    handles.Axes.ZGrid='off';
    handles.Axes.XMinorGrid='off';
    handles.Axes.YMinorGrid='off';
    handles.Axes.ZMinorGrid='off';
    handles.Axes.XAxis.TickLabels={''};
    handles.Axes.YAxis.TickLabels={''};
    handles.Axes.ZAxis.TickLabels={''};
end

function axes_color_Callback(hObject, ~, handles)
col=CustomColorPicker(hObject.BackgroundColor);
set(hObject,'BackGroundColor',col);
handles.Axes.XAxis.Color=col;
handles.Axes.YAxis.Color=col;
handles.Axes.ZAxis.Color=col;
handles.Axes.MinorGridColor=col;
handles.Axes.GridColor=col;

function show_grid_Callback(hObject, ~, handles)
if hObject.Value==1
    handles.Axes.XGrid='on';
    handles.Axes.YGrid='on';
    handles.Axes.ZGrid='on';
    handles.Axes.XMinorGrid='on';
    handles.Axes.YMinorGrid='on';
    handles.Axes.ZMinorGrid='on';
else
    handles.Axes.XGrid='off';
    handles.Axes.YGrid='off';
    handles.Axes.ZGrid='off';
    handles.Axes.XMinorGrid='off';
    handles.Axes.YMinorGrid='off';
    handles.Axes.ZMinorGrid='off';
end

function show_axeslabels_Callback(hObject, ~, handles)
if hObject.Value==1
    handles.Axes.XAxis.TickLabelsMode='auto';
    handles.Axes.YAxis.TickLabelsMode='auto';
    handles.Axes.ZAxis.TickLabelsMode='auto';
else
    handles.Axes.XAxis.TickLabels={''};
    handles.Axes.YAxis.TickLabels={''};
    handles.Axes.ZAxis.TickLabels={''};
end

function show_vicinity_Callback(~, ~, handles)
global data
global patches
global system

answer=inputdlg({'Enter the distance in voxels:'},'',1,{'50'});
crit_dist=str2num(answer{1});

label=str2num(handles.selected_labels.String);
if ~isempty(label)&&isnumeric(crit_dist)&&~isempty(crit_dist)&&sum(any(data.Labeltable.Label==label))==1
    index=find(data.Labeltable.Label==label, 1);
    org_patch_name=['L' num2str(label,'%04u')];
    distances=zeros(numel(data.Labeltable.Label),1);
    f=fieldnames(data.volumedata);
    for i=1:numel(f)
        distances(i)=pdistance(data.volumedata.(f{i}).Centroid,data.volumedata.(org_patch_name).Centroid);
    end
    list=distances<=crit_dist;
    binary_cheat={'off' 'on'};
    for i=1:numel(f)
        patches.(f{i}).Visible=binary_cheat{list(i)+1};
        label=str2num(f{i}(2:end));
        handles.MainTable.Data(data.Labeltable.Label==label,3)={list(i)};
        system.TempLabeltable.show(system.TempLabeltable.Label==label)=list(i);
    end
else
    h=custom_msgbox('Please select a single valid label and enter a numerical distance value for this operation!','','error',[],true);
end
check_operations(handles);

%%% label operations callback functions %%%
function delete_Callback(~, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0
    choice = questdlg('Sure about this?','Delete label(s)','Yes','No','No');
    if strcmp(choice,'Yes')
        for i=1:numel(labels)
            label=labels(i);
            remove_entry(label);
        end
        populate_table(handles,false,false);
    end
else
    h=custom_msgbox('Please select one or more valid labels for this operation!','','error',[],true);
end

function recolor_label_Callback(~, ~, handles)
global data
global patches
global system
global GlobalHandles

switch handles.LabelColorMap.String{handles.LabelColorMap.Value}
    case 'Prism'
        colordummy=prism(4096);
        disp=8;
    case 'Colorbrewer'
        dummy=[0.650980392156863 0.807843137254902 0.890196078431373;0.121568627450980 0.470588235294118 0.705882352941177;0.698039215686275 0.874509803921569 0.541176470588235;0.200000000000000 0.627450980392157 0.172549019607843;0.984313725490196 0.603921568627451 0.600000000000000;0.890196078431373 0.101960784313725 0.109803921568627;0.992156862745098 0.749019607843137 0.435294117647059;1 0.498039215686275 0;0.792156862745098 0.698039215686275 0.839215686274510;0.415686274509804 0.239215686274510 0.603921568627451;1 1 0.600000000000000;0.694117647058824 0.349019607843137 0.156862745098039];
        colordummy=repmat(dummy,340,1);
        disp=12;
    case 'Lines'
        colordummy=lines(4096);
        disp=8;
    case 'HSV'
        dummy=hsv(8);
        colordummy=repmat(dummy,512,1);
        disp=8;
end

displacement=round(rand(1,1)*(disp-1))+1;
new_color=[colordummy(displacement:end,:);colordummy(1:displacement-1,:)];
current_labels=str2num(handles.selected_labels.String);

for i=1:numel(current_labels)
    cname=['L' num2str(current_labels(i),'%04u')];
    if contains(GlobalHandles.MainTableHandle.Data(str2num(cell2mat(GlobalHandles.MainTableHandle.Data(:,1)))==current_labels(i),10),'voxels')
        ec=color_mod(new_color(i,:),0.25,'darker');
        patches.(cname).EdgeColor=ec;
    end
    patches.(cname).FaceColor=new_color(i,:);
end

function singularize_Callback(hObject, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0
    h=custom_msgbox('Please wait a few seconds...singularizing label patch','','help',[],false);
    for i=1:numel(labels)
        tbe=data.Labeltable.Label==labels(i);
        layer=data.Labeltable.Layer(tbe);
        split_data=data.Labelfield(:,:,:,layer);
        split_data(split_data~=labels(i))=0;
        [XR,YR,ZR]=extract_label(split_data);
        cropped_split_data=logical(split_data(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2)));
        s=regionprops3(cropped_split_data,'Volume','BoundingBox','Image');
        main_vol=find(s.Volume==max(s.Volume),1,'first');
        L=false(data.header.Dimensions);
        Ls=false(size(cropped_split_data));
        Ls(ceil(s.BoundingBox(main_vol,2)):floor(s.BoundingBox(main_vol,2))+s.BoundingBox(main_vol,5),ceil(s.BoundingBox(main_vol,1)):floor(s.BoundingBox(main_vol,1))+s.BoundingBox(main_vol,4),ceil(s.BoundingBox(main_vol,3)):floor(s.BoundingBox(main_vol,3))+s.BoundingBox(main_vol,6))=s.Image{main_vol};
        L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=Ls;
        add_entry(handles,L,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),data.Labeltable.Name(tbe));
        remove_entry(labels(i));
        guidata(hObject, handles);
    end
    populate_table(handles,true,false);
    delete (h);
else
    h=custom_msgbox('Please select one or more valid labels for this operation!','','error',[],true);
end

function split_Callback(hObject, ~, handles)
global data
global system

answer=inputdlg({'Enter the number of desired subvolumes:'},'',1,{system.static.Operations.Split.Value{1}});
if ~isempty(answer)
    N=str2num(answer{1});
    label=str2num(handles.selected_labels.String);
    if ~isempty(label)&&~isempty(N)&&isnumeric(N)&&sum(any(data.Labeltable.Label==label))==1
        h=custom_msgbox('Please wait a few seconds...splitting label patch','','none',[],false);
        tbe=data.Labeltable.Label==label;
        layer=data.Labeltable.Layer(tbe);
        split_data=data.Labelfield(:,:,:,layer);
        split_data(split_data~=label)=0;
        [XR,YR,ZR]=extract_label(split_data);
        cropped_split_data=logical(split_data(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2)));
        s=regionprops3(cropped_split_data,'Volume','BoundingBox','Image');
        if size(s,1)>1
            h2=custom_msgbox('Label consists of more than one individual patch...cannot split multiple patches simultaneously!','','error',[],true);
            delete (h)
            return
        else
            splitted_volume=split_volume(cropped_split_data,N);
            labellist=unique(splitted_volume);
            for i=2:numel(labellist)
                split=splitted_volume;
                split(split~=labellist(i))=0;
                L=false(data.header.Dimensions);
                L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=split;
                add_entry(handles,L,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(data.Labeltable.Label==label), ['split patch N' num2str(i-1)]));
            end
            remove_entry(label);
            guidata(hObject, handles);
            populate_table(handles,true,false);
        end
        delete (h);
    else
        h=custom_msgbox('Please select a single valid label and the desired number of resultant volumina for this operation!','','error',[],true);
    end
end

function divide_Callback(hObject, ~, handles)
global data
global system

answer=inputdlg({'Enter the number of desired subvolumes:'},'',1,{system.static.Operations.Divide.Value{1}});
if ~isempty(answer)
    N=str2num(answer{1});
    label=str2num(handles.selected_labels.String);
    if ~isempty(label)&&~isempty(N)&&isnumeric(N)&&sum(any(data.Labeltable.Label==label))==1
        h=custom_msgbox('Please wait a few seconds...splitting label patch','','none',[],false);
        tbe=data.Labeltable.Label==label;
        layer=data.Labeltable.Layer(tbe);
        split_data=data.Labelfield(:,:,:,layer);
        split_data(split_data~=label)=0;
        [XR,YR,ZR]=extract_label(split_data);
        cropped_split_data=logical(split_data(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2)));
        s=regionprops3(cropped_split_data,'Volume','BoundingBox','Image');
        if size(s,1)>1
            h2=custom_msgbox('Label consists of more than one individual patch...cannot split multiple patches simultaneously!','','error',[],true);
            delete (h)
            return
        else
            splitted_volume=split_volume(cropped_split_data,N);
            D=bwdist(~logical(cropped_split_data));
            splitted_volume=fill_watershed_ridge(splitted_volume,logical(cropped_split_data));
            labellist=unique(splitted_volume);
            for i=2:numel(labellist)
                split=splitted_volume;
                split(split~=labellist(i))=0;
                L=false(data.header.Dimensions);
                L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=split;
                add_entry(handles,L,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name{data.Labeltable.Label==label},['split patch N' num2str(i-1)]));
            end
            remove_entry(label);
            guidata(hObject, handles);
            populate_table(handles,true,false);
        end
        delete (h);
    else
        h=custom_msgbox('Please select a single valid label and the desired number of resultant volumina for this operation!','','error',[],true);
    end
end

function separate_Callback(hObject, ~, handles)
global data
global system

labels=str2num(handles.selected_labels.String);
answer=inputdlg({'Enter the minimum volume of patches to separate [vx]:','Enter the minimum solidity value of patches to separate:'},'',1,{system.static.Operations.Separate_patches.Value{1},system.static.Operations.Separate_patches.Value{2}});

if ~isempty(answer)
    minvol=str2num(answer{1});
    minsol=str2num(answer{2});
    if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0
        h=custom_msgbox('Please wait a few seconds...separating label patch','','none',[],false);
        for n=1:numel(labels)
            tbe=data.Labeltable.Label==labels(n);
            layer=data.Labeltable.Layer(tbe);
            split_data=data.Labelfield(:,:,:,layer);
            split_data(split_data~=labels(n))=0;
            [XR,YR,ZR]=extract_label(split_data);
            cropped_split_data=logical(split_data(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2)));
            s=regionprops3(cropped_split_data,'Volume','BoundingBox','Image','Solidity');
            if size(s,1)==1
                h2=custom_msgbox('Label consists of a single individual patch...you might want to split instead!','','error',[],true);
                delete (h)
                return
            else
                k=1;
                for i=1:size(s,1)
                    if s.Volume(i)>=minvol&&s.Solidity(i)>=minsol % valid sub-particle
                        L=false(data.header.Dimensions);
                        Ls=false(size(cropped_split_data));
                        Ls(ceil(s.BoundingBox(i,2)):floor(s.BoundingBox(i,2))+s.BoundingBox(i,5),ceil(s.BoundingBox(i,1)):floor(s.BoundingBox(i,1))+s.BoundingBox(i,4),ceil(s.BoundingBox(i,3)):floor(s.BoundingBox(i,3))+s.BoundingBox(i,6))=s.Image{i};
                        L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=Ls;
                        cropped_split_data(ceil(s.BoundingBox(i,2)):floor(s.BoundingBox(i,2))+s.BoundingBox(i,5),ceil(s.BoundingBox(i,1)):floor(s.BoundingBox(i,1))+s.BoundingBox(i,4),ceil(s.BoundingBox(i,3)):floor(s.BoundingBox(i,3))+s.BoundingBox(i,6))=cropped_split_data(ceil(s.BoundingBox(i,2)):floor(s.BoundingBox(i,2))+s.BoundingBox(i,5),ceil(s.BoundingBox(i,1)):floor(s.BoundingBox(i,1))+s.BoundingBox(i,4),ceil(s.BoundingBox(i,3)):floor(s.BoundingBox(i,3))+s.BoundingBox(i,6))&~s.Image{i};
                        add_entry(handles,L,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe),['subpatch N' num2str(k)]));
                        k=k+1;
                    end
                end
                if any(any(any((cropped_split_data(:,:,:)))))
                    L=false(data.header.Dimensions);
                    L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=cropped_split_data;
                    add_entry(handles,L,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe),'unseperated patches'));
                end
                remove_entry(labels(n));
                guidata(hObject, handles);
            end
        end
        populate_table(handles,true,false);
        delete (h);
    else
        h=custom_msgbox('Please select one or more valid labels for this operation!','','error',[],true);
    end
end

function [Body, App]=constrain_external_patches(Body, App,Surround)
D_App=bwdist(-App);
D_App(D_App>=sqrt(2))=0; %18 connectivity
D_App=logical(D_App);
%Base = [+1 +1 0 ; +1 -1 0 ; +1 0 +1 ; +1 0 -1; +1 0 0 ; 0 +1 0 ; 0 -1 0 ; 0 +1 +1 ; 0 0 +1 ; 0 -1 +1 ; 0 +1 -1 ; 0 0 -1 ; 0 -1 -1 ; -1 +1 0 ; -1 -1 0 ; -1 0 +1 ; -1 0 -1 ; -1 0 0];
s=regionprops3(App,'BoundingBox','VoxelIdxList');
for k=1:size(s,1)
    Neighbour_mask=D_App(max(ceil(s.BoundingBox(k,2))-1,1):ceil(s.BoundingBox(k,2))+s.BoundingBox(k,5),max(ceil(s.BoundingBox(k,1))-1,1):ceil(s.BoundingBox(k,1))+s.BoundingBox(k,4),max(ceil(s.BoundingBox(k,3))-1,1):ceil(s.BoundingBox(k,3))+s.BoundingBox(k,6));
    Surround_check=Surround(max(ceil(s.BoundingBox(k,2))-1,1):ceil(s.BoundingBox(k,2))+s.BoundingBox(k,5),max(ceil(s.BoundingBox(k,1))-1,1):ceil(s.BoundingBox(k,1))+s.BoundingBox(k,4),max(ceil(s.BoundingBox(k,3))-1,1):ceil(s.BoundingBox(k,3))+s.BoundingBox(k,6));
    invalid_internal=sum(sum(sum(Neighbour_mask)))==sum(sum(sum((Neighbour_mask&Surround_check))));
    if invalid_internal
        App(s.VoxelIdxList{k})=false;
        Body(s.VoxelIdxList{k})=true;
    end
end

function appendage_removal_Callback(hObject, ~, handles)
global data
global system

labels=str2num(handles.selected_labels.String);
answer=inputdlg({'Enter the applied reduction factor [vx]:','remove only patches with access to the exterior :'},'',1,{system.static.Operations.Remove_appendages.Value{1},system.static.Operations.Remove_appendages.Value{1}});

if ~isempty(answer)
    reduction_factor=str2num(answer{1});
    if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0&&isnumeric(reduction_factor)&&~isempty(reduction_factor)
        h=custom_msgbox('Please wait...removing appendages from volume data!','','help',[],false);
        for i=1:numel(labels)
            tbe=data.Labeltable.Label==labels(i);
            layer=data.Labeltable.Layer(tbe);
            L=data.Labelfield(:,:,:,layer);
            reduction_factor=round(reduction_factor);
            L(L~=labels(i))=0;
            [XR,YR,ZR]=extract_label_wb(logical(L),1);
            [L_new, App]=appendage_removal(logical(L(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))),reduction_factor);            
            if strcmpi(answer{2},'yes')                
                activelist=data.Labeltable.Label(data.Labeltable.Active);
                L_surr=ismember(data.Labelfield(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2),layer),activelist);
                
                L_surr=logical(L_surr)|data.basicshell.Binary(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2));
                [L_new, App]=constrain_external_patches(L_new,App,L_surr);                                
            end                                    
            if any(any(any(App)))              
                % refit the chopped data
                lab_vol=false(size(L));
                app_vol=false(size(L));
                lab_vol(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=L_new;
                app_vol(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=App;
                add_entry(handles,lab_vol,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),data.Labeltable.Name(tbe));
                add_entry(handles,app_vol,layer,data.Labeltable.MorphoUnit(tbe),'Externa',data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe),'externa'));
                remove_entry(labels(i));
                guidata(hObject, handles);
                delete (h);
            else
                delete (h);
                h=custom_msgbox('Operation unsuccessful! Please change the parameters!','','error',[],true);
            end
        end
        populate_table(handles,true,false);
    else
        h=custom_msgbox('Please select one or valid more labels and a reduction factor for this operation!','','error',[],true);
    end
end

function new_name=name_label(old_name, extension)
a=1;
old_name=old_name{1};
old_split=strsplit(old_name);
ex_split=strsplit(extension);
new_name=old_name;
for i=1:numel(ex_split)  
    if ~any(contains(old_split,ex_split(i)))
        new_name=[new_name ' ' ex_split{i}]; %#ok<AGROW>
    end
end

function [XR,YR,ZR]=extract_label_wb(labelfield,margin)
xsum=sum(sum(labelfield,3),2);
ysum=sum(squeeze(sum(labelfield,3)),1);
zsum=sum(squeeze(sum(labelfield,1)),1);
sizes=size(labelfield);
XR=[max(find(xsum,1,'first')-margin,1)  min(find(xsum,1,'last')+margin, sizes(1))];
YR=[max(find(ysum,1,'first')-margin,1) min(find(ysum,1,'last')+margin, sizes(2))];
ZR=[max(find(zsum,1,'first')-margin,1) min(find(zsum,1,'last')+margin, sizes(3))];

function combine_Callback(hObject, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
suggested_name=[derive_basic_name(labels(1)) ' and ' derive_basic_name(labels(2))];
suggested_name=regexprep(suggested_name,' +',' ');
new_name=inputdlg('Enter the name of the new label:','',1,{suggested_name});
if isempty(new_name)
    return
else
    if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0&&numel(unique(data.Labeltable.Layer(any(data.Labeltable.Label==labels,2))))==1
        h=custom_msgbox('Please wait a few seconds...combining label patches','','help',[],false);
        tbe=data.Labeltable.Label==labels(1);
        layer=data.Labeltable.Layer(tbe);
        merge_data=false(size(data.Labelfield(:,:,:,layer)));      
        merge_data(ismember(data.Labelfield(:,:,:,layer),labels))=1;
        add_entry(handles,merge_data,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),new_name);
        for i=1:numel(labels)
            remove_entry(labels(i));
        end
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h)
    else
        h=custom_msgbox('Please select one or more valid labels of the same layer for this operation!','','error',[],true);
    end
end

function suggested_layer=suggest_layer(labels)
global data
sl=mode(data.Labeltable.Layer(ismember(data.Labeltable.Label,labels)));
suggested_layer=sl+1;
if suggested_layer>4
    suggested_layer=1;
end
suggested_layer=num2str(suggested_layer);

function transfer_label_Callback(~, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
suggested_layer=suggest_layer(labels);
trg_layer=inputdlg('Enter the target layer for the tranfer operation:','',1,{suggested_layer});
if ~isempty(trg_layer)
    trg_layer=str2num(trg_layer{1});
    if size(data.Labelfield,4)<trg_layer
        add_layer(trg_layer-size(data.Labelfield,4))
    end
    
    h=custom_waitbar('Please wait...moving label(s)!',[],false);
    for i=1:numel(labels)
        index=find(data.Labeltable.Label==labels(i), 1);
        src_layer=data.Labeltable.Layer(index);
        src_field=data.Labelfield(:,:,:,src_layer);
        trg_field=data.Labelfield(:,:,:,trg_layer);
        F=ismember(src_field,labels(i));
        trg_field(F)=src_field(F);
        src_field(F)=0;
        data.Labelfield(:,:,:,src_layer)=src_field;
        data.Labelfield(:,:,:,trg_layer)=trg_field;
        data.Labeltable.Layer(index)=trg_layer;
    end
    populate_table(handles,true,false);
    delete (h);    
end

function merge_Callback(hObject, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
suggested_name=[derive_basic_name(labels(1)) ' and ' derive_basic_name(labels(2))];
suggested_name=regexprep(suggested_name,' +',' ');
new_name=inputdlg('Enter the name of the new label:','',1,{suggested_name});
if isempty(new_name)
    return
else
    if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))==2&&numel(unique(data.Labeltable.Layer(any(data.Labeltable.Label==labels,2))))==1
        h=custom_msgbox('Please wait a few seconds...merging label patches','','help',[],false);
        tbe=data.Labeltable.Label==labels(1);
        layer=data.Labeltable.Layer(tbe);
        merge_data=false(size(data.Labelfield(:,:,:,layer)));
        namelist=find(sum(data.Labeltable.Label==labels,2));
        new_name='';
        for k=1:numel(namelist)
            if ~isempty(data.Labeltable.Name{namelist(1)})
                if ~isempty(new_name)
                    new_name=[new_name ' & ' data.Labeltable.Name{namelist(k)}];  %#ok<AGROW>
                else
                    new_name=data.Labeltable.Name{namelist(k)};
                end
            end
        end
        merge_data(ismember(data.Labelfield(:,:,:,layer),labels))=1;
        s=regionprops3(merge_data,'Volume');
        if size(s,1)>2
            custom_msgbox({'More than two unconnected patches found! Reduce the number of selected patches to two and retry!'},'','warn')
            return
        elseif size(s,1)==2
            s=regionprops3(merge_data,'VoxelIdxList');
            SE=strel('sphere',1);
            MergV=false(size(merge_data));
            MergV(s.VoxelIdxList{1})=1;
            MergV(s.VoxelIdxList{2})=1;
            [XR,YR,ZR]=extract_label(MergV);
            MergV_cropped=MergV(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2));
            MergV_A=false(size(merge_data));
            MergV_A(s.VoxelIdxList{1})=1;
            MergV_A=MergV_A(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2));
            MergV_B=false(size(merge_data));
            MergV_B(s.VoxelIdxList{2})=1;
            MergV_B=MergV_B(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2));
            joint_voxels=0;
            rank=0;
            while joint_voxels==0
                rank=rank+1;
                SE=strel('sphere',rank);
                MergV_A_P=imdilate(MergV_A,SE);
                MergV_B_P=imdilate(MergV_B,SE);
                MergV_Joint=MergV_A_P&MergV_B_P;
                joint_voxels=sum(sum(sum(MergV_Joint)));
            end
            num_objs=3;
            rank=0;
            while num_objs>1
                rank=rank+1;
                SE=strel('sphere',rank);
                MergV_Joint_P=imdilate(MergV_Joint,SE);
                MergV_C=MergV_cropped|MergV_Joint_P;
                s=regionprops3(MergV_C,'Volume');
                num_objs=size(s,1);
            end
            SubV=zeros(size(merge_data));
            SubV(XR(1):XR(2),YR(1):YR(2),ZR(1):ZR(2))=MergV_C;
            SubV(data.basicshell.Binary)=0;
            add_entry(handles,SubV,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),{new_name});
            for i=1:numel(labels)
                remove_entry(labels(i));
            end
        else
            add_entry(handles,merge_data,layer,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),{new_name});
            for i=1:numel(labels)
                remove_entry(labels(i));
            end
        end
        guidata(hObject, handles);
        populate_table(handles,true,false);
    else
        h=custom_msgbox('Please select exactly two valid singular labels of the same layer for this operation!','','error',[],true);
    end
    delete (h)
end

function substract_Callback(hObject, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
suggested_layer=suggest_layer(labels);
answer=inputdlg({'Enter the name of the new label:','Enter the label to use as minuend:','Enter the label to use as subtrahend:','Enter the target layer'},'',1,{'Unnamed label',num2str(labels(1)),num2str(labels(2)),suggested_layer});
if isempty(answer)
    return
else    
    if isnumeric(str2num(answer{2}))&&isnumeric(str2num(answer{3}))&&isnumeric(str2num(answer{4}))
        new_name=answer{1};
        MH=str2num(answer{2});
        SH=str2num(answer{3});
        TL=str2num(answer{4});
        h=custom_msgbox('Please wait a few seconds...subtracting labels','','help',[],false);
        mh=data.Labeltable.Label==MH;
        sh=data.Labeltable.Label==SH;
        mh_layer=data.Labeltable.Layer(mh);
        sh_layer=data.Labeltable.Layer(sh);
        mh_data=ismember(data.Labelfield(:,:,:,mh_layer),MH);
        sh_data=ismember(data.Labelfield(:,:,:,sh_layer),SH);
        new_data=mh_data&~sh_data;
        if sum(sum(sum(new_data)))>0
            add_entry(handles,new_data,TL,data.Labeltable.MorphoUnit(mh),data.Labeltable.Class(mh),data.Labeltable.Group(mh),data.Labeltable.Type(mh),{new_name});
        else
            h=custom_msgbox('The difference of the two selected labels forms no new volume!','','error',[],true);
            return
        end
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h)
    else
        h=custom_msgbox('Please select exactly two valid labels for this operation!','','error',[],true);
        
    end
end

function intersect_Callback(hObject, ~, handles)
global data

labels=str2num(handles.selected_labels.String);
suggested_layer=suggest_layer(labels);
answer=inputdlg({'Enter the name for the new label:','Enter the target layer'},'',1,{'Unnamed label',suggested_layer});
if isempty(answer)
    return
else
    if isnumeric(str2num(answer{2}))
        Name=answer{1};
        TL=str2num(answer{2});
        
        h=custom_msgbox('Please wait a few seconds...subtracting labels','','help',[],false);
        l1=data.Labeltable.Label==labels(1);
        l2=data.Labeltable.Label==labels(2);
        l1_layer=data.Labeltable.Layer(l1);
        l2_layer=data.Labeltable.Layer(l2);
        l1_data=ismember(data.Labelfield(:,:,:,l1_layer),labels(1));
        l2_data=ismember(data.Labelfield(:,:,:,l2_layer),labels(2));
        new_data=l1_data&l2_data;
        if sum(sum(sum(new_data)))>0
            add_entry(handles,new_data,TL,data.Labeltable.MorphoUnit(l1),data.Labeltable.Class(l1),data.Labeltable.Group(l1),data.Labeltable.Type(l1),{Name});
        else
            h=custom_msgbox('The two selected labels do not intersect!','','error',[],true);
            return
        end
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h)
    else       
        h=custom_msgbox('Please select exactly two valid labels for this operation!','','error',[],true);     
    end
end

function label_individual_primary_shell_Callback(hObject, ~, handles)
global data
global patches
global system

label=str2num(handles.selected_labels.String);
tbe=data.Labeltable.Label==label;
suggested_name=[derive_basic_name(label) ' primary shell'];
suggested_name=regexprep(suggested_name,' +',' ');

answer=inputdlg({'Enter the name of the new label:','Select the wall detection method [Faces, Vertices or both]:',...
    'Allow wall gaps [Yes - No]:',...
    'Enter the maximum chamber wall width in percent of chamber 1st principal axis length [%]:',...
    'Enter the voxel radius for coverage of radial divergence [vx / max. 4]:',...
    'Enter the fraction of standard variation to add to the mean of the curve fit for the primary shell wall thickness [%]:',...
    '[EXPERIMENTAL] Generate secondary chamber wall [Yes - No]:'...
    'Target layer for shells [N]:'},...
    '',1,{suggested_name,system.static.Operations.Trace_chamber_wall.Value{1},system.static.Operations.Trace_chamber_wall.Value{2},system.static.Operations.Trace_chamber_wall.Value{3},system.static.Operations.Trace_chamber_wall.Value{4},system.static.Operations.Trace_chamber_wall.Value{5},'No','1'});
if ~isempty(answer)
    new_name=answer{1};
    method=strcmpi(answer(2),'faces')*1+strcmpi(answer(2),'vertices')*2+strcmpi(answer(2),'both')*3;
    gap_allow=strcmpi(answer(3),'yes');
    max_width_p=str2num(answer{4})/100;
    cone_rays=str2num(answer{5});
    fraction_spread=str2num(answer{6})/100;
    gen_secondary=strcmpi(answer(7),'yes');
    target_layer=str2num(answer{8});
    max_width=10;
    h=custom_msgbox('Please wait...tracing individual primary chamber wall!','','help',[],false);
    
    cname=['L' num2str(label,'%04u')];
    cur_MU=data.Labeltable.MorphoUnit(data.Labeltable.Label==label);
    max_width=max([max_width data.volumedata.(cname).PrincipalAxisLength(1)*max_width_p]);
    lower_MU=data.Labeltable.Label(data.Labeltable.MorphoUnit<cur_MU-1);
    previous_MU=data.Labeltable.Label(data.Labeltable.MorphoUnit==cur_MU-1);
    following_MU=data.Labeltable.Label(data.Labeltable.MorphoUnit==cur_MU+1&strcmp(data.Labeltable.Class,'Lumen'));
    higher_MU=data.Labeltable.Label(data.Labeltable.MorphoUnit>cur_MU+1&strcmp(data.Labeltable.Class,'Lumen'));
    non_active=data.Labeltable.Label(~data.Labeltable.Active);
    L=zeros(data.header.Dimensions);
    L(ismember(data.Labelfield(:,:,:,1),non_active))=0;
    L(ismember(data.Labelfield(:,:,:,1),data.Labeltable.Label(cur_MU)))=1;
    L(ismember(data.Labelfield(:,:,:,1),lower_MU))=2;
    L(ismember(data.Labelfield(:,:,:,1),previous_MU))=3;
    L(ismember(data.Labelfield(:,:,:,1),following_MU))=4;
    L(ismember(data.Labelfield(:,:,:,1),higher_MU))=5;
    if isempty(following_MU)
        ignoreMU=true;
    else
        ignoreMU=false;
    end
    [PS, SCS]=trace_shell(label,L,data.basicshell.Binary,ignoreMU,method,gap_allow,cone_rays,max_width,fraction_spread,gen_secondary);
    PS(ismember(L,2)|ismember(L,3))=0;
    tbe=data.Labeltable.Label==label;
    add_entry(handles,PS,target_layer,data.Labeltable.MorphoUnit(tbe),{'Shell'},{'primary'},{''},{new_name});
    
    if sum(sum(sum(SCS)))>0&&gen_secondary
        SCS(logical(L))=0;
        SCS(~data.basicshell.Binary)=0;
        new_name_2=[strrep(data.Labeltable.Name{data.Labeltable.Label==label},' lumen',''),' secondary shell'];
        tbe=data.Labeltable.Label==label;
        add_entry(handles,SCS,target_layer,data.Labeltable.MorphoUnit(tbe),{'Shell'},{''},{''},{new_name_2});
    end
    
    guidata(hObject, handles);
    populate_table(handles,true,false);
    delete(h);
else
    h=custom_msgbox('Please enter valid parameter settings for this oparation!','','error',[],true);
end

%%% here we are

function delimit_in_situ_Callback(hObject, ~, handles)
global data
global system
global supplementary

% we need an option for cycling over many lables with external AO
label=str2num(handles.selected_labels.String);
if ~isempty(label)&&sum(any(data.Labeltable.Label==label))==1
    if ~isempty(supplementary)
        answer=inputdlg({'Enter the margin width for the consideration of the ambient occlusion field [vx]:','Enter the expansion factor for the volume [vx x 2]:','Enter additional labels whose boundaries can be ignored and might be modified:','Enter the target layer'},'',1,{system.static.Operations.Delimit_in_situ.Value{1},system.static.Operations.Delimit_in_situ.Value{3},'[]','1'});
        if ~isempty(answer)&&isnumeric(str2num(answer{1}))&&isnumeric(str2num(answer{2}))
            MW=str2num(answer{1});            
            EF=str2num(answer{2});
            AL=answer{3};
            TL=str2num(answer{4});
        else
            return
        end
    else
        answer=inputdlg({'Enter the margin width for the calculation of the ambient occlusion field [vx]:','Enter the number of rays [N]:', 'Enter the expansion factor for the volume [vx x 2]:','Enter additional labels whose boundaries can be ignored and might be modified:','Enter the target layer'},'',1,{system.static.Operations.Delimit_in_situ.Value{1},system.static.Operations.Delimit_in_situ.Value{2},system.static.Operations.Delimit_in_situ.Value{3},'[]','1'});
        if ~isempty(answer)&&isnumeric(str2num(answer{1}))&&isnumeric(str2num(answer{2}))&&isnumeric(str2num(answer{3}))
            MW=str2num(answer{1});        
            rays=str2num(answer{2});            
            EF=str2num(answer{3});
            AL=answer{4};
            TL=str2num(answer{5});
        else
            return
        end
    end
    h=custom_msgbox('Please wait...preparing label data!','','help',[],false);
    tbe=data.Labeltable.Label==label;
    region=any(ismember(data.Labelfield,label),4);    
    active=data.Labeltable.Label(data.Labeltable.Active);    
    if ~isempty(AL)
        add_labels=str2num(AL);
        active(ismember(active,add_labels))=[];
    end    
    mask=ismember(data.Labelfield,active);
    mask=any(logical(mask),4);
    mask(ismember(data.Labelfield(:,:,:,data.Labeltable.Layer(tbe)),label))=0;
    ref_size=data.header.Dimensions;
    mask(data.basicshell.Binary)=true;
    ExpandedLabel=logical(region);
    SE=strel('sphere',2);
    for i=1:EF
        ExpandedLabel=imdilate(ExpandedLabel,SE);
        ExpandedLabel(mask)=false;
    end  
    [XR,YR,ZR]=extract_label(ExpandedLabel);
    boundaries=[XR;YR;ZR]+[-MW MW];
    if any(any(boundaries<1))||boundaries(1,2)>ref_size(1)||boundaries(2,2)>ref_size(2)||boundaries(3,2)>ref_size(3)
        boundaries(boundaries<1)=1;
        if boundaries(1,2)>ref_size(1)
            boundaries(1,2)=ref_size(1);
        end
        if boundaries(2,2)>ref_size(2)
            boundaries(2,2)=ref_size(2);
        end
        if boundaries(3,2)>ref_size(3)
            boundaries(3,2)=ref_size(3);
        end
    end
    Mask=mask(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));    
    Binary=logical(ExpandedLabel(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2)));
    % existence check for supplementary
    if system.temp.has_external_AO
        ACs=supplementary.AmbientOcclusion(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));
        ACs(~Binary)=0;
    else
        raylength=floor(sqrt(sum((size(Binary)/2).^2)));
        AC=ambient_occlusion(Binary,Mask,rays,raylength);
        ACs=specialsmooth3d(AC,5,2);
        ACs=specialsmooth3d(ACs,7,3);
    end
    [PreLumenOut,PreExternaOut,Lim]=delimit(Binary,ACs);        
    if ~isempty(Lim)
        Surround=PreLumenOut|data.basicshell.Binary(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));
        [PreLumenOut, PreExternaOut]=constrain_external_patches(PreLumenOut,PreExternaOut,Surround);
        LumenOut=false(size(region));
        ExternaOut=false(size(region));
        LumenOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=PreLumenOut;
        ExternaOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=PreExternaOut;
        if ~isempty(AL)
            for n=1:numel(add_labels)
                AL_region=any(ismember(data.Labelfield,add_labels(n)),4);    
                AL_region=AL_region&~ExternaOut&~LumenOut;
                abe=data.Labeltable.Label==add_labels(n);
                add_entry(handles,AL_region,TL,data.Labeltable.MorphoUnit(abe),data.Labeltable.Class(abe),data.Labeltable.Group(abe),data.Labeltable.Type(abe),[data.Labeltable.Name{abe} 'delimited']);                       
            end
        end
        add_entry(handles,LumenOut,TL,data.Labeltable.MorphoUnit(tbe),data.Labeltable.Class(tbe),data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),[data.Labeltable.Name{tbe} 'delimited']);
        add_entry(handles,ExternaOut,TL,data.Labeltable.MorphoUnit(tbe),'Externa',data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe),'externa'));
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h);
    else
        h=custom_msgbox('No gradient in ambient occlusion data found!','','error',[],true);
        return
    end
else
    h=custom_msgbox('Please select one valid label for this operation!','','error',[],true);
end

function suggest=derive_basic_name(label)
global data

tbe=data.Labeltable.Label==label;
old_name=data.Labeltable.Name{tbe};
suggest=replace(old_name,{'shell','primary','secondary','complete' 'lumen' 'in situ'},'');
temp2=suggest;
temp1='';    
while ~strcmp(temp1,temp2)
  temp1=temp2;
  temp2=regexprep(temp1,'  ',' ');
end
suggest=temp2;

function delimit_special_Callback(~, ~, handles)
global data

label=str2num(handles.selected_labels.String);
if ~isempty(label)&&sum(any(data.Labeltable.Label==label))==1
    tbe=data.Labeltable.Label==label;
    layer=data.Labeltable.Layer(tbe);
    answer=inputdlg({'Enter the shell labels to consider:','Enter the margin width for the calculation of the ambient occlusion field:','Enter the number of rays:', 'Enter the expansion factor for the volume:','Enter the destination layer for the new labels:'},'',1,{'X','40','50','8',num2str(layer+1)});
    if ~isempty(answer)
        LB=answer{1};
        MW=str2num(answer{2});
        rays=str2num(answer{3});
        EF=str2num(answer{4});
        DL=str2num(answer{5});
    else
        return
    end
    
    h=custom_msgbox('Please wait...preparing label data!','','help',[],false);
    if size(data.Labelfield,4)<DL
        add_layer(DL-size(data.Labelfield,4))
    end
    ref_size=data.header.Dimensions;
    labellist=str2double(strsplit(LB))';
    current_shell_list=data.Labeltable.Label(strcmp(data.Labeltable.Class,'Shell'));
    considered_labellist=ismember(current_shell_list,labellist);
    region=data.Labelfield(:,:,:,layer);
    region(region~=label)=0;
    A=logical(region);
    SE=strel('sphere',2);
    current_shell=any(ismember(data.Labelfield,labellist),4);
    mask=current_shell;
    for i=1:EF
        A=imdilate(A,SE);
        A(mask)=false;
    end
    [XR,YR,ZR]=extract_label(A);
    boundaries=[XR;YR;ZR]+[-MW MW];
    if any(any(boundaries<1))||boundaries(1,2)>ref_size(1)||boundaries(2,2)>ref_size(2)||boundaries(3,2)>ref_size(3)
        boundaries(boundaries<1)=1;
        if boundaries(1,2)>ref_size(1)
            boundaries(1,2)=ref_size(1);
        end
        if boundaries(2,2)>ref_size(2)
            boundaries(2,2)=ref_size(2);
        end
        if boundaries(3,2)>ref_size(3)
            boundaries(3,2)=ref_size(3);
        end
    end
    Mask=current_shell(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));
    Binary=logical(A(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2)));
    Binary(Mask)=false; % odd safety
    raylength=floor(sqrt(sum((size(Binary)/2).^2)));
    AC=ambient_occlusion(Binary,Mask,rays,raylength);
    ACs=specialsmooth3d(AC,5,2);
    ACs=specialsmooth3d(ACs,7,3);
    
    [PreLumenOut,PreExternaOut,Lim]=delimit(Binary,ACs);
    if ~isempty(Lim)
        LumenOut=false(size(region));
        ExternaOut=false(size(region));
        LumenOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=PreLumenOut;
        ExternaOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=PreExternaOut;
        ExternaOut=region&ExternaOut;
        add_entry(handles,LumenOut,DL,data.Labeltable.MorphoUnit(tbe),'Lumen',data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe),'special delimited'));
        add_entry(handles,ExternaOut,DL,data.Labeltable.MorphoUnit(tbe),'Lumen',data.Labeltable.Group(tbe),data.Labeltable.Type(tbe),name_label(data.Labeltable.Name(tbe), 'externa'));
        populate_table(handles,true,false);
        delete (h);
    else
        h=custom_msgbox('No gradient in ambient occlusion data found!','','error',[],true);
        return
    end
else
    h=custom_msgbox('Please select one valid label for this operation!','','error',[],true);
end

function delimit_in_vivo_Callback(hObject, ~, handles)
global data
global system

label=str2num(handles.selected_labels.String);
if ~isempty(label)&&sum(any(data.Labeltable.Label==label))==1    
    tbe=data.Labeltable.Label==label;
    suggested_name=[derive_basic_name(label) ' in vivo lumen'];
    suggested_name=regexprep(suggested_name,' +',' ');      
    ant_ind=data.Labeltable.MorphoUnit==data.Labeltable.MorphoUnit(tbe)+1&strcmp(data.Labeltable.Class,'Lumen')&contains(data.Labeltable.Group,'vivo');
    if isempty(find(ant_ind, 1))
        suggested_ind='';
    else        
        suggested_ind=[num2str(data.Labeltable.Label(find(ant_ind,1,'first'))) ' - ' data.Labeltable.Name{find(ant_ind,1,'first')}];
    end
        
    answer=inputdlg({'Enter the name for the new label:','Enter the margin width for the calculation of the ambient occlusion field [vx]:','Enter the number of rays [N]:','Enter the expansion factor for the volume [vx]:','Enter the shell layer to consider:','Enter the lumen layer to consider:','Enter the morphounits to consider [optional]:','Enter the target layer:','Add anterior appendage to label [N - (Name)]:'},'',1,{suggested_name,system.static.Operations.Delimit_in_vivo.Value{1},system.static.Operations.Delimit_in_vivo.Value{2},system.static.Operations.Delimit_in_vivo.Value{3},system.static.Operations.Delimit_in_vivo.Value{4},system.static.Operations.Delimit_in_vivo.Value{5},'','2',suggested_ind});
    if ~isempty(answer)&&isnumeric(str2num(answer{1}))&&isnumeric(str2num(answer{2}))&&isnumeric(str2num(answer{3}))&&isnumeric(str2num(answer{4}))&&isnumeric(str2num(answer{5}))&&isnumeric(str2num(answer{6}))&&isnumeric(str2num(answer{7}))        
        new_name=answer{1};
        MW=str2num(answer{2});
        rays=str2num(answer{3});      
        EF=str2num(answer{4});
        SL=str2num(answer{5});
        LL=str2num(answer{6});
        SLTC=answer{7};
        TL=str2num(answer{8});   
        dummy=strsplit(answer{9},'-');
        TAL=str2num(dummy{1});   
    else
        return
    end
    h=custom_msgbox('Please wait...preparing label data!','','help',[],false);   
    layer=data.Labeltable.Layer(tbe);
    ref_size=data.header.Dimensions;
    current_shell_label_list=data.Labeltable.Label(strcmp(data.Labeltable.Class,'Shell')&data.Labeltable.Active&data.Labeltable.Layer==SL&data.Labeltable.MorphoUnit<=data.Labeltable.MorphoUnit(tbe));
    current_shell_MU_list=data.Labeltable.MorphoUnit(strcmp(data.Labeltable.Class,'Shell')&data.Labeltable.Active&data.Labeltable.Layer==SL&data.Labeltable.MorphoUnit<=data.Labeltable.MorphoUnit(tbe));
    current_lower_lumen_label_list=data.Labeltable.Label(strcmp(data.Labeltable.Class,'Lumen')&data.Labeltable.Layer==LL&data.Labeltable.Active&data.Labeltable.MorphoUnit<data.Labeltable.MorphoUnit(tbe));
    current_lower_lumen_MU_list=data.Labeltable.MorphoUnit(strcmp(data.Labeltable.Class,'Lumen')&data.Labeltable.Layer==LL&data.Labeltable.Active&data.Labeltable.MorphoUnit<data.Labeltable.MorphoUnit(tbe));
    current_upper_lumen_label_list=data.Labeltable.Label(strcmp(data.Labeltable.Class,'Lumen')&data.Labeltable.Layer==TL&data.Labeltable.Active&data.Labeltable.MorphoUnit>data.Labeltable.MorphoUnit(tbe));        
    current_upper_lumen_MU_list=data.Labeltable.MorphoUnit(strcmp(data.Labeltable.Class,'Lumen')&data.Labeltable.Layer==TL&data.Labeltable.Active&data.Labeltable.MorphoUnit>data.Labeltable.MorphoUnit(tbe));        
    lumen=data.Labelfield(:,:,:,layer);
    lumen(lumen~=label)=0;
    lumen=logical(lumen);            
    
    inc_MU_list=str2double(strsplit(SLTC))';
    if contains(SLTC,'-')
        inc_MU_range=str2double(strsplit(SLTC,'-'))';
    else
        inc_MU_range=NaN;
    end
    if ~isnan(inc_MU_list)
        current_shell_label_list(~ismember(current_shell_MU_list,[inc_MU_list;data.Labeltable.MorphoUnit(tbe)]))=[];        
        current_lower_lumen_label_list(~ismember(current_lower_lumen_MU_list,inc_MU_list))=[];       
        current_upper_lumen_label_list(~ismember(current_upper_lumen_MU_list,inc_MU_list))=[];
    end
    if ~isnan(inc_MU_range)&&numel(inc_MU_range)>1
        range=inc_MU_range(1):inc_MU_range(2);
        current_shell_label_list(~ismember(current_shell_MU_list,range))=[];
        current_lower_lumen_label_list(~ismember(current_lower_lumen_MU_list,range))=[];
        current_upper_lumen_label_list(~ismember(current_upper_lumen_MU_list,range))=[];
    end
    current_shell=ismember(data.Labelfield(:,:,:,SL),current_shell_label_list);    
    current_lower_lumen=ismember(data.Labelfield(:,:,:,LL),current_lower_lumen_label_list);      
    
    %mask=current_shell|current_lower_lumen;
    mask=current_shell;
    if size(data.Labelfield,4)>=TL
        current_upper_lumen=ismember(data.Labelfield(:,:,:,TL),current_upper_lumen_label_list);
    else
        current_upper_lumen=true(size(lumen));
    end
    SE=strel('sphere',2);
    for i=1:EF
        lumen=imdilate(lumen,SE);
        lumen(mask)=false;    
    end    
    [XR,YR,ZR]=extract_label(lumen);
    boundaries=[XR;YR;ZR]+[-MW MW];
    if any(any(boundaries<1))||boundaries(1,2)>ref_size(1)||boundaries(2,2)>ref_size(2)||boundaries(3,2)>ref_size(3)
        boundaries(boundaries<1)=1;
        if boundaries(1,2)>ref_size(1)
            boundaries(1,2)=ref_size(1);
        end
        if boundaries(2,2)>ref_size(2)
            boundaries(2,2)=ref_size(2);
        end
        if boundaries(3,2)>ref_size(3)
            boundaries(3,2)=ref_size(3);
        end
    end
    mask=mask(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));
    lumen=logical(lumen(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2)));    
    raylength=floor(sqrt(sum((size(lumen)/2).^2)));
    AC=ambient_occlusion(lumen,mask,rays,raylength);
    ACs=specialsmooth3d(AC,5,2);
    ACs=specialsmooth3d(ACs,7,3);
    [PreLumenOut,PreExternaOut,Lim]=delimit(lumen,ACs);        
    if ~isempty(Lim)        
        ExternaOut=false(ref_size);
        externa=lumen&PreExternaOut&~current_upper_lumen(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));        
        ExternaOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=externa;
        ExternaOut=ExternaOut&~data.basicshell.Binary;
        LumenOut=false(ref_size);
        lumen=lumen&PreLumenOut;
        LumenOut(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=lumen;
        LumenOut=LumenOut&~data.basicshell.Binary;        
        if sum(sum(sum(LumenOut)))>0
            add_entry(handles,LumenOut,TL,data.Labeltable.MorphoUnit(tbe),'Lumen','in vivo',data.Labeltable.Type(tbe),new_name);
        end
        if sum(sum(sum(ExternaOut)))>0
            if isempty(TAL)                
                add_entry(handles,ExternaOut,TL,data.Labeltable.MorphoUnit(tbe)+1,'Lumen','in vivo',data.Labeltable.Type(tbe),[data.Labeltable.Name{tbe} ' anterior appendage']);
            else
                ExternaOut=any(ismember(data.Labelfield(:,:,:,:),TAL),4)|ExternaOut;
                tbe2=data.Labeltable.Label==TAL;                
                add_entry(handles,ExternaOut,TL,data.Labeltable.MorphoUnit(tbe2),'Lumen',data.Labeltable.Group(tbe2),data.Labeltable.Type(tbe2),data.Labeltable.Name(tbe2));
                remove_entry(TAL);
            end
            
        end
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h);
    else
        delete (h);
        h=custom_msgbox('No gradient in ambient occlusion data found!','','error',[],true);
        return
    end
else  
    h=custom_msgbox('Please select one valid label for this operation!','','error',[],true);
end

function delimit_convex_Callback(hObject, ~, handles)
global data
global system

label=str2num(handles.selected_labels.String);
if ~isempty(label)&&sum(any(data.Labeltable.Label==label))==1    
    tbe=data.Labeltable.Label==label;    
    suggested_name=[derive_basic_name(label) ' shell derived lumen'];    
    suggested_name=regexprep(suggested_name,' +',' ');
    cname=['L' num2str(label,'%04u')];
    suggested_radius=round(data.volumedata.(cname).PrincipalAxisLength(1)*0.025);
    answer=inputdlg({'Enter the name of the new label:','Enter the reduction element radius [vx]:','Remove lower growth stage lumina [yes/no]:','Enter the lumen layer to consider [N]:', 'Enter the target layer [N]:'},'',1,{suggested_name,num2str(suggested_radius),system.static.Operations.Delimit_convex_individual.Value{1},system.static.Operations.Delimit_convex_individual.Value{1},'3'});
    if ~isempty(answer)
        new_name=answer{1};
        RE=str2num(answer{2});          
        RLL=strcmpi(answer{3},'yes');
        LL=str2num(answer{4});          
        TL=str2num(answer{5});              
    else
        return
    end
    h=custom_msgbox('Please wait...preparing label data!','','help',[],false);
    
    current_layer=data.Labeltable.Layer(tbe);
    PS=ismember(data.Labelfield(:,:,:,current_layer),label);
   
    ref_size=data.header.Dimensions;
    MW=0;
    [XR,YR,ZR]=extract_label(PS);
    boundaries=[XR;YR;ZR]+[-MW MW];
    if any(any(boundaries<1))||boundaries(1,2)>ref_size(1)||boundaries(2,2)>ref_size(2)||boundaries(3,2)>ref_size(3)
        boundaries(boundaries<1)=1;
        if boundaries(1,2)>ref_size(1)
            boundaries(1,2)=ref_size(1);
        end
        if boundaries(2,2)>ref_size(2)
            boundaries(2,2)=ref_size(2);
        end
        if boundaries(3,2)>ref_size(3)
            boundaries(3,2)=ref_size(3);
        end
    end
    PS=logical(PS(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2)));
    CV=workaround_R17b_convex_image_bug(PS);    
    %PS_inf=data.basicshell.Binary(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2));
    
    s=regionprops3(CV,'Volume','BoundingBox','Image');
    main_vol=find(s.Volume==max(s.Volume),1,'first');
    Ls=false(size(CV));
    Ls(ceil(s.BoundingBox(main_vol,2)):floor(s.BoundingBox(main_vol,2))+s.BoundingBox(main_vol,5),ceil(s.BoundingBox(main_vol,1)):floor(s.BoundingBox(main_vol,1))+s.BoundingBox(main_vol,4),ceil(s.BoundingBox(main_vol,3)):floor(s.BoundingBox(main_vol,3))+s.BoundingBox(main_vol,6))=s.Image{main_vol};
    
    CVf=false(ref_size);
    CVf(boundaries(1,1):boundaries(1,2),boundaries(2,1):boundaries(2,2),boundaries(3,1):boundaries(3,2))=Ls;
    CVf=CVf&~data.basicshell.Binary;
    
    if  RLL
        current_lower_lumen_list=data.Labeltable.Label(strcmp(data.Labeltable.Class,'Lumen')&data.Labeltable.Layer==LL&data.Labeltable.Active&data.Labeltable.MorphoUnit<data.Labeltable.MorphoUnit(tbe));
        current_lower_lumen=ismember(data.Labelfield(:,:,:,LL),current_lower_lumen_list);        
        CVf=CVf&~current_lower_lumen;
    end
    if RE>0
        SE=strel('sphere',RE);
        CVf=imopen(CVf,SE);        
    end          
    if sum(sum(sum(Ls)))>1
        add_entry(handles,CVf,TL,data.Labeltable.MorphoUnit(tbe),'Lumen','shell derived','convex',new_name);        
        guidata(hObject, handles);
        populate_table(handles,true,false);
        delete (h);
    else
        h=custom_msgbox('No volume remains after delimitation process!','','error',[],true);
        return
    end
else
    h=custom_msgbox('Please select one valid label for this operation!','','error',[],true);
end

function CIf=workaround_R17b_convex_image_bug (Binary)

CIn=regionprops3(Binary,'BoundingBox','Image','ConvexImage');
SBsize=size(CIn.Image{1});
LargerDim=(size(CIn.Image{1},1)<size(CIn.Image{1},2))+1;
SmallerDim=mod(LargerDim,2)+1;
CIflip=regionprops3(flip(Binary,LargerDim),'ConvexImage');
CI=false(SBsize);
CI(1:SBsize(SmallerDim),1:SBsize(SmallerDim),:)=CIn.ConvexImage{1}(1:SBsize(SmallerDim),1:SBsize(SmallerDim),:);
SizeDiff=SBsize(LargerDim)-SBsize(SmallerDim);
if LargerDim==1   
    CI(end-SizeDiff+1:end,:,:)=flipud(CIflip.ConvexImage{1}(1:SizeDiff,1:SBsize(SmallerDim),:));
else
    CI(:,end-SizeDiff+1:end,:)=fliplr(CIflip.ConvexImage{1}(1:SBsize(SmallerDim),1:SizeDiff,:));
end
CIf=false(size(Binary));
CIf(ceil(CIn.BoundingBox(1,2)):floor(CIn.BoundingBox(1,2)+CIn.BoundingBox(1,5)),ceil(CIn.BoundingBox(1,1)):floor(CIn.BoundingBox(1,1)+CIn.BoundingBox(1,4)),ceil(CIn.BoundingBox(1,3)):(floor(CIn.BoundingBox(1,3)+CIn.BoundingBox(1,6))))=CI;
    
%%% label operations backend functions %%%
function remove_entry(label)
global data
global patches
global system

index=find(data.Labeltable.Label==label, 1);
patch_name=['L' num2str(label,'%04u')];
delete(patches.(patch_name));
patches=rmfield(patches,patch_name);
data.volumedata=rmfield(data.volumedata,patch_name);
data.patchdata=rmfield(data.patchdata,patch_name);
data.Labelfield(data.Labelfield==label)=0;
data.Labeltable(index,:)=[];
system.TempLabeltable(index,:)=[];

function new_label=add_entry(handles,singular_labelfield,layer,morphounit,class,group,type,name)
global data
global patches
global system
global GlobalHandles

if size(data.Labelfield,4)<layer
    add_layer(layer-size(data.Labelfield,4))
end
new_Labelfield=data.Labelfield(:,:,:,layer);
new_label=max(data.Labeltable.Label)+1;
new_table_pos=size(data.Labeltable,1)+1;
patch_new_name=['L' num2str(new_label,'%04u')];

SubV=logical(singular_labelfield);
SubVsm=smooth3(SubV,'gaussian'); % default is size 3 sd 0.65
fv=isosurface(SubVsm,system.defaults.patch_margin);
data.patchdata.(patch_new_name).normal=fv;
SubVsm=smooth3(SubV,'gaussian',[5 5 5], 3);
fv=isosurface(SubVsm,system.defaults.patch_margin);
data.patchdata.(patch_new_name).smoothed=fv;
s=regionprops3(SubV,'Volume','Centroid','Extent','PrincipalAxisLength','ConvexVolume', 'Solidity','SurfaceArea','EquivDiameter','Orientation');
distSubV=bwdist(~SubV);
distSubV(distSubV~=1)=0;
sd=regionprops3(distSubV,'VoxelList');
v=[];
f=[];
if size(sd,1)>1
    for k=1:size(sd,1)
        [vert, fac] = voxel_image(sd.VoxelList{k});
        v=[v;vert];  %#ok<AGROW>
        f=[f;fac];  %#ok<AGROW>
    end
else
    if numel(sd.VoxelList)==3
        [v, f] = voxel_image(sd.VoxelList);
    else        
        [v, f] = voxel_image(sd.VoxelList{1});
    end
end
data.patchdata.(patch_new_name).voxels.vertices=v;
data.patchdata.(patch_new_name).voxels.faces=f;

i=find(s.Volume==max(s.Volume),1,'first');
if ~isempty(s)
    new_Labelfield(logical(singular_labelfield))=new_label;
    data.Labelfield(:,:,:,layer)=new_Labelfield;
    newRow=data.Labeltable(1,:);
    newRow.Label=new_label;
    newRow.Layer=layer;
    newRow.Class=class;
    newRow.Group=group;
    newRow.Type=type;
    newRow.Name=name;
    newRow.Active=true;
    newRow.MorphoUnit=morphounit;
    
    newTempRow=system.TempLabeltable(1,:);
    newTempRow.Label=new_label;
    newTempRow.show=true;
    newTempRow.selected=true;
    newTempRow.Distance=pdistance(s.Centroid(i,:),system.temp.current_center);    
    GlobalHandles.SelectedFieldHandle.String=[GlobalHandles.SelectedFieldHandle.String ' ' num2str(new_label)];        
    system.TempLabeltable=[system.TempLabeltable;newTempRow];
    data.Labeltable=[data.Labeltable;newRow];
    data.volumedata.(patch_new_name).Patches=size(s,1);
    data.volumedata.(patch_new_name).Volume=s.Volume(i);
    data.volumedata.(patch_new_name).Centroid=s.Centroid(i,:);
    data.volumedata.(patch_new_name).PrincipalAxisLength=s.PrincipalAxisLength(i,:);
    data.volumedata.(patch_new_name).Orientation=s.Orientation(i,:);
    data.volumedata.(patch_new_name).SurfaceArea=s.SurfaceArea(i);
    data.volumedata.(patch_new_name).Solidity=s.Solidity(i);
    data.volumedata.(patch_new_name).Extent=s.Extent(i);
    data.volumedata.(patch_new_name).Convexvolume=s.ConvexVolume(i);
    data.volumedata.(patch_new_name).EquivDiameter=s.EquivDiameter(i);
    patches.(patch_new_name)=patch(handles.Axes,data.patchdata.(patch_new_name).normal,'Tag',patch_new_name,'FaceColor',system.corollary.colormap(new_label,:),'ButtonDownFcn',@patchhittest,'EdgeColor',[0 0 0],'FaceLighting','gouraud','SpecularStrength',system.corollary.light_specular,'AmbientStrength',system.corollary.light_ambient,'DiffuseStrength',system.corollary.light_diffuse,'Visible','on');
end

function LumenOut=split_volume(LumenIn,N)
D=bwdist(~LumenIn,'euclidean');
D=rescale(D,0,1);
pieces=N+1;
hminlevs=0:0.05:0.2;
n=1;
L=zeros(size(D));
while pieces>=N&&n<numel(hminlevs)
    old_L=L;
    M=imhmin(-D,hminlevs(n),26);
    L=watershed(M,26);
    L(~LumenIn)=0;
    S=regionprops3(L,'Volume');
    pieces=numel(find([S.Volume]>0));
    n=n+1;
end
LumenOut=L;

function [LumenOut, Appendage]=appendage_removal(LumenIn,RF)
try
    D_norm=bwdist(~LumenIn);
    L_red=D_norm>RF;
    s=regionprops3(L_red,'Volume','BoundingBox','Image');
    largest=find(s.Volume==max(s.Volume));
    L_red_clean=false(size(LumenIn));
    L_red_clean(ceil(s.BoundingBox(largest,2)):floor(s.BoundingBox(largest,2)+s.BoundingBox(largest,5)),ceil(s.BoundingBox(largest,1)):floor(s.BoundingBox(largest,1)+s.BoundingBox(largest,4)),ceil(s.BoundingBox(largest,3)):(floor(s.BoundingBox(largest,3)+s.BoundingBox(largest,6))))=s.Image{largest};
    D_red_clean_inv=bwdist(L_red_clean);
    LumenOut=(D_red_clean_inv<(RF+1)&LumenIn);
    Appendage=xor(LumenIn,LumenOut);
catch
    Appendage=[0 0 0];
    LumenOut=[0 0 0];
end

function [first_sequence_shell_voxels,current_MU_shell_voxel_coordinates,current_MU_shell,current_primary_MU_shell,subject_to_sec_calc,inside_wall,outside_wall,shell_overflow,shell_error]=find_shell_cross_section(source,norm,dist,gap_allow,vol,bin_vol)

shell_overflow=false;
shell_error=false;
first_sequence_shell_voxels=0;
current_MU_shell=false;
current_primary_MU_shell=false;
subject_to_sec_calc=false;
current_MU_shell_voxel_coordinates=0;
inside_wall=false;
outside_wall=false;

P_pos_shell=source+norm.*(0:dist)';
P_pos_shell=round(P_pos_shell);
P_pos_shell=unique(P_pos_shell,'rows');

to_del=P_pos_shell(:,1)>size(vol,2);
to_del=to_del|P_pos_shell(:,1)<1;
to_del=to_del|P_pos_shell(:,2)>size(vol,1);
to_del=to_del|P_pos_shell(:,2)<1;
to_del=to_del|P_pos_shell(:,3)>size(vol,3);
to_del=to_del|P_pos_shell(:,3)<1;
P_pos_shell(to_del,:)=[];
distances=sum((round(source)-P_pos_shell).^2,2).^0.5;
sequence_length=numel(distances);
[~,idx]=sort(distances);

P_pos_shell=P_pos_shell(idx,:);
indices=sub2ind(size(vol),P_pos_shell(:,2),P_pos_shell(:,1),P_pos_shell(:,3));
s=bin_vol(indices); %binary shell line

if sum(s)>0 % shell found
    distances=distances(idx);
    ch=vol(indices);
    total_shell_voxels=sum(s); % total shell voxels
    if gap_allow
        gaps=[0; 0; s(2:end-1)-s(3:end)<0&s(3:end)-s(2:end-1)]>0;
        s(gaps)=true;
    end
    fifs=find(s,1,'first'); % first in first sequence
    FIFS_distance=distances(fifs);
    lifs=fifs+find(~s(fifs+1:end),1,'first')-1; % last in first sequence
    lils=find(s,1,'last'); % last in last sequence 
    current_MU_shell_voxel_coordinates=[distances(s(fifs:lifs)) P_pos_shell(s(fifs:lifs),1) P_pos_shell(s(fifs:lifs),2) P_pos_shell(s(fifs:lifs),3)];
    if isempty(lifs)||lifs>sequence_length-2 % at least two empty voxels at the end of the sequence
        shell_overflow=true;
    else
        first_sequence_shell_voxels=distances(lifs)-distances(fifs);
        if ch(lifs+1)==4 % first voxel after the first shell sequence are the following MU lumen
            current_primary_MU_shell=true;
            current_MU_shell=true;
            inside_wall=true;
        elseif ch(lifs+1)>=4% first voxel after the first shell sequence are higher MU lumen
            subject_to_sec_calc=true;
            current_MU_shell=true;
            inside_wall=true;
        elseif all(ch(lifs+1:end)==0) % all voxels after the first shell sequence are empty space
            current_MU_shell=true;
            subject_to_sec_calc=true;
            outside_wall=true;
        elseif any(ch(lifs+1:end)==1) % some voxels after the first shell sequence are of the current lumen
            current_MU_shell=false;
            inside_wall=true;
        elseif any(ch(lifs+1:end)==2|ch(lifs+1:end)==3) % any voxels after the first shell sequence are previous or lower MU 
            current_MU_shell=false;
            inside_wall=true;
        else
            shell_error=true;
        end
        if fifs>1&&any(ch(fifs-1:-1:1)==3|ch(fifs-1:-1:1)==2)
            current_MU_shell=false;
        end
    end
else
    shell_error=true;
end

function [LumenOut,ExternaOut,Lim]=delimit(LumenIn,AmOc)

org_size=size(LumenIn);
AmOc(~LumenIn)=0;
ExternaOut=LumenIn;

IntensityBounds=regionprops3(LumenIn,AmOc,'Volume','MinIntensity','MaxIntensity');
CoreChamberLumen=IntensityBounds.Volume==max(IntensityBounds.Volume);
if IntensityBounds.MinIntensity(CoreChamberLumen)<0.99   
    limits=min(floor(IntensityBounds.MaxIntensity(CoreChamberLumen)*100)/100,0.99):-0.01:max(ceil(IntensityBounds.MinIntensity(CoreChamberLumen)*100)/100,0.5);
    Vol=zeros(numel(limits),1);
    SA=zeros(numel(limits),1); 
    parfor i=1:numel(limits)
        S=AmOc;
        S(S<limits(i))=0;
        s=regionprops3(logical(S),AmOc,'Volume','SurfaceArea');
        MaxVol=find(s.Volume==max(s.Volume),1,'first');
        Vol(i)=s.Volume(MaxVol);
        SA(i)=s.SurfaceArea(MaxVol);
    end
    b=(SA./Vol);   
    %%% break point for paper_figure_AC
    if find(b==min(b))==1||find(b==min(b))==numel(limits) % shape minimum at boundary    
        h=custom_msgbox('No minimum in surface to volume ratio found! Try expanding the label!','','error',[],false);
        ExternaOut=[];
        LumenOut=[];
        Lim=[];
        return
%         ld=(limits(1:end-1)+limits(2:end))/2;
%         newrange=ld(find(diff(b)<0,1,'first')-2):-0.002:ld(find(diff(b)<0,1,'first')+2);
%         Vol=zeros(numel(newrange),1);
%         SA=zeros(numel(newrange),1); 
%         parfor i=1:numel(newrange)
%             S=AmOc;
%             S(S<newrange(i))=0;
%             s=regionprops3(logical(S),AmOc,'Volume','SurfaceArea');
%             MaxVol=find(s.Volume==max(s.Volume),1,'first');
%             Vol(i)=s.Volume(MaxVol);
%             SA(i)=s.SurfaceArea(MaxVol);
%         end
%         b=(Vol./SA);
%         ld=(newrange(1:end-1)+newrange(2:end))/2;               
%         Lim=ld(find(diff(b)<0,1,'first'));        
    else        
        newrange=limits(find(b==min(b))-1):-0.002:limits(find(b==min(b))+1);
        Vol=zeros(numel(newrange),1);
        SA=zeros(numel(newrange),1); 
        parfor i=1:numel(newrange)
            S=AmOc;
            S(S<newrange(i))=0;
            s=regionprops3(logical(S),AmOc,'Volume','SurfaceArea');
            MaxVol=find(s.Volume==max(s.Volume),1,'first');
            Vol(i)=s.Volume(MaxVol);
            SA(i)=s.SurfaceArea(MaxVol);
        end
        b=(Vol./SA);
       Lim=newrange(find(b==min(b),1,'first'));
    end    
%     if isempty(Lim)
%         [~,pl]=findpeaks(-diff(b));
%         Lim=ld(pl(1));
%     end
    if isempty(Lim)
        ExternaOut=[];
        LumenOut=[];
        Lim=[];
        return
    end
    S=AmOc;
    S(S<Lim)=0;
    s=regionprops3(logical(S),'Volume','BoundingBox','Image');
    ind=find(s.Volume==max(s.Volume),1,'first');
    S=zeros(size(AmOc));
    S(ceil(s.BoundingBox(ind,2)):floor(s.BoundingBox(ind,2))+s.BoundingBox(ind,5),ceil(s.BoundingBox(ind,1)):floor(s.BoundingBox(ind,1))+s.BoundingBox(ind,4),ceil(s.BoundingBox(ind,3)):floor(s.BoundingBox(ind,3))+s.BoundingBox(ind,6))=s.Image{ind};
    LumenOut=logical(S);
    ExternaOut=LumenIn&~LumenOut;
else
    ExternaOut=[];
    LumenOut=[];
    Lim=[];
end

function [PS, SCS_pos]=trace_shell(label,L,shell_binary,ignoreMU,method,gap_allow,cone_rays,max_width,fraction_spread, gen_secondary)
global data
global system

PS_pos=false(size(L));
PS_neut=false(size(L));
PS_neg=false(size(L));
SCS_pos=false(size(L));
SCS_neg=false(size(L));
CSsize=size(PS_pos);

start_dist=25;
max_dist=ceil(max_width)+3;
if numel(label)>1 % we need to combine the patches...this takes some time
    for i=2:numel(label)
        cname=['L' num2str(label(i),'%04u')];
    end
else
    cname=['L' num2str(label(1),'%04u')];
    FV=data.patchdata.(cname).normal;
end
if bitand(method,1)  %face based approach starts here, first round without expansion   
    A=FV.faces(:,1);
    B=FV.faces(:,2);
    C=FV.faces(:,3);
    facenorms=cross(FV.vertices(A,:)-FV.vertices(B,:),FV.vertices(C,:)-FV.vertices(A,:)); %area weighted
    facecenters=(FV.vertices(A,:)+FV.vertices(B,:)+FV.vertices(C,:))./3;
    facenormlengths=sum(facenorms.^2,2).^0.5;
    unitfacenorms=facenorms./facenormlengths;    
    asize=size(unitfacenorms,1);    
    f_shell_overflow=false(asize,1);
    f_shell_error=false(asize,1);
    f_first_seq_shell_diameter=zeros(asize,1);
    f_current_MU_shell=false(asize,1);
    f_current_primary_MU_shell=false(asize,1);
    f_subject_to_sec_calc=false(asize,1);
    f_inside_wall=false(asize,1);
    f_outside_wall=false(asize,1);
    f_current_MU_shell_voxel_coordinates=cell(asize,1);
    parfor i=1:asize
        [f_first_seq_shell_diameter(i),f_current_MU_shell_voxel_coordinates{i},f_current_MU_shell(i),f_current_primary_MU_shell(i),f_subject_to_sec_calc(i),f_inside_wall(i),f_outside_wall(i),f_shell_overflow(i),f_shell_error(i)]=find_shell_cross_section(facecenters(i,:),unitfacenorms(i,:),start_dist,gap_allow,L,shell_binary);
    end        
    overflow_list=find(f_shell_overflow);
    new_dist=start_dist;
    while numel(overflow_list)>0&&new_dist<=max_dist
        new_dist=new_dist+10;
        for k=1:numel(overflow_list)
            [f_first_seq_shell_diameter(overflow_list(k)),f_current_MU_shell_voxel_coordinates{overflow_list(k)},f_current_MU_shell(overflow_list(k)),f_current_primary_MU_shell(overflow_list(k)),f_subject_to_sec_calc(overflow_list(k)),f_inside_wall(overflow_list(k)),f_outside_wall(overflow_list(k)),f_shell_overflow(overflow_list(k)),f_shell_error(overflow_list(k))]=find_shell_cross_section(facecenters(overflow_list(k),:),unitfacenorms(overflow_list(k),:),new_dist,gap_allow,L,shell_binary);
        end
        overflow_list=find(f_shell_overflow);
    end
    used_face_width=min([new_dist max_dist]);
    if ignoreMU
        PS_face_valids=f_current_MU_shell&f_inside_wall&~f_shell_error&~f_shell_overflow;
    else
        PS_face_valids=f_current_primary_MU_shell&f_inside_wall&~f_shell_error&~f_shell_overflow;
    end
    SS_face_valids=f_subject_to_sec_calc&~f_shell_error&~f_shell_overflow&~f_current_primary_MU_shell;
end

%%% break point for paper_figure_shell
if bitand(method,2)
    unitvertexnorms=-vertexNormal(FV.vertices,FV.faces);
    vertexcenters=FV.vertices;
    asize=size(unitvertexnorms,1);
    v_shell_overflow=false(asize,1);
    v_shell_error=false(asize,1);
    v_first_seq_shell_diameter=zeros(asize,1);
    v_current_MU_shell=false(asize,1);
    v_current_primary_MU_shell=false(asize,1);
    v_subject_to_sec_calc=false(asize,1);
    v_inside_wall=false(asize,1);
    v_outside_wall=false(asize,1);
    v_current_MU_shell_voxel_coordinates=cell(asize,1);
    parfor i=1:size(unitvertexnorms,1)
        [v_first_seq_shell_diameter(i),v_current_MU_shell_voxel_coordinates{i},v_current_MU_shell(i),v_current_primary_MU_shell(i),v_subject_to_sec_calc(i),v_inside_wall(i),v_outside_wall(i),v_shell_overflow(i),v_shell_error(i)]=find_shell_cross_section(vertexcenters(i,:),unitvertexnorms(i,:),max_dist,gap_allow,L,shell_binary);
    end
    overflow_list=find(v_shell_overflow);
    new_dist=max_dist;
    while numel(overflow_list)>0&&new_dist<=max_dist
          new_dist=new_dist+10;
        for k=1:numel(overflow_list)
            [v_first_seq_shell_diameter(overflow_list(k)),v_current_MU_shell_voxel_coordinates{overflow_list(k)},v_current_MU_shell(overflow_list(k)),v_current_primary_MU_shell(overflow_list(k)),v_subject_to_sec_calc(overflow_list(k)),v_inside_wall(overflow_list(k)),v_outside_wall(overflow_list(k)),v_shell_overflow(overflow_list(k)),v_shell_error(overflow_list(k))]=find_shell_cross_section(vertexcenters(overflow_list(k),:),unitvertexnorms(overflow_list(k),:),new_dist,gap_allow,L,shell_binary);
        end
        overflow_list=find(v_shell_overflow);
    end
    used_vertex_width=min([new_dist max_dist]);
    if ignoreMU       
        PS_vertex_valids=v_current_MU_shell&~v_shell_error&~v_shell_overflow;
    else       
        PS_vertex_valids=v_current_primary_MU_shell&v_inside_wall&~v_shell_error&~v_shell_overflow;
    end
    SS_vertex_valids=v_subject_to_sec_calc&~v_shell_error&~v_shell_overflow&~v_current_primary_MU_shell;
end

% assemble valid measurement for primary shell width determination
switch method
    case 1
        allvalids=f_first_seq_shell_diameter(PS_face_valids);        
    case 2
        allvalids=v_first_seq_shell_diameter(PS_vertex_valids);        
    case 3
        allvalids=[v_first_seq_shell_diameter(PS_vertex_valids);f_first_seq_shell_diameter(PS_face_valids)];        
end

allvalids(allvalids==0)=[]; %%% workaround
[h,b]=hist(allvalids,min(ceil(numel(allvalids)/10),50));

try
    f1 = fit(b',h','gauss1');
    %%% fancy threshold selection
    primary_wall_thres=f1.b1+f1.c1*fraction_spread;    
catch ME
    primary_wall_thres=mean(allvalids);
end
if primary_wall_thres<1.1||primary_wall_thres>(data.volumedata.(cname).PrincipalAxisLength(1)/3)
    primary_wall_thres=mean(allvalids);
end

if gen_secondary
    % assemble valid measurement for secondary shell width determination
    switch method
        case 1
            SSallvalids=f_first_seq_shell_diameter(SS_face_valids);
        case 2
            SSallvalids=v_first_seq_shell_diameter(SS_vertex_valids);
        case 3
            SSallvalids=[v_first_seq_shell_diameter(SS_vertex_valids);f_first_seq_shell_diameter(SS_face_valids)];
    end
    
    SSallvalids(SSallvalids==0)=[]; %%% workaround
    [j,g]=hist(SSallvalids,min(ceil(numel(SSallvalids)/10),30));    
    try
        f1 = fit(g',j','gauss1');
        %%% fancy threshold selection totally arbitrary
        secondary_wall_thres=f1.b1+f1.c1/3;                    
    catch ME
        secondary_wall_thres=mean(SSallvalids);
    end
end

% constuct the shell binary
if bitand(method,1)
    face_valid_inds_positive=find(f_current_MU_shell|f_shell_overflow&~f_shell_error); % all the MU locations in depth of the determined primary shell
    for i=1:numel(face_valid_inds_positive)
        val_dist=f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(:,1)<=primary_wall_thres;
        indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,3),f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,2),f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,4));
        PS_pos(indices)=true;
    end
    face_valid_inds_negative=find(~f_current_MU_shell&~f_shell_error); % all the not current shell locations in full depth
    for i=1:numel(face_valid_inds_negative)
        indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,3),f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,2),f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,4));
        PS_neg(indices)=true;
    end
           
    if gen_secondary
%         SCS_face_valid_inds_out=find(f_inside_wall&~f_shell_error);
%         for i=1:numel(SCS_face_valid_inds_out)          
%             indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,3),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,2),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,4));
%             SCS(indices)=true;
%         end        
        SCS_face_valid_inds=find(f_subject_to_sec_calc|f_shell_overflow&~f_shell_error);
        for i=1:numel(SCS_face_valid_inds)
            val_dist=f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(:,1)<=secondary_wall_thres;
            indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,3),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,2),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,4));
            SCS_pos(indices)=true;
        end
    end
end
if bitand(method,2)
    vertex_valid_inds_positive=find(v_current_MU_shell|v_shell_overflow&~v_shell_error);
    for i=1:numel(vertex_valid_inds_positive)
        val_dist=v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(:,1)<=primary_wall_thres;
        indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,3),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,2),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,4));
        PS_pos(indices)=true;
    end
    vertex_valid_inds_negative=find(~v_current_MU_shell&~v_shell_error); % all the not current shell locations in full depth
    for i=1:numel(vertex_valid_inds_negative)
        indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,3),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,2),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,4));
        PS_neg(indices)=true;
    end    
        
    if gen_secondary
%         SCS_vertex_valid_inds_out=find(v_inside_wall&~v_shell_error);
%         for i=1:numel(SCS_vertex_valid_inds_out)        
%             indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,3),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,2),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,4));
%             SCS(indices)=true;
%         end
        SCS_vertex_valid_inds=find(v_subject_to_sec_calc|v_shell_overflow&~v_shell_error);
        for i=1:numel(SCS_vertex_valid_inds)
            val_dist=v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(:,1)<=secondary_wall_thres;
            indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,3),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,2),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,4));
            SCS_pos(indices)=true;
        end
    end
end

% if selected do the same with another set of conical rays
if cone_rays>0&&bitand(method,1)
    facenorms=facenorms(f_current_MU_shell,:);
    facecenters=facecenters(f_current_MU_shell,:);
    facenormlengths=sum(facenorms.^2,2).^0.5;
    unitfacenorms=facenorms./facenormlengths;
    newfacenorms=zeros(size(facenorms,1)*sum((1:cone_rays)*4),3);    
    for k=1:size(facenorms,1)      
        newfacenorms((k-1)*sum((1:cone_rays)*4)+1:k*sum((1:cone_rays)*4),:)=cover_radial_divergence(unitfacenorms(k,:),primary_wall_thres,cone_rays);
    end
    facecenters=repelem(facecenters,sum((1:cone_rays)*4),1);    
    asize=size(newfacenorms,1);
    f_shell_overflow=false(asize,1);
    f_shell_error=false(asize,1);
    f_first_seq_shell_diameter=zeros(asize,1);
    f_current_MU_shell=false(asize,1);
    f_current_primary_MU_shell=false(asize,1);
    f_subject_to_sec_calc=false(asize,1);
    f_inside_wall=false(asize,1);
    f_outside_wall=false(asize,1);
    f_current_MU_shell_voxel_coordinates=cell(asize,1);
    for i=1:size(newfacenorms,1)
        [f_first_seq_shell_diameter(i),f_current_MU_shell_voxel_coordinates{i},f_current_MU_shell(i),f_current_primary_MU_shell(i),f_subject_to_sec_calc(i),f_inside_wall(i),f_outside_wall(i),f_shell_overflow(i),f_shell_error(i)]=find_shell_cross_section(facecenters(i,:),newfacenorms(i,:),used_face_width,gap_allow,L,shell_binary);
    end
    face_valid_inds_positive=find(f_current_MU_shell|f_shell_overflow&~f_shell_error); % all the MU locations in depth of the determined primary shell
    for i=1:numel(face_valid_inds_positive)
        val_dist=f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(:,1)<=primary_wall_thres;
        indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,3),f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,2),f_current_MU_shell_voxel_coordinates{face_valid_inds_positive(i)}(val_dist,4));
        PS_pos(indices)=true;
    end
%     face_valid_inds_negative=find(~f_current_MU_shell&~f_shell_error); % all the not current shell locations in full depth
%     for i=1:numel(face_valid_inds_negative)
%         indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,3),f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,2),f_current_MU_shell_voxel_coordinates{face_valid_inds_negative(i)}(:,4));
%         PS_neg(indices)=true;
%     end    
        
    if gen_secondary
%         SCS_face_valid_inds_out=find(f_inside_wall&~f_shell_error);
%         for i=1:numel(SCS_face_valid_inds_out)
%             indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,3),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,2),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds_out(i)}(:,4));
%             SCS(indices)=true;
%         end
        SCS_face_valid_inds=find(f_subject_to_sec_calc|f_shell_overflow&~f_shell_error);
        for i=1:numel(SCS_face_valid_inds)
            val_dist=f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(:,1)<=secondary_wall_thres;
            indices=sub2ind(CSsize,f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,3),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,2),f_current_MU_shell_voxel_coordinates{SCS_face_valid_inds(i)}(val_dist,4));
            SCS_pos(indices)=true;
        end
    end
end

if cone_rays>0&&bitand(method,2)
    % vertex based approach starts here
    unitvertexnorms=-vertexNormal(FV.vertices,FV.faces);
    unitvertexnorms=unitvertexnorms(v_current_MU_shell,:);
    newvertexnorms=zeros(size(unitvertexnorms,1)*sum((1:cone_rays)*4),3);
    for k=1:size(unitvertexnorms,1)
        %newvertexnorms((k-1)*cone_rays+1:k*cone_rays,:)=generate_conical_beam(unitvertexnorms(k,:),cone_angle,cone_rays);
        newvertexnorms((k-1)*sum((1:cone_rays)*4)+1:k*sum((1:cone_rays)*4),:)=cover_radial_divergence(unitvertexnorms(k,:),primary_wall_thres,cone_rays);
    end
    vertexnormlengths=sum(newvertexnorms.^2,2).^0.5;
    unitvertexnorms=newvertexnorms./vertexnormlengths;
    vertexcenters=repelem(FV.vertices,sum((1:cone_rays)*4),1);
    asize=size(unitvertexnorms,1);
    v_shell_overflow=false(asize,1);
    v_shell_error=false(asize,1);
    v_first_seq_shell_diameter=zeros(asize,1);
    v_current_MU_shell=false(asize,1);
    v_current_primary_MU_shell=false(asize,1);
    v_subject_to_sec_calc=false(asize,1);
    v_inside_wall=false(asize,1);
    v_outside_wall=false(asize,1);
    v_current_MU_shell_voxel_coordinates=cell(asize,1);
    for i=1:size(unitvertexnorms,1)
        [v_first_seq_shell_diameter(i),v_current_MU_shell_voxel_coordinates{i},v_current_MU_shell(i),v_current_primary_MU_shell(i),v_subject_to_sec_calc(i),v_inside_wall(i),v_outside_wall(i),v_shell_overflow(i),v_shell_error(i)]=find_shell_cross_section(vertexcenters(i,:),unitvertexnorms(i,:),used_vertex_width,gap_allow,L,shell_binary);
    end
    vertex_valid_inds_positive=find(v_current_MU_shell|v_shell_overflow&~v_shell_error);
    for i=1:numel(vertex_valid_inds_positive)
        val_dist=v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(:,1)<=primary_wall_thres;
        indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,3),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,2),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_positive(i)}(val_dist,4));
        PS_pos(indices)=true;
    end
%         vertex_valid_inds_negative=find(~v_current_MU_shell&~v_shell_error); % all the not current shell locations in full depth
%         for i=1:numel(vertex_valid_inds_negative)
%             indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,3),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,2),v_current_MU_shell_voxel_coordinates{vertex_valid_inds_negative(i)}(:,4));
%             PS_neg(indices)=true;
%         end
            
    if gen_secondary
%         SCS_vertex_valid_inds_out=find(v_inside_wall&~v_shell_error);
%         for i=1:numel(SCS_vertex_valid_inds_out)        
%             indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,3),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,2),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds_out(i)}(:,4));
%             SCS(indices)=true;
%         end
        SCS_vertex_valid_inds=find(v_subject_to_sec_calc|v_shell_overflow&~v_shell_error);
        for i=1:numel(SCS_vertex_valid_inds)
            val_dist=v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(:,1)<=secondary_wall_thres;
            indices=sub2ind(CSsize,v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,3),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,2),v_current_MU_shell_voxel_coordinates{SCS_vertex_valid_inds(i)}(val_dist,4));
            SCS_pos(indices)=true;
        end
    end
end
SCS_pos(PS_pos)=0; % clear the primary shel from the total shell

PS=PS_pos&~PS_neg;
PS(~shell_binary)=false;

%%% label data GUI callback functions %%%
function sort_labels_Callback(~, ~, handles)
global data
global system

dir=handles.sort_order.String{handles.sort_order.Value}(1:end-3);
sort_parm=handles.sort_parameter.String{handles.sort_parameter.Value};
sort_data=handles.MainTable.Data(:,strcmp(handles.MainTable.ColumnName,sort_parm));

if any(contains(sort_parm,{'Name','Class','Group','Type','Visu'}))
    emp=strcmp(sort_data,'');
    non_emp=find(~emp);
    [~,subs]=sort(sort_data(~emp));
    if strcmp(dir,'ascend')
        s=[non_emp(subs);find(emp)];
    else
        s=[flipud(non_emp(subs));find(emp)];
    end
elseif any(contains(sort_parm,{'MU','Label'}))
    [~,s]=sort(str2double(sort_data),dir);
else
    [~,s]=sort(cell2mat(sort_data),dir);
end
handles.MainTable.Data=handles.MainTable.Data(s,:);
data.Labeltable=data.Labeltable(s,:);
system.TempLabeltable=system.TempLabeltable(s,:);
system.temp.LastSort={sort_parm, dir};

function recenter_Callback(~, ~, handles)
global data
global system
global patches

label=str2num(handles.selected_labels.String);
index=find(data.Labeltable.Label==label, 1);
patch_name=['L' num2str(label,'%04u')];

if ~isempty(label)&&sum(any(data.Labeltable.Label==label))==1
    system.temp.current_center=data.volumedata.(patch_name).Centroid;
    f=fieldnames(data.volumedata);
    for i=1:numel(f)
        index=find(data.Labeltable.Label==str2num(f{i}(2:end)), 1);
        system.TempLabeltable.Distance(index)=pdistance(data.volumedata.(f{i}).Centroid,system.temp.current_center);
    end
    populate_table(handles, true,false);
else
    h=custom_msgbox('Please select a single valid label for this operation!','','error',[],false);
end

function main_table_CellEditCallback(~, eventdata, handles)
global patches
global data
global system
global jtableobj

cheat={'off' 'on'};
Label=str2num(handles.MainTable.Data{eventdata.Indices(1),1});
cname=['L' num2str(Label,'%04u')];
curTpos=jtableobj.getVerticalScrollBar.getValue;
TLabelInd=find(system.TempLabeltable.Label==Label);
switch eventdata.Indices(2)
    case 2  % status active
        data.Labeltable.Active(data.Labeltable.Label==Label)=eventdata.EditData;
        if ~eventdata.EditData
            handles.MainTable.Data{eventdata.Indices(1),3}=false;
            patches.(cname).Visible='off';
            handles.active_labels.String=num2str(sum(data.Labeltable.Active));
        end
    case 3 % to show or not to show
        patches.(cname).Visible=cheat{eventdata.EditData+1};
        system.TempLabeltable.show(system.TempLabeltable.Label==Label)=eventdata.EditData;
    case 5  % Morphological unit
        if ~isempty(eventdata.EditData)&&~isnan(str2double(eventdata.EditData))
            data.Labeltable.MorphoUnit(data.Labeltable.Label==Label)=str2num(eventdata.EditData);
        else
            handles.MainTable.Data{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;
        end
    case 6  % Name
        data.Labeltable.Name(data.Labeltable.Label==Label)={eventdata.EditData};
    case 7  % Class
        data.Labeltable.Class(data.Labeltable.Label==Label)={eventdata.EditData};
    case 8  % Group
        data.Labeltable.Group(data.Labeltable.Label==Label)={eventdata.EditData};
    case 9  % Type
        data.Labeltable.Type(data.Labeltable.Label==Label)={eventdata.EditData};
    case 10 % display type
        if system.TempLabeltable.selected(system.TempLabeltable.Label==Label)
            ec=[0 0 0];            
        elseif strcmp(eventdata.NewData,'voxels')
            ec=color_mod(system.corollary.colormap(TLabelInd,:),0.25,'darker');
        else
            ec='none';
        end
        patches=rmfield(patches,cname);
        delete(findobj(handles.Axes,'Tag',cname));
        patches.(cname)=patch(handles.Axes,data.patchdata.(cname).(eventdata.NewData),'Tag',cname,'FaceColor',system.corollary.colormap(TLabelInd,:),'ButtonDownFcn',@patchhittest,'EdgeColor',ec,'FaceLighting','gouraud','SpecularStrength',system.corollary.light_specular,'AmbientStrength',system.corollary.light_ambient,'DiffuseStrength',system.corollary.light_diffuse,'Visible',cheat{system.TempLabeltable.show(TLabelInd)+1}); %'BackFaceLighting','lit'
end
update_classes(handles);
check_operations(handles);
jtableobj.getVerticalScrollBar.setValue(curTpos);

function main_table_CellSelectionCallback(~, eventdata, handles)
global patches
global data
global system
global jtableobj

if system.temp.hit_from_patch
    if any(system.TempLabeltable.selected)
        current_selection=system.TempLabeltable.Label(system.TempLabeltable.selected);
        s=num2str(current_selection(1));
        for k=2:size(current_selection,1)
            s=[s ' ' num2str(current_selection(k))];  %#ok<AGROW>
        end
        handles.selected_labels.String=s;
    else
        handles.selected_labels.String='';
    end
    system.temp.hit_from_patch=false;
elseif system.temp.hit_from_table_renew
    system.temp.hit_from_table_renew=false;
else
    %%%% here we are
    previously_selected=system.TempLabeltable.Label(system.TempLabeltable.selected);
    currently_selected=[];
    if ~isempty(eventdata.Indices(:,1))
        tbllabels=str2num(cell2mat(handles.MainTable.Data(:,1)));
        currently_selected=tbllabels(unique(eventdata.Indices(:,1)));
    end
    patches_to_flag=currently_selected(~ismember(currently_selected,previously_selected));
    patches_to_unflag=previously_selected(~ismember(previously_selected,currently_selected));
    for i=1:numel(patches_to_flag)
        system.TempLabeltable.selected(system.TempLabeltable.Label==patches_to_flag(i))=true;
        cname=['L' num2str(patches_to_flag(i),'%04u')];
        patches.(cname).EdgeColor=[0 0 0];
    end
    for i=1:numel(patches_to_unflag)
        system.TempLabeltable.selected(system.TempLabeltable.Label==patches_to_unflag(i))=false;
        cname=['L' num2str(patches_to_unflag(i),'%04u')];
        patches.(cname).EdgeColor='none';
    end
    if any(system.TempLabeltable.selected)
        current_selection=system.TempLabeltable.Label(system.TempLabeltable.selected);
        s=num2str(current_selection(1));
        for k=2:size(current_selection,1)
            s=[s ' ' num2str(current_selection(k))];  %#ok<AGROW>
        end
        handles.selected_labels.String=s;
    else
        handles.selected_labels.String='';
    end
end
check_operations(handles);

function apply_filter_Callback(hObject, ~, handles)
global data
global system
global patches

filter_parm=handles.filter_parameter.String{handles.filter_parameter.Value};
filter_data=handles.MainTable.Data(:,strcmp(handles.MainTable.ColumnName,filter_parm));
maxi=min([Inf str2num(handles.filter_max.String{1})]);
mini=max([-Inf str2num(handles.filter_min.String{1})]);

for i=1:size(handles.MainTable.Data,1)
    if ~(filter_data{i}>mini&&filter_data{i}<maxi)
        system.TempLabeltable.show(data.Labeltable.Label==str2num(handles.MainTable.Data{i,1}))=false;
        data.Labeltable.Active(data.Labeltable.Label==str2num(handles.MainTable.Data{i,1}))=false;
        patch_name=['L' num2str(str2num(handles.MainTable.Data{i,1}),'%04u')];
        patches.(patch_name).Visible='off';
    else
        system.TempLabeltable.show(data.Labeltable.Label==str2num(handles.MainTable.Data{i,1}))=true;
        data.Labeltable.Active(data.Labeltable.Label==str2num(handles.MainTable.Data{i,1}))=true;
        patch_name=['L' num2str(str2num(handles.MainTable.Data{i,1}),'%04u')];
        patches.(patch_name).Visible='on';
    end
    
end
guidata(hObject, handles);
populate_table(handles,true,false);

function delete_inactive_Callback(~, ~, handles)
global data
global patches

answer = questdlg('Are you sure?', '','Yes','Cancel','Cancel');
if strcmp(answer,'Yes')
    labellist=data.Labeltable.Label(~data.Labeltable.Active);
    for i=1:numel(labellist)
        remove_entry(labellist(i));
    end
    populate_table(handles,false,false);
end

function recolor_Callback(~, ~, handles)
global data
global patches
global system
global GlobalHandles

h=custom_waitbar('Please wait...changing patch visualization!',[],false);
switch handles.LabelColorMap.String{handles.LabelColorMap.Value}
    case 'Prism'
        colordummy=prism(4096);
        disp=8;
    case 'Colorbrewer'
        dummy=[0.650980392156863 0.807843137254902 0.890196078431373;0.121568627450980 0.470588235294118 0.705882352941177;0.698039215686275 0.874509803921569 0.541176470588235;0.200000000000000 0.627450980392157 0.172549019607843;0.984313725490196 0.603921568627451 0.600000000000000;0.890196078431373 0.101960784313725 0.109803921568627;0.992156862745098 0.749019607843137 0.435294117647059;1 0.498039215686275 0;0.792156862745098 0.698039215686275 0.839215686274510;0.415686274509804 0.239215686274510 0.603921568627451;1 1 0.600000000000000;0.694117647058824 0.349019607843137 0.156862745098039];
        colordummy=repmat(dummy,340,1);
        disp=12;
    case 'Lines'
        colordummy=lines(4096);
        disp=8;
    case 'HSV'
        dummy=hsv(8);
        colordummy=repmat(dummy,512,1);
        disp=8;
end
displacement=round(rand(1,1)*(disp-1))+1;
system.corollary.colormap=[colordummy(displacement:end,:);colordummy(1:displacement-1,:)];
current_list=system.TempLabeltable.Label;

for i=1:numel(current_list)
    cname=['L' num2str(current_list(i),'%04u')];
    if contains(GlobalHandles.MainTableHandle.Data(str2num(cell2mat(GlobalHandles.MainTableHandle.Data(:,1)))==current_list(i),10),'voxels')
        ec=color_mod(system.corollary.colormap(i,:),0.25,'darker');
        patches.(cname).EdgeColor=ec;
    end
    patches.(cname).FaceColor=system.corollary.colormap(i,:);
    waitbar(i/numel(current_list),h);
end
delete (h)

function relabel_Callback(hObject, ~, handles)
global data
global patches
global system

deselect_all();
old_patches=patches;
old_labelfield=data.Labelfield;
old_volumedata=data.volumedata;
old_patchdata=data.patchdata;
old_label_order=data.Labeltable.Label;
new_label_order=str2num(cell2mat(handles.MainTable.Data(:,1)));
old_Temp=system.TempLabeltable;

data=rmfield(data,{'volumedata','patchdata','Labelfield'});
patches=[];

data.Labelfield=zeros(size(old_labelfield),'uint16');
for i=1:numel(old_label_order)
    act_pos=find(old_label_order(i)==new_label_order);
    data.Labeltable.Label(i)=act_pos;
    system.TempLabeltable.Label(i)=act_pos;
    system.TempLabeltable.Distance(i)=old_Temp.Distance(act_pos);
    system.TempLabeltable.show(i)=old_Temp.show(act_pos);
    old_patch_name=['L' num2str(old_label_order(i),'%04u')];
    new_patch_name=['L' num2str(act_pos,'%04u')];
    
    patches.(new_patch_name)=old_patches.(old_patch_name);
    data.patchdata.(new_patch_name)=old_patchdata.(old_patch_name);
    data.volumedata.(new_patch_name)=old_volumedata.(old_patch_name);
    data.Labelfield(old_labelfield==old_label_order(i))=act_pos;
end
guidata(hObject, handles);
cla(handles.Axes);
populate_table(handles,false,false);
populate_graph(handles);

function SetVisuAll_Callback(~, ~, handles)
global patches
global system
global data

type=lower(handles.SetVisuAll.String{handles.SetVisuAll.Value});
cheat={'off' 'on'};

h=custom_waitbar('Please wait...changing patch visualization!',[],false);
for i=1:numel(system.TempLabeltable.Label)
    if strcmp(type,'voxels')
        ec=color_mod(system.corollary.colormap(i,:),0.25,'darker');
    else
        ec='none';
    end
    cname=['L' num2str(system.TempLabeltable.Label(i),'%04u')];
    patches=rmfield(patches,cname);
    delete(findobj(handles.Axes,'Tag',cname));
    patches.(cname)=patch(handles.Axes,data.patchdata.(cname).(type),'Tag',cname,'FaceColor',system.corollary.colormap(i,:),'ButtonDownFcn',@patchhittest,'EdgeColor',ec,'FaceLighting','gouraud','SpecularStrength',system.corollary.light_specular,'AmbientStrength',system.corollary.light_ambient,'DiffuseStrength',system.corollary.light_diffuse,'Visible',cheat{system.TempLabeltable.show(i)+1});
    waitbar(i/numel(system.TempLabeltable.Label),h)
end
handles.MainTable.Data(:,10)={type};
delete (h)

%%% other GUI callback functions %%%
function patchhittest(~,evd)
global system
global patches
global data
global GlobalHandles
global jtableobj

JTable=jtableobj.getViewport.getView;
selected_label=str2num(evd.Source.Tag(3:end));
%key1 = get(gcf,'CurrentKey');
system.temp.hit_from_patch=true;
if system.temp.control_pressed
    if system.TempLabeltable.selected(system.TempLabeltable.Label==selected_label)
        patches.(evd.Source.Tag).EdgeColor='none';
        system.TempLabeltable.selected(data.Labeltable.Label==selected_label)=false;
    else
        patches.(evd.Source.Tag).EdgeColor=[0 0 0];
        system.TempLabeltable.selected(system.TempLabeltable.Label==selected_label)=true;
    end
    JTable.changeSelection(find(str2num(cell2mat(GlobalHandles.MainTableHandle.Data(:,1)))==selected_label)-1,0, true, false);
else
    labellist=system.TempLabeltable.Label(system.TempLabeltable.selected);
    if ~any(labellist==selected_label) % new selection
        for i=1:numel(labellist)
            patch_name=['L' num2str(labellist(i),'%04u')];
            patches.(patch_name).EdgeColor='none';
            system.TempLabeltable.selected(system.TempLabeltable.Label==labellist(i))=false;
        end
        patches.(evd.Source.Tag).EdgeColor=[0 0 0];
        system.TempLabeltable.selected(system.TempLabeltable.Label==selected_label)=true;
        JTable.changeSelection(find(str2num(cell2mat(GlobalHandles.MainTableHandle.Data(:,1)))==selected_label)-1,0, false, false);
    else %unselection
        for i=1:numel(labellist)
            patch_name=['L' num2str(labellist(i),'%04u')];
            patches.(patch_name).EdgeColor='none';
        end
        system.TempLabeltable.selected(:)=false;
        GlobalHandles.SelectedFieldHandle.String='';
        JTable.clearSelection();
    end
end

function comment_Callback(hObject, ~, ~)
global data
data.header.Comment=hObject.String;

function recalculate_patches()
global data
global system

h=custom_waitbar('Please wait...regenerating all patches',[],false);

labellist=unique(data.Labelfield(:,:,:,:));

for i=1:size(data.Labeltable,1)
    labelname=['L' num2str(data.Labeltable.Label(i),'%04u')];
    SubV=data.Labelfield;
    SubV(SubV~=data.Labeltable.Label(i))=0;
    SubV=logical(SubV);
    SubV=any(SubV,4);
    SubVsm=smooth3(SubV,'gaussian',[3 3 3],0.65); % default is size 3 sd 0.65
    fv=isosurface(SubVsm,system.defaults.patch_margin);
    data.patchdata.(labelname).normal=fv;
    SubVsm=smooth3(SubV,'gaussian',[5 5 5], 3);
    fv=isosurface(SubVsm,system.defaults.patch_margin);
    data.patchdata.(labelname).smoothed=fv;
    s=regionprops3(SubV,'Volume','Centroid','Extent','PrincipalAxisLength','ConvexVolume', 'Solidity','SurfaceArea','EquivDiameter','Orientation');
    distSubV=bwdist(~SubV);
    distSubV(distSubV~=1)=0;
    sd=regionprops3(distSubV,'VoxelList');
    v=[];
    f=[];
    for k=1:size(sd,1)
        [vert, fac] = voxel_image(sd.VoxelList{k});
        v=[v;vert];  %#ok<AGROW>
        f=[f;fac];  %#ok<AGROW>
    end
    data.patchdata.(labelname).voxels.vertices=v;
    data.patchdata.(labelname).voxels.faces=f;
    maxvol=find(s.Volume==max(s.Volume),1,'first');
    data.volumedata.(labelname).Patches=size(s,1);
    data.volumedata.(labelname).Volume=s.Volume(maxvol);
    data.volumedata.(labelname).Centroid=s.Centroid(maxvol,:);
    data.volumedata.(labelname).PrincipalAxisLength=s.PrincipalAxisLength(maxvol,:);
    data.volumedata.(labelname).Orientation=s.Orientation(maxvol,:);
    data.volumedata.(labelname).SurfaceArea=s.SurfaceArea(maxvol);
    data.volumedata.(labelname).Solidity=s.Solidity(maxvol);
    data.volumedata.(labelname).Extent=s.Extent(maxvol);
    data.volumedata.(labelname).ConvexVolume=s.ConvexVolume(maxvol);
    data.volumedata.(labelname).EquivDiameter=s.EquivDiameter(maxvol);
    waitbar(i/size(data.Labeltable,1),h);
end
delete(h);

function MainGUIWindow_WindowKeyReleaseFcn(~, ~, ~)
global system
system.temp.shift_pressed=false;
system.temp.control_pressed=false;

%%% general GUI backend functions %%%
function populate_table(handles,retain_selection,force_renew)
global data
global system
global patches
global GlobalHandles

system.temp.hit_from_table_renew=true;
old_sort_parm=handles.sort_parameter.Value;
old_sort_order=handles.sort_order.Value;
old_filter_parm=handles.filter_parameter.Value;
old_force_vis=handles.SetVisuAll.Value;
old_recolor_sel=handles.LabelColorMap.Value;
if ~isempty(data)
    dummytable=cell(size(data.Labeltable,1),13+sum(system.static.TableOptParmList.Set));
    dummytable(:,1)=cellstr(num2str(data.Labeltable.Label));
    dummytable(:,2)=num2cell(data.Labeltable.Active);
    dummytable(:,3)=num2cell(system.TempLabeltable.show); % show
    dummytable(:,4)=cellstr(num2str(data.Labeltable.Layer));
    dummytable(:,5)=cellstr(num2str(data.Labeltable.MorphoUnit));
    dummytable(:,6)=data.Labeltable.Name;
    dummytable(:,7)=data.Labeltable.Class;
    dummytable(:,8)=data.Labeltable.Group;
    dummytable(:,9)=data.Labeltable.Type;
    dummytable(:,10)=cellstr('normal'); % Visu normal    
    if handles.filter_parameter.Value>(sum(system.static.TableOptParmList.Set)+1)
        handles.filter_parameter.Value=1;
    end
    handles.filter_parameter.String={'Volume [vx]'};    
    OptSet=find(system.static.TableOptParmList.Set);
    for n=1:numel(OptSet)
        handles.MainTable.ColumnName(12+n)=system.static.TableOptParmList.ShortName(OptSet(n));
        handles.filter_parameter.String=[handles.filter_parameter.String; system.static.TableOptParmList.ShortName(OptSet(n))];
        for m=1:size(data.Labeltable,1)
            cname=['L' num2str(str2num(dummytable{m,1}),'%04u')];
            dummytable(m,11)={data.volumedata.(cname).Patches};
            dummytable(m,12)={data.volumedata.(cname).Volume};
            if isfield(data.volumedata.(cname),system.static.TableOptParmList.RegionPropsName{OptSet(n)})
                if system.static.TableOptParmList.Transformed(OptSet(n))
                    dummyvar=data.volumedata.(cname).(system.static.TableOptParmList.RegionPropsName{OptSet(n)});
                    dummytable(m,12+n)={dummyvar(system.static.TableOptParmList.RegionPropsIndex(OptSet(n)))*system.static.TableOptParmList.Multiplier(OptSet(n))*data.header.Voxelsize^system.static.TableOptParmList.Exponent(OptSet(n))};
                else
                    dummyvar=data.volumedata.(cname).(system.static.TableOptParmList.RegionPropsName{OptSet(n)});
                    dummytable(m,12+n)={dummyvar(system.static.TableOptParmList.RegionPropsIndex(OptSet(n)))};
                end
            else
                dummytable(m,12+n)={'N/A'};
            end
        end
    end
    handles.MainTable.ColumnName(13+sum(system.static.TableOptParmList.Set))={'Distance [vx]'};
    dummytable(:,end)=num2cell(round(system.TempLabeltable.Distance,2));
    handles.sort_parameter.Value=1;
    handles.sort_parameter.String=handles.MainTable.ColumnName;
    handles.MainTable.Data=dummytable;
    handles.filter_min.String={num2str(min(cell2mat(dummytable(:,12))))};
    handles.filter_max.String={num2str(max(cell2mat(dummytable(:,12))))};
    if ~retain_selection
        labellist=find(system.TempLabeltable.selected);
        for k=1:numel(labellist)
            patch_name=['L' num2str(labellist(k),'%04u')];
            patches.(patch_name).EdgeColor='none';
        end
        system.TempLabeltable.selected=false(size(data.Labeltable.Label,1),1);
        handles.selected_labels.String=[];
    end
    if ~force_renew
    handles.sort_parameter.Value=old_sort_parm;
    handles.sort_order.Value=old_sort_order;
    handles.filter_parameter.Value=old_filter_parm;
    handles.SetVisuAll.Value=old_force_vis;
    handles.LabelColorMap.Value=old_recolor_sel;
    end
    update_classes(handles);
    sort_by_last_action(handles);
end

function sort_by_last_action(handles)
global data
global system

sort_parm=system.temp.LastSort{1};
dir=system.temp.LastSort{2};
sort_data=handles.MainTable.Data(:,strcmp(handles.MainTable.ColumnName,sort_parm));

if any(contains(sort_parm,{'Name','Class','Group','Type','Visu'}))
    emp=strcmp(sort_data,'');
    non_emp=find(~emp);
    [~,subs]=sort(sort_data(~emp));
    if strcmp(dir,'ascend')
        s=[non_emp(subs);find(emp)];
    else
        s=[flipud(non_emp(subs));find(emp)];
    end
elseif any(contains(sort_parm,{'MU','Label'}))
    [~,s]=sort(str2double(sort_data),dir);
else
    [~,s]=sort(cell2mat(sort_data),dir);
end
handles.MainTable.Data=handles.MainTable.Data(s,:);
data.Labeltable=data.Labeltable(s,:);
system.TempLabeltable=system.TempLabeltable(s,:);

function populate_graph(handles)
global data
global patches
global cali
global system

h=custom_waitbar('Please wait...preparing label patches',false,0);
FC_cheat={'flat','interp'};
VS_cheat={'off','on'};
kids=handles.Axes.Children;
for i=1:numel(kids)
    delete(kids(i));
end
handles.show_shell.Value=0;
patches.Shellpatch=patch(handles.Axes,data.basicshell.patchdata,'FaceColor',handles.shell_color.BackgroundColor,'FaceAlpha',handles.shell_opacity.Value,'EdgeColor','none','FaceLighting','gouraud','SpecularStrength',system.corollary.light_specular,'AmbientStrength',system.corollary.light_ambient,'DiffuseStrength',system.corollary.light_diffuse, 'BackFaceLighting','reverselit','Tag','Primary shell','Visible','off');
for i=1:size(data.Labeltable,1)
    cname=['L' num2str(data.Labeltable.Label(i),'%04u')];
    patches.(cname)=patch(handles.Axes,data.patchdata.(cname).normal,'Tag',cname,'FaceColor',system.corollary.colormap(i,:),'ButtonDownFcn',@patchhittest,'EdgeColor','none','FaceLighting','gouraud','SpecularStrength',system.corollary.light_specular,'AmbientStrength',system.corollary.light_ambient,'DiffuseStrength',system.corollary.light_diffuse,'Visible',VS_cheat{1+system.TempLabeltable.show(system.TempLabeltable.Label==data.Labeltable.Label(i))}); 
    waitbar(i/size(data.Labeltable,1));
end
axis equal
axis off
ptCloudThreshold = [1920*1080, 1e8];
hFigure = ancestor(handles.Axes, 'Figure');
% Initialize point cloud viewer controls.
delete (cali);
cali=camlight(handles.Axes,'headlight');
custom_initPCSceneControl(hFigure, handles.Axes, 'Z','Up', ptCloudThreshold, true);
hManager = uigetmodemanager(hFigure);
[hManager.WindowListenerHandles.Enabled] = deal(false);  % HG2
set(hFigure, 'WindowKeyPressFcn', []);
set(hFigure, 'KeyPressFcn', @(hObject,eventdata)MFSE_Main('MainGUIWindow_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));
delete (h);

function update_classes(handles)
global data
global system

aClasses=unique(data.Labeltable.Class);
aLayers=unique(data.Labeltable.Layer);
aGroups=unique(data.Labeltable.Group);
aTypes=unique(data.Labeltable.Type);
aMUs=unique(data.Labeltable.MorphoUnit);
aMUs=aMUs(aMUs>0);
if isempty(aClasses{1})&&numel(aClasses)==1
    handles.class_show.Value=1;
    handles.class_show.String={'Any'};
    handles.classes.String='0';
elseif isempty(aClasses{1})&&numel(aClasses)>1
    if handles.class_show.Value>numel(aClasses)+1
        handles.class_show.Value=1;
    end
    handles.class_show.String=[{'Any'};aClasses];
    handles.classes.String=num2str(numel(handles.class_show.String)-1);
else
    if handles.class_show.Value>numel(aClasses)+1
        handles.class_show.Value=1;
    end
    handles.class_show.String=[{'Any'};aClasses];
    handles.classes.String=num2str(numel(handles.class_show.String));
end
if isempty(aGroups{1})&&numel(aGroups)==1
    handles.group_show.Value=1;
    handles.group_show.String={'Any'};
    handles.groups.String='0';
elseif isempty(aGroups{1})&&numel(aGroups)>1
    if handles.group_show.Value>numel(aGroups)+1
        handles.group_show.Value=1;
    end
    handles.group_show.String=[{'Any'};aGroups(2:end)];
    handles.groups.String=num2str(numel(handles.group_show.String)-1);
else
    if handles.group_show.Value>numel(aGroups)+1
        handles.group_show.Value=1;
    end
    handles.group_show.String=[{'Any'};aGroups];
    handles.groups.String=num2str(numel(handles.group_show.String));
end
if isempty(aTypes{1})&&numel(aTypes)==1
    handles.types.String='0';
elseif isempty(aTypes{1})&&numel(aTypes)>1
    handles.types.String=num2str(numel(aTypes)-1);
else
    handles.types.String=num2str(numel(aTypes));
end
handles.classes.String=num2str(numel(handles.class_show.String)-1);
if handles.layer_show.Value>numel(aLayers)+1
    handles.layer_show.Value=1;
end

handles.layer_show.String=[{'Any'};aLayers];

if handles.MU_show.Value>numel(aMUs)+1
    handles.MU_show.Value=1;
end
handles.MU_show.String=[{'Any'};aMUs];
handles.total_labels.String=num2str(size(data.Labeltable,1));
handles.types.String=num2str(numel(unique(data.Labeltable.Type))-1);
handles.active_labels.String=num2str(sum(data.Labeltable.Active));
handles.layers.String=num2str(size(data.Labelfield,4));
handles.morphounits.String=num2str(numel((unique(data.Labeltable.MorphoUnit)>0)));
% here are the macro enablers
MUlist=unique(data.Labeltable.MorphoUnit(data.Labeltable.Active));
all_MU_have_shell=true;
for i=1:numel(MUlist)
    if ~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==MUlist(i)),{'Shell'}))
        all_MU_have_shell=false;
    end
end
shell_is_MU_bracketed=true;
maxMU=max(MUlist);
labellist=system.TempLabeltable.Label;
for i=1:numel(labellist)
    if ~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==min([data.Labeltable.MorphoUnit(data.Labeltable.Label==labellist(i))+1 maxMU])),{'Shell'}))||~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==max([data.Labeltable.MorphoUnit(data.Labeltable.Label==labellist(i))-1 1])),{'Shell'}))
        shell_is_MU_bracketed=false;
    end
end
all_MU_strictly_monotonic_increasing=all(diff(sort(MUlist))==1);

if all_MU_strictly_monotonic_increasing&&all_MU_have_shell&&shell_is_MU_bracketed
    handles.finalize_all_individuals.Enable='on';
else
    handles.finalize_all_individuals.Enable='off';
end

function check_operations(handles)
global system
global data

labellist=system.TempLabeltable.Label(system.TempLabeltable.selected);
LIA=ismember(data.Labeltable.Label,labellist);
no_label=sum(system.TempLabeltable.selected)==0;
if ~no_label
    one_label=sum(system.TempLabeltable.selected)==1;
    two_labels=sum(system.TempLabeltable.selected)==2;
    many_labels=sum(system.TempLabeltable.selected)>2;
    have_many_patches=all(cell2mat(handles.MainTable.Data(LIA,11))>1);
    are_lumina=all(contains(data.Labeltable.Class(LIA),{'Lumen'}));
    are_shell=all(contains(data.Labeltable.Class(LIA),{'Shell'}));
    all_active_classified=~any(contains(data.Labeltable.Class(data.Labeltable.Active),{'Unclassified'}));
    all_from_same_layer=numel(unique(data.Labeltable.Layer(LIA)))==1;
end
MUlist=unique(data.Labeltable.MorphoUnit(data.Labeltable.Active));
any_label_visible=sum(system.TempLabeltable.show)>0&&sum(system.TempLabeltable.show)<numel(system.TempLabeltable.show);
all_labels_visible=sum(system.TempLabeltable.show)==numel(system.TempLabeltable.show);
no_label_visible=sum(system.TempLabeltable.show)==0;
have_active_inactive_labels=numel(data.Labeltable.Active)~=sum(data.Labeltable.Active);
have_lumen_labels=any(contains(data.Labeltable.Class,'Lumen'));
have_shell_labels=any(contains(data.Labeltable.Class,'Shell'));

if have_active_inactive_labels
    handles.delete_inactive.Enable='on';
    handles.show_active.Enable='on';
else
    handles.delete_inactive.Enable='off';
    handles.show_active.Enable='off';
end

if have_lumen_labels
    handles.LLO_panelchoice.Enable='on';
else
    handles.LLO_panelchoice.Enable='off';
end

if have_shell_labels
    handles.SLO_panelchoice.Enable='on';
else
    handles.SLO_panelchoice.Enable='off';
end

for i=1:numel(MUlist)
    if ~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==MUlist(i)),{'Lumen'}))
        all_MU_have_lumen=false;
    else
        all_MU_have_lumen=true;
    end
    if ~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==MUlist(i)),{'Shell'}))
        all_MU_have_shell=false;
    else
        all_MU_have_shell=true;
    end
end
lumen_is_MU_bracketed=true;
maxMU=max(MUlist);
for i=1:numel(labellist)
    if ~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==min([data.Labeltable.MorphoUnit(data.Labeltable.Label==labellist(i))+1 maxMU])),{'Lumen'}))||~any(contains(data.Labeltable.Class(data.Labeltable.MorphoUnit==max([data.Labeltable.MorphoUnit(data.Labeltable.Label==labellist(i))-1 1])),{'Lumen'}))
        lumen_is_MU_bracketed=false;
    end
end

all_MU_strictly_monotonic_increasing=all(diff(sort(MUlist))==1);

if any_label_visible
    handles.select_visible.Enable='on';
elseif no_label_visible
    handles.select_visible.Enable='off';
end

if no_label
    handles.appendage_removal.Enable='off';
    handles.delimit_in_situ.Enable='off';
    handles.transfer_label.Enable='off';
    handles.label_individual_shell.Enable='off';
    handles.delimit_in_vivo.Enable='off';
    handles.delimit_in_situ.Enable='off';
    handles.delimit_special.Enable='off';
    handles.delimit_convex.Enable='off';
    handles.delete.Enable='off';
    handles.combine.Enable='off';
    handles.transfer_label.Enable='off';
    handles.copy_label.Enable='off';
    handles.show_selection.Enable='off';
    handles.show_vicinity.Enable='off';
    handles.separate.Enable='off';
    handles.singularize.Enable='off';
    handles.divide.Enable='off';
    handles.split.Enable='off';
    handles.invert_selection.Enable='off';
    handles.recolor_label.Enable='off';
else % that would be any label
    handles.invert_selection.Enable='on';
    handles.recolor_label.Enable='on';
    handles.appendage_removal.Enable='on';
    handles.delete.Enable='on';
    handles.transfer_label.Enable='on';
    handles.copy_label.Enable='on';
    handles.show_selection.Enable='on';    
    if one_label
        handles.split.Enable='on';
        handles.divide.Enable='on';
        handles.show_vicinity.Enable='on';
    else
        handles.split.Enable='off';
        handles.divide.Enable='off';
    end
    if one_label&&are_lumina&&~have_many_patches
        handles.delimit_in_situ.Enable='on';
        handles.delimit_special.Enable='on';
    else
        handles.delimit_in_situ.Enable='off';
        handles.delimit_special.Enable='off';
    end
    if one_label&&~have_many_patches&&are_shell
        handles.delimit_convex.Enable='on';
    else
        handles.delimit_convex.Enable='off';
    end    
    if two_labels&&all_from_same_layer
        handles.merge.Enable='on';
    else
        handles.merge.Enable='off';
    end
    if two_labels
        handles.substract.Enable='on';
        handles.intersect.Enable='on';
    else
        handles.substract.Enable='off';
        handles.intersect.Enable='off';
    end
    if have_many_patches
        handles.singularize.Enable='on';
        handles.separate.Enable='on';
    else
        handles.singularize.Enable='off';
        handles.separate.Enable='off';
    end    
    if (many_labels||two_labels)&&all_from_same_layer
        handles.combine.Enable='on';
    else
        handles.combine.Enable='off';
    end            
    if one_label&&lumen_is_MU_bracketed&&are_lumina&&~have_many_patches
        handles.label_individual_shell.Enable='on';
    else
        handles.label_individual_shell.Enable='off';
    end
    if lumen_is_MU_bracketed&&are_lumina&&~have_many_patches&&all_MU_have_shell
        handles.delimit_in_vivo.Enable='on';
    else
        handles.delimit_in_vivo.Enable='off';
    end
end

function deselect_all()
global system
global patches
global jtableobj
global GlobalHandles

JTable=jtableobj.getViewport.getView;
for i=1:size(system.TempLabeltable,1)
    patch_name=['L' num2str(system.TempLabeltable.Label(i),'%04u')];
    patches.(patch_name).EdgeColor='none';
end
GlobalHandles.SelectedFieldHandle.String='';
system.TempLabeltable.selected(:)=false;
JTable.clearSelection();

function deselect_label(tbe)
global system
global data
global patches
global jtableobj
global GlobalHandles

JTable=jtableobj.getViewport.getView;
label=data.Labeltable.Label(tbe);
patch_name=['L' num2str(label,'%04u')];
patches.(patch_name).EdgeColor='none';

ex=strsplit(GlobalHandles.SelectedFieldHandle.String,' ');
if any(contains(ex,num2str(label)))
    if numel(ex)>1
        GlobalHandles.SelectedFieldHandle.String=strrep(GlobalHandles.SelectedFieldHandle.String,num2str(label),'');
        GlobalHandles.SelectedFieldHandle.String=regexprep(GlobalHandles.SelectedFieldHandle.String,' +',' ');
    else
        GlobalHandles.SelectedFieldHandle.String='';
    end
end
system.TempLabeltable.selected(system.TempLabeltable.Label==label)=false;

JTable.clearSelection();

%%% various ancillary functions %%%
function [XR,YR,ZR]=extract_label(labelfield)
xsum=sum(sum(labelfield,3),2);
ysum=sum(squeeze(sum(labelfield,3)),1);
zsum=sum(squeeze(sum(labelfield,1)),1);
XR=[find(xsum,1,'first') find(xsum,1,'last')];
YR=[find(ysum,1,'first') find(ysum,1,'last')];
ZR=[find(zsum,1,'first') find(zsum,1,'last')];

function d=pdistance(C1,C2)
d=sqrt(double((C1(1)-C2(1))^2+(C1(2)-C2(2))^2+(C1(3)-C2(3))^2));

function R = rotation_around_axis(ang,vec)
R=[cosd(ang)+vec(1)^2*(1-cosd(ang)) , vec(1)*vec(2)*(1-cosd(ang))-vec(3)*sind(ang) , vec(1)*vec(3)*(1-cosd(ang))+vec(2)*sind(ang); ...
    vec(2)*vec(1)*(1-cosd(ang))+vec(3)*sind(ang) , cosd(ang)+vec(2)^2*(1-cosd(ang)) , vec(2)*vec(3)*(1-cosd(ang))-vec(1)*sind(ang);...
    vec(3)*vec(1)*(1-cosd(ang))-vec(2)*sind(ang) , vec(3)*vec(2)*(1-cosd(ang))+vec(1)*sind(ang) , cosd(ang)+vec(3)^2*(1-cosd(ang))];

function vec_out = arbitrary_orthogonal(vec_in)
b0 = (abs(vec_in(1)) <  abs(vec_in(2))) && (abs(vec_in(1)) <  abs(vec_in(1)));
b1 = (abs(vec_in(2)) <= abs(vec_in(1))) && (abs(vec_in(2)) <  abs(vec_in(3)));
b2 = (abs(vec_in(3)) <= abs(vec_in(1))) && (abs(vec_in(3)) <= abs(vec_in(2)));
vec_out=cross(vec_in, [double(b0), double(b1), double(b2)]);

function Sout = specialsmooth3d(Sin,fsize,fsigma)
d=zeros(fsize,fsize,fsize);
d((fsize+1)/2,(fsize+1)/2,(fsize+1)/2)=1;
d=bwdist(d);
h=1/sqrt(2*pi*fsigma^2)*exp(-d.^2/(2*fsigma^2));
w=sum(sum(sum(h)));
h=h./w;

ppm = ParforProgressbar(numel(Sin),'title','Please wait...smoothing ambient occlusion field!');
dims=size(Sin);
Sout=zeros(dims);
margin=(fsize-1)/2;
msize=numel(Sin);

parfor i=1:numel(Sin)
    if Sin(i)>0
        [x,y,z]=ind2sub(dims,i);
        [x2,y2,z2]=meshgrid(x-margin:x+margin,y-margin:y+margin,z-margin:z+margin);
        v=(x2>0&x2<=dims(1))&(y2>0&y2<=dims(2))&(z2>0&z2<=dims(3));
        si=sub2ind(dims,x2(v),y2(v),z2(v));
        Ssi=Sin(si); %#ok<PFBNS>
        siv=Ssi>0;
        Sout(i)=sum(h(siv).*Ssi(siv))/sum(h(siv));         %#ok<PFBNS>
    end
    ppm.increment(); %#ok<PFBNS>
end
delete(ppm);

function AC = ambient_occlusion(Binary,Mask,n,l)
% computes the ambient occlusion of the given binary for all
% nonzero-locations with n random vectors of length l

AC=zeros(size(Binary));
dims=size(Binary);
ga=pi*(3-sqrt(5));
r=round(rand*10);
y=linspace (-1,1,n);
radius=sqrt(1-y.*y);
theta=ga.*(1+r:n+r);
x=cos(theta).*radius;
z=sin(theta).*radius;
vrn=[x',y',z'];
        
ppm = ParforProgressbar(numel(Binary),'title','Please wait...calculating ambient occlusion!');

parfor i=1:numel(Binary)
    if Binary(i)==1        
        T_AC=zeros(n,1);
        [x,y,z]=ind2sub(dims,i);
        for k=1:n
            vect=[x,y,z]+vrn(k,:).*(1:l)'; %#ok<PFBNS>
            vect=round(vect);
            %vect=unique(vect,'rows');
            to_del=any(vect(:,:)<1,2)|vect(:,1)>dims(1)|vect(:,2)>dims(2)|vect(:,3)>dims(3);
            vect(to_del,:)=[];
            indices=sub2ind(dims,vect(:,1),vect(:,2),vect(:,3));
            T_AC(k)=any(Mask(indices)); %#ok<PFBNS>
        end
        AC(i)=sum(T_AC)/n;
    end
    ppm.increment(); %#ok<PFBNS>
end
delete(ppm);

% function cone_rays=generate_conical_beam(base_vec,angle,rays)
% cone_rays=zeros(rays,3);
% base_vec=base_vec./sum(base_vec.^2,2).^0.5;
% dummy_vec=rand(3,1);
% ort_vec=cross(base_vec,dummy_vec);
% ort_vec=ort_vec./sum(ort_vec.^2,2).^0.5;
% cone_rot_angles=0:360/rays:359;
% cone_rays(1,:)=rotVecAroundArbAxis(base_vec,ort_vec,angle);
% for i=2:rays
%     cone_rays(i,:)=rotVecAroundArbAxis(cone_rays(1,:),base_vec,cone_rot_angles(i));
% end

function cone_rays=generate_fibonacci_cone(base_vec, angle, N)
theta_max = (angle*2*pi)/360;
cone_rays = zeros(N, 3);
phi_golden = (sqrt(5) - 1) / 2;
cos_theta_max = cos(theta_max);

for i = 0:N-1
    z = 1 - (1 - cos_theta_max) * (i + 0.5) / N;
    theta = acos(z); 
    phi = 2 * pi * phi_golden * i;        
    sin_theta = sqrt(1 - z^2);
    x = sin_theta * cos(phi);
    y = sin_theta * sin(phi);
    cone_rays(i+1, :) = [x, y, z];
end

if base_vec(3)==1
    return
elseif base_vec(3)==-1
    cone_rays(:,3)=-cone_rays(:,3);
    return
end

rotation_axis = cross([0, 0, 1], base_vec);
rotation_axis = rotation_axis / norm(rotation_axis);
rotation_angle = acos(dot([0 0 1], base_vec));

% Use Rodrigues' rotation formula
K = [    0, -rotation_axis(3),  rotation_axis(2);
     rotation_axis(3),     0, -rotation_axis(1);
    -rotation_axis(2), rotation_axis(1),     0];

R = eye(3) + sin(rotation_angle) * K + (1 - cos(rotation_angle)) * (K * K);

% Apply rotation to all directions
cone_rays = (R * cone_rays')';
if any(isnan(cone_rays))
    a=1;
end
    
function cone_rays=cover_radial_divergence(base_vec,radius,range)
matrix=[4 8 12 16];
cone_rays=zeros(sum(matrix(1:range)),3);
dummy_vec=rand(3,1);
ort_vec=cross(base_vec,dummy_vec);
ort_vec=ort_vec./sum(ort_vec.^2,2).^0.5;
n=1;
for k=1:range
    angle=(360*k)/(2*radius*pi);
    cone_rays(n,:)=rotVecAroundArbAxis(base_vec,ort_vec,angle);
    n=n+1;
    cone_rot_angle=360/matrix(k);
    for i=2:matrix(k)
        cone_rays(n,:)=rotVecAroundArbAxis(cone_rays(n-1,:),base_vec,cone_rot_angle);
        n=n+1;
    end
end

%%% various functions based on other people's work

function [vert, fac] = voxel_image(pts)
% Author: Stefan Schalk, 11 Feb 2011

np = size(pts,1);
vert = zeros(8*np,3);
fac = zeros(6*np,4,'uint32');
vert_bas = [-0.5,-0.5,-0.5;0.5,-0.5,-0.5;0.5,0.5,-0.5;-0.5,0.5,-0.5;-0.5,-0.5,0.5;0.5,-0.5,0.5;0.5,0.5,0.5;-0.5,0.5,0.5];
vert_bas = vert_bas.*([ones(8,1),ones(8,1),ones(8,1)]);
fac_bas = [1,2,3,4;1,2,6,5;2,3,7,6;3,4,8,7;4,1,5,8;5,6,7,8];
for vx = 1:np
    a = ((vx-1)*8+1):vx*8;
    for dim = 1:3
        vert( a,dim ) = vert_bas(:,dim) + pts(vx,dim);
    end
    fac ( ((vx-1)*6+1):vx*6,: ) = (vx - 1)*8*ones(6,4) + fac_bas;
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

%%%%%%%%%%%%%% THIS PART IS STILL TO CHECK %%%%%%%%%%%%%

function MainGUIWindow_WindowKeyPressFcn(~, eventdata, handles)
global system
global patches
global data

if ~isempty(eventdata.Modifier)
    if strcmp(eventdata.Key,'shift')
        system.temp.shift_pressed=true;
    elseif strcmpi(eventdata.Key,'s')&&strcmpi(eventdata.Modifier,'control')
        cheat={'off' 'on'};
        labels=str2num(handles.selected_labels.String);
        for k=1:numel(labels)
            cname=['L' num2str(labels(k),'%04u')];
            tbe=data.Labeltable.Label==labels(k);
            status=system.TempLabeltable.show(tbe);
            system.TempLabeltable.show(tbe)=~status;
            handles.MainTable.Data(tbe,3)={~status};
            patches.(cname).Visible=cheat{~status+1};
        end
    elseif strcmpi(eventdata.Key,'a')&&strcmpi(eventdata.Modifier,'control')
        cheat={'on','off'};
        btext={'View','Select'};
        new_val=mod(handles.mode.Value+1,2);
        rotate3d(handles.Axes,cheat{new_val+1});
        handles.mode.String=btext{new_val+1};
        handles.mode.Value=logical(new_val);
        hManager = uigetmodemanager(handles.MainGUIWindow);
        [hManager.WindowListenerHandles.Enabled] = deal(false);  % HG2
        set(handles.MainGUIWindow, 'WindowKeyPressFcn', []);
        set(handles.MainGUIWindow, 'KeyPressFcn',@(hObject,eventdata)MFSE_Main('MainGUIWindow_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));
    elseif strcmpi(eventdata.Key,'q')&&strcmpi(eventdata.Modifier,'control')
        labels=str2num(handles.selected_labels.String);
        if ~isempty(labels)&&sum(any(data.Labeltable.Label==labels))>0
            choice = questdlg('Sure about this?','Delete label(s)','Yes','No','No');
            if strcmp(choice,'Yes')
                for i=1:numel(labels)
                    label=labels(i);
                    remove_entry(label);
                end
                populate_table(handles,false,false);
            end
        end
    elseif strcmp(eventdata.Modifier,'control')
        system.temp.control_pressed=true;
    end
else
end

function ingest_segmentation_struct (Seg,handles)
global data
global system
global jtableobj
global cali

data=Seg;

system.temp.hit_from_patch=false;
system.temp.shift_pressed=false;
system.temp.cancel=false;
% system.temp.current_load_path=[pwd '\'];
% system.temp.current_save_path=[pwd '\'];
% system.temp.current_export_path=[pwd '\'];
system.temp.settingsGUI_active=false;
system.temp.has_external_AO=false;
system.temp.view=[-37.5,30];
system.temp.temp.current_center=data.basicshell.Centroid;
system.corollary=data.display;

system.TempLabeltable=table;
system.TempLabeltable.Label=data.Labeltable.Label;
system.TempLabeltable.show=false(size(data.Labeltable.Label,1),1);
system.TempLabeltable.selected=false(size(data.Labeltable.Label,1),1);
system.TempLabeltable.Distance=zeros(size(data.Labeltable.Label,1),1);

populate_table(handles,false,false);
handles.projectname.String=data.header.Projectname;
handles.dimensions.String=[num2str(data.header.Dimensions(1)) ' / ' num2str(data.header.Dimensions(2)) ' / ' num2str(data.header.Dimensions(3))];
handles.shellsource.String=data.header.BasicShellSegmentationSource;
handles.labelsource.String=data.header.PrimaryLumenSegmentationSource;
handles.voxelsize.String=num2str(sum(data.header.Voxelsize));
handles.comment.String=data.header.Comment;

handles.show_shell.Value=0;
handles.shell_color.Enable='on';
handles.shell_opacity.Enable='on';
handles.save_msd.Enable='on';
handles.revert_msd.Enable='on';

populate_graph(handles);
show_all_Callback(0,0,handles)
handles.Axes.View=system.temp.view;
camlight (cali,'headlight');
handles.mode.Value=0;
handles.mode.String='View';
handles.SPI_panel.Visible='on';
handles.MC_panel.Visible='on';
handles.BSS_panel.Visible='on';
handles.TDV_panel.Visible='on';
handles.GLO_panel.Visible='on';
handles.LD_panel.Visible='on';
handles.CC_panel.Visible='on';
handles.GLO_panelchoice.Visible='on';
handles.GLO_panelchoice.Value=1;
handles.LLO_panelchoice.Visible='on';
handles.SLO_panelchoice.Visible='on';
jtableobj=findjobj(handles.MainTable,'persist');

%%% general label functions %%%
function export_RAW_Callback(~, ~, handles)
global data
global system

app=[handles.projectname.String ' [' num2str(data.header.Dimensions(1)) 'x' num2str(data.header.Dimensions(2)) 'x' num2str(data.header.Dimensions(3)) 'x' num2str(size(data.Labelfield,4)) ' - ' num2str(data.header.Voxelsize) ' um - ushort LE]'];
[filename, pathname] = uiputfile('*.raw','Save data as',fullfile(system.temp.current_export_path,app));
if isequal(filename,0) || isequal(pathname,0)
    return
else
    system.temp.current_export_path=pathname;
    fid=fopen(fullfile(pathname, filename),'w');
    fwrite(fid,data.Labelfield,'uint16');
    fclose (fid);
end
h=custom_msgbox(['Segmentation data has been exported as ' filename],'','none',[],true);

function export_GIPL_MenuCallback(~, ~, handles)
global data
global system

answer=inputdlg({'Enter the label number for the basic shell segmentation [0 to exclude]:' 'Enter the layer number to export:'},'',1,{'65535','1'});
if ~isempty(answer)
    Shelllabel=str2num(answer{1});
    SelLayer=str2num(answer{2});
else
    return
end
if ~isempty(Shelllabel)&&~any(ismember(data.Labeltable.Label,Shelllabel))&&~isempty(SelLayer)&&SelLayer<=size(data.Labelfield,4)
    GIPL=uint16(zeros(data.header.Dimensions));
    if  Shelllabel>0
        Shell=data.basicshell.Binary;
        GIPL(Shell)=Shelllabel; %65535;
    end
    labellist=unique(data.Labelfield(:,:,:,SelLayer));
    h=custom_waitbar('Please wait...preparing GIPL data',[],false);
    for i=2:numel(labellist)
        GIPL(ismember(data.Labelfield(:,:,:,SelLayer),labellist(i)))=labellist(i);
        waitbar(i/numel(labellist),h);
    end
    delete (h);
    [filename, pathname] = uiputfile('*.gipl','Save data as',fullfile(system.temp.current_export_path,handles.projectname.String));
    if isequal(filename,0) || isequal(pathname,0)
        return
    else
        gipl_write_volume(GIPL,fullfile(pathname, filename),[data.header.Voxelsize data.header.Voxelsize data.header.Voxelsize]);
        labelname=[filename(1:end-4) 'txt'];
        export_ITK_Labels(fullfile(pathname, labelname),Shelllabel);
    end
    h=custom_msgbox(['Segmentation data and label description have been exported as ' filename ' and ' labelname ],'','none',[],true);
else
    h=custom_msgbox('Please select a valid shell label and layer for this operation!','','error',[],true);
end

function export_ITK_Labels(fufiname,Shelllabel)
global data
global system

try
    fileID = fopen(fufiname,'W');
    fprintf(fileID,'################################################\r\n');
    fprintf(fileID,'# ITK-SnAP Label Description File\r\n');
    fprintf(fileID,'# File format: \r\n');
    fprintf(fileID,'# IDX   -R-  -G-  -B-  -A--  VIS MSH  LABEL\r\n');
    fprintf(fileID,'# Fields: \r\n');
    fprintf(fileID,'#    IDX:   Zero-based index \r\n');
    fprintf(fileID,'#    -R-:   Red color component (0..255)\r\n');
    fprintf(fileID,'#    -G-:   Green color component (0..255)\r\n');
    fprintf(fileID,'#    -B-:   Blue color component (0..255)\r\n');
    fprintf(fileID,'#    -A-:   Label transparency (0.00 .. 1.00)\r\n');
    fprintf(fileID,'#    VIS:   Label visibility (0 or 1)\r\n');
    fprintf(fileID,'#    IDX:   Label mesh visibility (0 or 1)\r\n');
    fprintf(fileID,'#  LABEL:   Label description \r\n');
    fprintf(fileID,'################################################\r\n');
    fprintf(fileID,'  0   0   0   0        0  0  0    "Clear Label"\r\n');
    for i=1:size(data.Labeltable,1)
        fprintf(fileID,['  ',num2str(data.Labeltable.Label(i)),'   ',num2str(round(system.corollary.colormap(i,1)*255)),'  ',num2str(round(system.corollary.colormap(i,2)*255)),'  ',num2str(round(system.corollary.colormap(i,3)*255)),'        ','1']);
        fprintf(fileID,['  ',num2str(system.TempLabeltable.show(i)),'  ',num2str(system.TempLabeltable.show(i)),'    "',data.Labeltable.Name{i},'"\r\n']);
    end
    fprintf(fileID,['  ' num2str(Shelllabel) '   225  228  225        0.5  1  0    "Basic shell"\r\n']);
    fclose (fileID);
    %h=custom_msgbox(['Label description has been exported as ' filename],'','none',[],true);
catch ME
    disp (ME.identifier)
    switch ME.identifier
        case 'sads'
            h=custom_msgbox({'Could not write to disk';'The file might be locked by another process or you lack writing permissions to the file location!'},'','error',[],true);
        otherwise
            h=custom_msgbox('An unknown error occured during saving the file to disk!','','error',[],true);
    end
    fclose (fileID);
end
    
function finalize_all_individuals_MacroMenuCallback(~, ~, handles)
global data
global patches

h=custom_msgbox('Please wait a few seconds...assigning yet unassigned shell voxels!','','help',[],false);
primaryshelllist=data.Labeltable.Label(contains(data.Labeltable.Class,'Shell')&contains(data.Labeltable.Group,'primary'));

A=false(3,3,3);
A(:,:,1)=[0 1 0;1 1 1;0 1 0];
A(:,:,2)=[1 1 1;1 1 1;1 1 1];
A(:,:,3)=[0 1 0;1 1 1;0 1 0];
SE6=strel('sphere',1);
SE18=strel('arbitrary',A);

Secondary=data.Labelfield(:,:,:,1);
Secondary(:,:,:)=0;

MUnums=unique(data.Labeltable.MorphoUnit);
Shellnums=zeros(numel(MUnums),1);
for i=1:numel(MUnums)
    Shellnums(i)=data.Labeltable.Label(contains(data.Labeltable.Class,'Shell')&contains(data.Labeltable.Group,'primary')&data.Labeltable.MorphoUnit==MUnums(i));
end
PrimaryShell=ismember(data.Labelfield(:,:,:,1),Shellnums);
UnassignedShell=data.basicshell.Binary&~PrimaryShell;
for i=1:numel(Shellnums)
    Secondary(ismember(data.Labelfield(:,:,:,1),Shellnums(i)))=Shellnums(i);
end

while ~isempty(MUnums)
    to_remove=[];
    for n=1:numel(MUnums)
        current_MU_shell_n=data.Labeltable.Label(contains(data.Labeltable.Class,'Shell')&data.Labeltable.MorphoUnit==MUnums(n));
        higher_than_current_MU_shell_n=data.Labeltable.Label(contains(data.Labeltable.Class,'Shell')&data.Labeltable.MorphoUnit>MUnums(n));
        dilated_current_MU_Shell_6=imdilate(ismember(Secondary,current_MU_shell_n),SE6);
        dilated_current_MU_Shell_18=imdilate(ismember(Secondary,current_MU_shell_n),SE18);
        dilated_other_MU_Shell_6=imdilate(ismember(Secondary,higher_than_current_MU_shell_n),SE6);
        sec_current_MU_shell=dilated_current_MU_Shell_6&UnassignedShell;
        sec_current_MU_shell=sec_current_MU_shell|((dilated_current_MU_Shell_18&~dilated_current_MU_Shell_6)&~dilated_other_MU_Shell_6&UnassignedShell);
        if sum(sum(sum(sec_current_MU_shell)))>0
            Secondary(sec_current_MU_shell)=Shellnums(n);
            UnassignedShell=data.basicshell.Binary&~logical(Secondary);
        else
            to_remove=[to_remove n];              %#ok<AGROW>
        end
    end
    MUnums(to_remove)=[];
    Shellnums(to_remove)=[];
end
Shelllist=unique(Secondary);
Shelllist(Shelllist==0)=[];
for i=1:numel(Shelllist)
    tbe=data.Labeltable.Label==Shelllist(i);
    new_name=[strrep(data.Labeltable.Name{tbe},' primary shell',''),' complete shell'];
    add_entry(handles,ismember(Secondary,Shelllist(i)),2,data.Labeltable.MorphoUnit(tbe),'Shell','complete',data.Labeltable.Type(tbe),new_name);
end
populate_table(handles,false,false);
delete (h);

function add_layer(N)
global data

NL=uint16(zeros([data.header.Dimensions N]));
data.Labelfield=cat(4,data.Labelfield,NL);

function copy_label_Callback(~, ~, handles)
global data
global patches

labels=str2num(handles.selected_labels.String);
suggested_layer=suggest_layer(labels);
answer=inputdlg({'Enter the name for the new label:','Enter the target layer'},'',1,{'Unnamed label',suggested_layer});
if isempty(answer)
    return
else
    if ~isempty(answer(2))&&isnumeric(answer(2))
        Name=answer{1};
        trg_layer=str2num(answer{2});
        if trg_layer<=4
            if size(data.Labelfield,4)<trg_layer
                add_layer(trg_layer-size(data.Labelfield,4))
            end
            labels=str2num(handles.selected_labels.String);
            h=custom_waitbar('Please wait...copying label(s)!',[],false);
            for i=1:numel(labels)
            index=find(data.Labeltable.Label==labels(i), 1);
            src_layer=data.Labeltable.Layer(index);
            src_field=data.Labelfield(:,:,:,src_layer);
            trg_field=data.Labelfield(:,:,:,trg_layer);
            F=ismember(src_field,labels(i));
            trg_field(F)=src_field(F);
            data.Labelfield(:,:,:,trg_layer)=trg_field;
            add_entry(handles,F,trg_layer,data.Labeltable.MorphoUnit(index),data.Labeltable.Class(index),data.Labeltable.Group(index),data.Labeltable.Type(index),data.Labeltable.Name(index));
            end
                populate_table(handles,true,false);
            delete (h);
        else       
            h=custom_msgbox('An maximum of four layers are currently allowed!','','error',[],true);
        end
    else
        
    end
end

function Preferences_MenuCallback(hObject,~,handles)
global system

if ~system.temp.settingsGUI_active
    handles.Preferences.Enable='off';
    system.temp.settingsGUI_active=true;
    SecondWindow=openfig('MFSE_SettingsGUI.fig');
    handlesSecondary=guihandles(SecondWindow);
    guidata(hObject, handles);
    handlesSecondary.MFSE_Settings.Name='MicroFossil Segmentation Editor Settings';
    SecondWindow.CloseRequestFcn=@(hObject,eventdata)Settings_Window_close(handles,handlesSecondary);
    handlesSecondary.SettingsDefaults.Callback=@(hObject,eventdata)MFSE_Main('Settings_defaults',hObject,eventdata,handlesSecondary);
    handlesSecondary.SettingsLoadPrefs.Callback=@(hObject,eventdata)MFSE_Main('Settings_load_prefs',hObject,eventdata,handlesSecondary);
    handlesSecondary.SettingsSavePrefs.Callback=@(hObject,eventdata)MFSE_Main('Settings_save_prefs',hObject,eventdata,handlesSecondary);
    handlesSecondary.SettingsApply.Callback=@(hObject,eventdata)MFSE_Main('Settings_apply',hObject,eventdata,handlesSecondary,handles);
    handlesSecondary.SettingsCancel.Callback=@(hObject,eventdata)Settings_Window_close(handles,handlesSecondary);
    Populate_settings(handlesSecondary);
end

function Settings_Window_close(handles,handlesSecondary)
global system
system.temp.settingsGUI_active=false;
handles.Preferences.Enable='on';
delete(handlesSecondary.MFSE_Settings)

function Populate_settings(handlesSecondary)
global system

handlesSecondary.workers_available.String=num2str(system.temp.available_pworkers);
handlesSecondary.workers_to_use.String=num2str(system.static.pworkers_to_use*100);
handlesSecondary.startup_pool.Value=strcmp(system.static.startup_parallel_cluster,'true');
handlesSecondary.specular_lighting.String=num2str(system.corollary.light_specular);
handlesSecondary.ambient_lighting.String=num2str(system.corollary.light_ambient);
handlesSecondary.diffuse_lighting.String=num2str(system.corollary.light_diffuse);

fn=fieldnames(system.static.Operations);
n=1;
for k=1:numel(fn)
    OpsName={strrep(fn{k},'_',' ')};
    for p=1:numel(system.static.Operations.(fn{k}).Name)
        handlesSecondary.LODtable.Data(n,1)=OpsName;
        handlesSecondary.LODtable.Data(n,2)=system.static.Operations.(fn{k}).Name(p);
        handlesSecondary.LODtable.Data(n,3)=system.static.Operations.(fn{k}).Unit(p);
        handlesSecondary.LODtable.Data(n,4)=system.static.Operations.(fn{k}).Value(p);
        n=n+1;
    end
end

for k=1:size(system.static.TableOptParmList,1)
    handlesSecondary.LTOPtable.Data(k,1)=system.static.TableOptParmList.LongName(k);
    handlesSecondary.LTOPtable.Data(k,2)=system.static.TableOptParmList.Unit(k);
    handlesSecondary.LTOPtable.Data(k,3)=system.static.TableOptParmList.ShortName(k);
    handlesSecondary.LTOPtable.Data(k,4)={system.static.TableOptParmList.Set(k)};
end

function Settings_apply(~,~,handlesSecondary,handles)
global system
old_corollary_settings=system.corollary;
old_static_settings=system.static;

system.corollary.light_ambient=str2num(handlesSecondary.ambient_lighting.String);
system.corollary.light_specular=str2num(handlesSecondary.specular_lighting.String);
system.corollary.light_diffuse=str2num(handlesSecondary.diffuse_lighting.String);

graphics_change=false;
fn=fieldnames(old_corollary_settings);
for i=1:numel(fn)
    if system.corollary.(fn{i})~=old_corollary_settings.(fn{i})
        graphics_change=true;
    end
end

system.static.TableOptParmList.Set=cell2mat(handlesSecondary.LTOPtable.Data(:,4));

pool_change=false;
system.static.pworkers_to_use=str2num(handlesSecondary.workers_to_use.String)/100;
if old_static_settings.pworkers_to_use~=system.static.pworkers_to_use
    pool_change=true;
end

if pool_change
    if ~isempty (gcp('nocreate'))
        evalc('delete(gcp(''nocreate''))');
        pinfo=parcluster;
        evalc('ppool=parpool(pinfo,round(system.static.pworkers_to_use*pinfo.NumWorkers))');
        ppool.IdleTimeout=120; %#ok<STRNU>
    end
end

OldOperation=[];
for k=1:size(handlesSecondary.LODtable.Data,1)
    if k>1
        OldOperation=Operation;
    end
    Operation=handlesSecondary.LODtable.Data(k,1);
    OpsName=strrep(handlesSecondary.LODtable.Data{k,1},' ','_');
    if strcmp(OldOperation,Operation)
        p=p+1;
    else
        p=1;
    end    
    system.static.Operations.(OpsName).Value(p)=handlesSecondary.LODtable.Data(k,4);    
end

if ~isempty(system.temp.filename)
    if graphics_change
        populate_graph(handles);
    end
    populate_table(handles,true,true);
end

function Settings_defaults(~,~,handlesSecondary)
global system

system.corollary.light_ambient=system.defaults.light_ambient;
system.corollary.light_specular=system.defaults.light_specular;
system.corollary.light_diffuse=system.defaults.light_diffuse;
system.TableOptParmList{:,4}={system.defaults.OptParmList};
system.static.pworkers_to_use=system.defaults.pworkers_to_use;
system.static.startup_parrallel_cluster='false';
system.static.Operation=system.defaults.Operations;
Populate_settings(handlesSecondary);

function Settings_load_prefs(~,~,handlesSecondary)
global system

[filename, pathname] = uigetfile([system.temp.current_load_path '*.dat'],'Select a MFSE preferences data file');
if isequal(filename,0) || isequal(pathname,0)
    return
else
    load(fullfile(pathname, filename),'-mat','system');
end
system.temp.hit_from_patch=false;
system.temp.shift_pressed=false;
system.temp.control_pressed=false;
system.temp.cancel=false;
system.temp.current_load_path=[pwd '\'];
system.temp.current_save_path=[pwd '\'];
system.temp.current_export_path=[pwd '\'];
system.temp.settingsGUI_active=false;
system.temp.has_external_AO=false;
system.temp.view=[-37.5,30];
system.temp.revert_filename=[];
pinfo=parcluster;
system.temp.available_pworkers=pinfo.NumWorkers;
system.temp.current_center=[0 0 0];
system.temp.filename=[];
system.temp.LastSort={'Label','ascend'};
system.temp.hit_from_table_renew=false;
Populate_settings(handlesSecondary);

function Settings_save_prefs(~,~,handlesSecondary)
global system

[filename, pathname] = uiputfile('*.dat','Save preferences as', fullfile(system.temp.current_save_path,'MFSE_preferences_X'));
if isequal(filename,0) || isequal(pathname,0)
    return
else
    save(fullfile(pathname, filename),'system','-mat','-v7.3');
    h=custom_msgbox(['Preferences have been saved as ' filename],'','none',[],true);        
end

function filter_parameter_Callback(hObject, ~, handles)
global system

parm=hObject.String(hObject.Value);
idx=find(contains(handles.MainTable.ColumnName,parm));
handles.filter_min.String={num2str(min(cell2mat(handles.MainTable.Data(:,idx))))};
handles.filter_max.String={num2str(max(cell2mat(handles.MainTable.Data(:,idx))))};

function Panelchoice_Callback(hObject, ~, handles)
if hObject.Value==1
    panels={'GLO' 'LLO' 'SLO'};
    for i=1:3
        panelname=[panels{i} '_panel'];
        buttonname=[panels{i} '_panelchoice'];
        if contains(hObject.Tag,panels{i})            
            handles.(panelname).Visible='on';
        else
            handles.(panelname).Visible='off';
            handles.(buttonname).Value=0;
        end
    end
else
    hObject.Value=1;
end

function Camera_Callback(hObject, ~, handles)
global cali

switch hObject.Tag
    case 'Camera_roll_pos'
        camroll(handles.Axes,5);
    case 'Camera_roll_neg'
        camroll(handles.Axes,-5);
    case 'Camera_zoom_pos'
        camzoom(handles.Axes,1/0.9);
    case 'Camera_zoom_neg'
        camzoom(handles.Axes,0.9);
    case 'Camera_orbit_l'
        camorbit(handles.Axes,5,0);
        camlight (cali,'headlight');
    case 'Camera_orbit_r'
        camorbit(handles.Axes,-5,0);
        camlight (cali,'headlight');
    case 'Camera_orbit_u'
        camorbit(handles.Axes,0,5);
        camlight (cali,'headlight');
    case 'Camera_orbit_d'
        camorbit(handles.Axes,0,-5);
        camlight (cali,'headlight');
end
