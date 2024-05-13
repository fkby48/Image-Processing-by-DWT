function varargout = Figure_hide(varargin)
% FIGURE_HIDE MATLAB code for Figure_hide.fig
%      FIGURE_HIDE, by itself, creates a new FIGURE_HIDE or raises the existing
%      singleton*.
%
%      H = FIGURE_HIDE returns the handle to a new FIGURE_HIDE or the handle to
%      the existing singleton*.
%
%      FIGURE_HIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_HIDE.M with the given input arguments.
%
%      FIGURE_HIDE('Property','Value',...) creates a new FIGURE_HIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Figure_hide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Figure_hide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Figure_hide

% Last Modified by GUIDE v2.5 20-Nov-2023 14:08:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Figure_hide_OpeningFcn, ...
                   'gui_OutputFcn',  @Figure_hide_OutputFcn, ...
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


% --- Executes just before Figure_hide is made visible.
function Figure_hide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Figure_hide (see VARARGIN)

% Choose default command line output for Figure_hide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Figure_hide wait for user response (see UIRESUME)
% uiwait(handles.Figure_hide);
clc;
handles.original=[];handles.watermark1=[];
handles.hide=[];handles.watermark2=[];
handles.wavetype=1;
axes(handles.axes_original);title('原图像');
axes(handles.axes_watermark1);title('待隐藏图像');
axes(handles.axes_hide);title('隐藏后图像');
axes(handles.axes_watermark2);title('隐藏图像提取');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Figure_hide_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbutton_watermark1.
function pushbutton_watermark1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_watermark1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取待隐藏图像按钮
try
    [filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
    if(isequal(filename,0) || isequal(pathname,0))
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
        handles.watermark1=imread([pathname,filename]);
        percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
        axes(handles.axes_watermark1);
        imshow(handles.watermark1);
        title('待隐藏图像');
        percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
        close(h_waitbar);
        check=(handles.watermark1~=0)&(handles.watermark1~=255); %提取图像中非黑白的像素点
        if(numel(size(handles.watermark1))==3) %判断是否为彩图
            warndlg('目前待隐藏图像仅支持黑白图像。如果你坚持要用其他图像......你可以试试。','提示')
        elseif(any(any(check))) %判断是否为黑白图
            warndlg('目前待隐藏图像仅支持黑白图像。如果你坚持要用其他图像......你可以试试。','提示')
        end
    end
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'读取图像出错');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_hide.
function pushbutton_hide_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_hide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 隐藏图像按钮（核心代码）
try
    handles.wavetype=get(handles.popupmenu_wavetype,'value');
    percentage=0;h_waitbar=waitbar(percentage,'处理中......0%','name','请稍候'); 
    original_img=double(handles.original);
    hide_img=double(handles.watermark1);
    nh=size(hide_img,2);
    switch handles.wavetype %进行小波变换（单级）
        case 1
            [ca,ch,cv,cd]=dwt2(original_img,'haar');
        case 2
            [ca,ch,cv,cd]=dwt2(original_img,'db4');
        case 3
            [ca,ch,cv,cd]=dwt2(original_img,'sym4');
    end
    percentage=0.3;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    ca1=ca;
    value=1;
    for i=1:nh
        for j=1:nh
            if(hide_img(i,j)==0) %隐藏图像中纯黑的像素点
                ca1(i,j)=ca(i,j)+value; %对被隐藏图像对应位置的像素点进行细微的修改
            end
        end
    end
    percentage=0.6;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    switch handles.wavetype
        case 1
            result_img=idwt2(ca1,ch,cv,cd,'haar');
        case 2
            result_img=idwt2(ca1,ch,cv,cd,'db4');
        case 3
            result_img=idwt2(ca1,ch,cv,cd,'sym4');
    end
    handles.hide=uint8(round(result_img));
    axes(handles.axes_hide);
    imshow(handles.hide,[]);
    psnr=PSNR(handles.original,handles.hide); %计算PSNR，评价处理后结果
    title(['隐藏后图像,PSNR=',num2str(psnr(1)),'dB']);
    percentage=1;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    close(h_waitbar);
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'处理图像出错');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_watermark2.
function pushbutton_watermark2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_watermark2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 隐藏图像提取按钮（核心代码）
% 为隐藏的逆运算，算法类似
try
    handles.wavetype=get(handles.popupmenu_wavetype,'value');
    percentage=0;h_waitbar=waitbar(percentage,'处理中......0%','name','请稍候'); 
    hide_img=double(handles.hide);
    mw=size(handles.watermark1,1);
    nw=size(handles.watermark1,2);
    switch handles.wavetype
        case 1
            [ca1,~,~,~]=dwt2(hide_img,'haar'); %ca1,ch1,cv1,cd1
        case 2
            [ca1,~,~,~]=dwt2(hide_img,'db4');
        case 3
            [ca1,~,~,~]=dwt2(hide_img,'sym4');
    end
    percentage=0.3;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    original_img=double(handles.original);
    switch handles.wavetype
        case 1
            [ca2,~,~,~]=dwt2(original_img,'haar');
        case 2
            [ca2,~,~,~]=dwt2(original_img,'db4');
        case 3
            [ca2,~,~,~]=dwt2(original_img,'sym4');
    end
    percentage=0.6;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    difference=ca1-ca2; %两者相减，一样为0，不一样则不为0
    watermark=ones(mw); %生成纯白图片
    for i=1:mw
        for j=1:nw
            if(difference(i,j)~=0) %不一样说明改过，对应隐藏图像中的纯黑像素点
                watermark(i,j)=0; %对应位置像素点还原成纯黑
            end
        end
    end
    handles.watermark2=uint8(watermark);
    axes(handles.axes_watermark2);
    imshow(handles.watermark2,[]);
    nc=NC(handles.watermark1,handles.watermark2); %计算NC，评价处理后结果
    title(['隐藏图像提取,NC=',num2str(nc)]);
    percentage=1;waitbar(percentage,h_waitbar,['处理中......',num2str(percentage*100),'%']);
    close(h_waitbar);
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'处理图像出错');
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


% --- Executes on button press in pushbutton_save1.
function pushbutton_save1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存隐藏后图像按钮
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
        imwrite(mat2gray(handles.hide),[pathname,filename]);  
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
% 保存提取图像按钮
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'保存图像','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'保存中......0%','name','请稍候');
        imwrite(mat2gray(handles.watermark2),[pathname,filename]);  
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
