function varargout = Figure_denoise(varargin)
% FIGURE_DENOISE MATLAB code for Figure_denoise.fig
%      FIGURE_DENOISE, by itself, creates a new FIGURE_DENOISE or raises the existing
%      singleton*.
%
%      H = FIGURE_DENOISE returns the handle to a new FIGURE_DENOISE or the handle to
%      the existing singleton*.
%
%      FIGURE_DENOISE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_DENOISE.M with the given input arguments.
%
%      FIGURE_DENOISE('Property','Value',...) creates a new FIGURE_DENOISE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Figure_denoise_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Figure_denoise_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Figure_denoise

% Last Modified by GUIDE v2.5 19-Nov-2023 21:18:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Figure_denoise_OpeningFcn, ...
                   'gui_OutputFcn',  @Figure_denoise_OutputFcn, ...
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


% --- Executes just before Figure_denoise is made visible.
function Figure_denoise_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Figure_denoise (see VARARGIN)

% Choose default command line output for Figure_denoise
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Figure_denoise wait for user response (see UIRESUME)
% uiwait(handles.Figure_denoise);
clc;
handles.compare=[];
handles.noise=[];
handles.denoise=[];
handles.wavetype=1;handles.n=5;handles.valuetype=1;handles.threshold=-1;
axes(handles.axes_compare);title('理想结果对比');
axes(handles.axes_noise);title('加噪图像');
axes(handles.axes_denoise);title('降噪图像');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Figure_denoise_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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

% --- Executes on button press in pushbutton_noise.
function pushbutton_noise_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'读取图像');
if(isequal(filename,0) || isequal(pathname,0))
    % do nothing
else
    percentage=0;h_waitbar=waitbar(percentage,'读取中......0%','name','请稍候'); 
    handles.noise=imread([pathname,filename]);
    percentage=0.5;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    axes(handles.axes_noise);
    imshow(handles.noise);
    title('加噪图像');
    percentage=1;waitbar(percentage,h_waitbar,['读取中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_denoise.
function pushbutton_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 图像降噪部分
handles.wavetype=get(handles.popupmenu_wavetype,'value');
handles.n=str2double(get(handles.edit_n,'string'));
handles.valuetype=get(handles.popupmenu_valuetype,'value');
handles.threshold=str2double(get(handles.edit_threshold,'string'));
percentage=0;h_waitbar=waitbar(percentage,'计算中......0%','name','请稍候');
switch handles.wavetype
    case 1
        [C,S]=wavedec2(handles.noise,handles.n,'haar');
        percentage=0.4;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
        if handles.valuetype==1
            if handles.threshold==-1
                [threshold,~]=ddencmp('den','wv',handles.noise); 
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'s',handles.threshold);
            else
                C=wthresh(C,'s',handles.threshold);
            end
        else
            if handles.threshold==-1
                [threshold,~,~]=ddencmp('den','wv',handles.noise);
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'h',handles.threshold);
            else
                C=wthresh(C,'h',handles.threshold);
            end
        end
        handles.denoise=waverec2(C,S,'haar');
    case 2
        [C,S]=wavedec2(handles.noise,handles.n,'db4');
        percentage=0.4;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
        if handles.valuetype==1
            if handles.threshold==-1
                [threshold,~,~]=ddencmp('den','wv',handles.noise);
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'s',handles.threshold);
            else
                C=wthresh(C,'s',handles.threshold);
            end
        else
            if handles.threshold==-1
                [threshold,~,~]=ddencmp('den','wv',handles.noise);
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'h',handles.threshold);
            else
                C=wthresh(C,'h',handles.threshold);
            end
        end
        handles.denoise=waverec2(C,S,'db4');
    case 3
        [C,S]=wavedec2(handles.noise,handles.n,'sym4');
        percentage=0.4;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
        if handles.valuetype==1
            if handles.threshold==-1
                [threshold,~,~]=ddencmp('den','wv',handles.noise);
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'s',handles.threshold);
            else
                C=wthresh(C,'s',handles.threshold);
            end
        else
            if handles.threshold==-1
                [threshold,~,~]=ddencmp('den','wv',handles.noise);
                handles.threshold=threshold;
                set(handles.edit_threshold,'string',num2str(handles.threshold));
                C=wthresh(C,'h',handles.threshold);
            else
                C=wthresh(C,'h',handles.threshold);
            end
        end
        handles.denoise=waverec2(C,S,'sym4');
end
percentage=0.8;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
axes(handles.axes_denoise);
imshow(handles.denoise,[]);
title('降噪图像');
percentage=1;waitbar(percentage,h_waitbar,['计算中......',num2str(percentage*100),'%']);
close(h_waitbar);
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
    imwrite(mat2gray(handles.denoise),[pathname,filename]);  
    percentage=1;waitbar(percentage,h_waitbar,['保存中......',num2str(percentage*100),'%']);
    close(h_waitbar);
end
guidata(hObject, handles);

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


% --- Executes on selection change in popupmenu_valuetype.
function popupmenu_valuetype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_valuetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_valuetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_valuetype


% --- Executes during object creation, after setting all properties.
function popupmenu_valuetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_valuetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
