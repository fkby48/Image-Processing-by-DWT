function varargout = Figure_preprocess(varargin)
% FIGURE_PREPROCESS MATLAB code for Figure_preprocess.fig
%      FIGURE_PREPROCESS, by itself, creates a new FIGURE_PREPROCESS or raises the existing
%      singleton*.
%
%      H = FIGURE_PREPROCESS returns the handle to a new FIGURE_PREPROCESS or the handle to
%      the existing singleton*.
%
%      FIGURE_PREPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_PREPROCESS.M with the given input arguments.
%
%      FIGURE_PREPROCESS('Property','Value',...) creates a new FIGURE_PREPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Figure_preprocess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Figure_preprocess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Figure_preprocess

% Last Modified by GUIDE v2.5 12-May-2024 22:44:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Figure_preprocess_OpeningFcn, ...
                   'gui_OutputFcn',  @Figure_preprocess_OutputFcn, ...
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


% --- Executes just before Figure_preprocess is made visible.
function Figure_preprocess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Figure_preprocess (see VARARGIN)

% Choose default command line output for Figure_preprocess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Figure_preprocess wait for user response (see UIRESUME)
% uiwait(handles.Figure_preprocess);
clc;
handles.original=[];handles.preprocess=[];
handles.preprocess_type=1;
handles.noise_mean=0;handles.noise_var=0.01;
axes(handles.axes_original);title('原图像');
axes(handles.axes_preprocess);title('预处理后图像');
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Figure_preprocess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_original.
function pushbutton_original_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取原图像按钮
try
    [filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
    if(isequal(filename,0) || isequal(pathname,0))
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
        handles.original=imread([pathname,filename]);
        percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
        axes(handles.axes_original);
        imshow(handles.original);
        title('原图像');
        percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
        close(h_waitbar);
    end
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'读取图像出错');
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_preprocess_type.
function popupmenu_preprocess_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_preprocess_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_preprocess_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_preprocess_type
% 改变下拉栏选项时触发
preprocess_type=get(handles.popupmenu_preprocess_type,'value');
switch preprocess_type
    case 1
        set(handles.edit_noise_mean,'enable','off');
        set(handles.edit_noise_var,'enable','off');
    case {2,3}
        set(handles.edit_noise_mean,'enable','on');
        set(handles.edit_noise_var,'enable','on');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_preprocess_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_preprocess_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% 改变下拉栏选项时触发
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_preprocess.
function pushbutton_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 图像预处理按钮（核心代码）
try
    handles.preprocess_type=get(handles.popupmenu_preprocess_type,'value');
    percentage=0;h_waitbar=waitbar(percentage,'处理中......0%','name','请稍候'); 
    switch handles.preprocess_type
        case 1 %图像转灰度
            if(numel(size(handles.original))==3) %判断是彩图还是灰度图，3为彩图
                handles.preprocess=rgb2gray(handles.original);
            else
                handles.preprocess=handles.original;
            end
        case 2 %图像加噪
            handles.noise_mean=str2double(get(handles.edit_noise_mean,'string'));
            handles.noise_var=str2double(get(handles.edit_noise_var,'string'));
            handles.preprocess=imnoise(handles.original, 'gaussian', handles.noise_mean, handles.noise_var);
        case 3 %灰度并加噪
            handles.noise_mean=str2double(get(handles.edit_noise_mean,'string'));
            handles.noise_var=str2double(get(handles.edit_noise_var,'string'));
            if(numel(size(handles.original))==3) %判断是彩图还是灰度图
                temp=rgb2gray(handles.original);
            else
                temp=handles.original;
            end
            handles.preprocess=imnoise(temp, 'gaussian', handles.noise_mean, handles.noise_var);
    end
    percentage=0.8;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    axes(handles.axes_preprocess);
    imshow(handles.preprocess,[]);
    title('预处理后图像');
    percentage=1;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    close(h_waitbar);
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'处理图像出错');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存预处理图像按钮
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
        imwrite(mat2gray(handles.preprocess),[pathname,filename]);  
        percentage=1;waitbar(percentage,h_waitbar,['保存中......',num2str(percentage*100),'%']);
        close(h_waitbar);
    end
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'保存图像出错');
end
guidata(hObject, handles);


function edit_noise_mean_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise_mean as text
%        str2double(get(hObject,'String')) returns contents of edit_noise_mean as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_mean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_noise_var_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise_var as text
%        str2double(get(hObject,'String')) returns contents of edit_noise_var as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
