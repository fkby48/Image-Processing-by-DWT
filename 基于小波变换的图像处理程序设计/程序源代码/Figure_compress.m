function varargout = Figure_compress(varargin)
% FIGURE_COMPRESS MATLAB code for Figure_compress.fig
%      FIGURE_COMPRESS, by itself, creates a new FIGURE_COMPRESS or raises the existing
%      singleton*.
%
%      H = FIGURE_COMPRESS returns the handle to a new FIGURE_COMPRESS or the handle to
%      the existing singleton*.
%
%      FIGURE_COMPRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_COMPRESS.M with the given input arguments.
%
%      FIGURE_COMPRESS('Property','Value',...) creates a new FIGURE_COMPRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Figure_compress_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Figure_compress_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Figure_compress

% Last Modified by GUIDE v2.5 19-Nov-2023 22:45:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Figure_compress_OpeningFcn, ...
                   'gui_OutputFcn',  @Figure_compress_OutputFcn, ...
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


% --- Executes just before Figure_compress is made visible.
function Figure_compress_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Figure_compress (see VARARGIN)

% Choose default command line output for Figure_compress
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Figure_compress wait for user response (see UIRESUME)
% uiwait(handles.Figure_compress);
clc;
handles.original=[];handles.compress1=[];handles.compress2=[];
handles.wavetype=1;handles.n=2;
axes(handles.axes_original);title('原图像');
axes(handles.axes_compress1);title('第一次压缩图像');
axes(handles.axes_compress2);title('第二次压缩图像');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Figure_compress_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbutton_compress.
function pushbutton_compress_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 压缩图像按钮（核心代码）
try
    handles.wavetype=get(handles.popupmenu_wavetype,'value');
    handles.n=str2double(get(handles.edit_n,'string'));
    percentage=0;h_waitbar=waitbar(percentage,'处理中......0%','name','请稍候'); 
    compress_img=double(handles.original)/255;
    switch handles.wavetype
        case 1
            [C,S]=wavedec2(compress_img,handles.n,'haar'); %进行小波变换
            CA1=appcoef2(C,S,'haar',1); % 获取第1层的低频系数
            CA2=appcoef2(C,S,'haar',2); % 获取第2层的低频系数
        case 2
            [C,S]=wavedec2(compress_img,handles.n,'db4');
            CA1=appcoef2(C,S,'db4',1);
            CA2=appcoef2(C,S,'db4',2);
        case 3
            [C,S]=wavedec2(compress_img,handles.n,'sym4');
            CA1=appcoef2(C,S,'sym4',1);
            CA2=appcoef2(C,S,'sym4',2);
    end
    percentage=0.3;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    %第1层，对应第一次压缩
    handles.compress1=CA1;
    axes(handles.axes_compress1);
    imshow(handles.compress1,[]);
    title('第一次压缩图像');
    percentage=0.6;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    %第2层，对应第二次压缩
    handles.compress2=CA2;
    axes(handles.axes_compress2);
    imshow(handles.compress2,[]);
    title('第二次压缩图像');
    percentage=0.9;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    temp0=handles.original;temp1=uint8(handles.compress1);temp2=uint8(handles.compress2);
    info0=whos('temp0');info1=whos('temp1');info2=whos('temp2');
    percentage1=round((info1.bytes/info0.bytes)*1000)/10;
    percentage2=round((info2.bytes/info0.bytes)*1000)/10;
    axes(handles.axes_compress1);
    title(['第一次压缩图像,压缩比:',num2str(percentage1),'%']);
    axes(handles.axes_compress2);
    title(['第二次压缩图像,压缩比:',num2str(percentage2),'%']);
    percentage=1;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    close(h_waitbar);
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'处理图像出错');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_save1.
function pushbutton_save1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存第一次压缩图像按钮
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
        imwrite(mat2gray(handles.compress1),[pathname,filename]);  
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

% --- Executes on button press in pushbutton_save2.
function pushbutton_save2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存第二次压缩图像按钮
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
        imwrite(mat2gray(handles.compress2),[pathname,filename]);  
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
