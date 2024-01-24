function varargout = Figure_fusion(varargin)
% FIGURE_FUSION MATLAB code for Figure_fusion.fig
%      FIGURE_FUSION, by itself, creates a new FIGURE_FUSION or raises the existing
%      singleton*.
%
%      H = FIGURE_FUSION returns the handle to a new FIGURE_FUSION or the handle to
%      the existing singleton*.
%
%      FIGURE_FUSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_FUSION.M with the given input arguments.
%
%      FIGURE_FUSION('Property','Value',...) creates a new FIGURE_FUSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Figure_fusion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Figure_fusion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Figure_fusion

% Last Modified by GUIDE v2.5 19-Nov-2023 21:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Figure_fusion_OpeningFcn, ...
                   'gui_OutputFcn',  @Figure_fusion_OutputFcn, ...
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


% --- Executes just before Figure_fusion is made visible.
function Figure_fusion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Figure_fusion (see VARARGIN)

% Choose default command line output for Figure_fusion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Figure_fusion wait for user response (see UIRESUME)
% uiwait(handles.Figure_fusion);
clc;
handles.figure1=[];handles.figure2=[];
handles.fusion=[];handles.compare=[];
handles.wavetype=1;handles.n=2;handles.weight1=0.5;handles.weight2=0.5;
axes(handles.axes_figure1);title('融合图像1');
axes(handles.axes_figure2);title('融合图像2');
axes(handles.axes_fusion);title('融合结果');
axes(handles.axes_compare);title('理想结果对比');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Figure_fusion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_figure1.
function pushbutton_figure1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
if(isequal(filename,0) || isequal(pathname,0))
    % do nothing
else
    percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
    handles.figure1=imread([pathname,filename]);
    percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    axes(handles.axes_figure1);
    imshow(handles.figure1);
    title('融合图像1');
    percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_figure2.
function pushbutton_figure2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_figure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
if(isequal(filename,0) || isequal(pathname,0))
    % do nothing
else
    percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
    handles.figure2=imread([pathname,filename]);
    percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    axes(handles.axes_figure2);
    imshow(handles.figure2);
    title('融合图像2');
    percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_fusion.
function pushbutton_fusion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 图像融合部分
handles.wavetype=get(handles.popupmenu_wavetype,'value');
handles.n=str2double(get(handles.edit_n,'string'));
handles.weight1=str2double(get(handles.edit_weight1,'string'));
handles.weight2=str2double(get(handles.edit_weight2,'string'));
percentage=0;h_waitbar=waitbar(percentage,'计算中......0%','name','请稍候'); 
image1=double(handles.figure1)/256;
image2=double(handles.figure2)/256;
percentage=0.25;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
switch handles.wavetype
    case 1
        [c1,s1]=wavedec2(image1,handles.n,'haar');
        [c2,s2]=wavedec2(image2,handles.n,'haar');
    case 2
        [c1,s1]=wavedec2(image1,handles.n,'db4');
        [c2,s2]=wavedec2(image2,handles.n,'db4');
    case 3
        [c1,s1]=wavedec2(image1,handles.n,'sym4');
        [c2,s2]=wavedec2(image2,handles.n,'sym4');
end
percentage=0.5;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
c=handles.weight1*c1+handles.weight2*c2;
s=round(handles.weight1*s1+handles.weight2*s2);
percentage=0.75;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
switch handles.wavetype
    case 1
        handles.fusion=waverec2(c,s,'haar');
    case 2
        handles.fusion=waverec2(c,s,'db4');
    case 3
        handles.fusion=waverec2(c,s,'sym4');
end
axes(handles.axes_fusion);
imshow(handles.fusion,[]);
title('融合结果');
percentage=1;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
close(h_waitbar);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_compare.
function pushbutton_compare_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
if(isequal(filename,0) || isequal(pathname,0))
    % do nothing
else
    percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
    handles.compare=imread([pathname,filename]);
    percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    axes(handles.axes_compare);
    imshow(handles.compare);
    title('理想结果对比');
    percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
if isequal(filename,0) || isequal(pathname,0)
    % do nothing
else
    percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
    imwrite(mat2gray(handles.fusion),[pathname,filename]);  
    percentage=1;waitbar(percentage,h_waitbar,['保存中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

function edit_weight1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_weight1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_weight1 as text
%        str2double(get(hObject,'String')) returns contents of edit_weight1 as a double


% --- Executes during object creation, after setting all properties.
function edit_weight1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_weight1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_weight2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_weight2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_weight2 as text
%        str2double(get(hObject,'String')) returns contents of edit_weight2 as a double


% --- Executes during object creation, after setting all properties.
function edit_weight2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_weight2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double


% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_wavetype.
function popupmenu_wavetype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_wavetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_wavetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_wavetype


% --- Executes during object creation, after setting all properties.
function popupmenu_wavetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_wavetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
