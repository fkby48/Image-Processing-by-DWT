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
axes(handles.axes_original);title('ԭͼ��');
axes(handles.axes_preprocess);title('Ԥ�����ͼ��');
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
% ��ȡԭͼ��ť
try
    [filename,pathname]=uigetfile({'*.png';'*.jpg';'*.bmp'},'��ȡͼ��');
    if(isequal(filename,0) || isequal(pathname,0))
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'��ȡ��......0%','name','���Ժ�'); 
        handles.original=imread([pathname,filename]);
        percentage=0.5;waitbar(percentage,h_waitbar,['��ȡ��......',num2str(percentage*100),'%']);
        axes(handles.axes_original);
        imshow(handles.original);
        title('ԭͼ��');
        percentage=1;waitbar(percentage,h_waitbar,['��ȡ��......',num2str(percentage*100),'%']);
        close(h_waitbar);
    end
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['���������Ϣ��Ȼ�����ԡ�',char(10),'������Ϣ��',ex.message],'��ȡͼ�����');
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_preprocess_type.
function popupmenu_preprocess_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_preprocess_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_preprocess_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_preprocess_type
% �ı�������ѡ��ʱ����
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
% �ı�������ѡ��ʱ����
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_preprocess.
function pushbutton_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ͼ��Ԥ����ť�����Ĵ��룩
try
    handles.preprocess_type=get(handles.popupmenu_preprocess_type,'value');
    percentage=0;h_waitbar=waitbar(percentage,'������......0%','name','���Ժ�'); 
    switch handles.preprocess_type
        case 1 %ͼ��ת�Ҷ�
            if(numel(size(handles.original))==3) %�ж��ǲ�ͼ���ǻҶ�ͼ��3Ϊ��ͼ
                handles.preprocess=rgb2gray(handles.original);
            else
                handles.preprocess=handles.original;
            end
        case 2 %ͼ�����
            handles.noise_mean=str2double(get(handles.edit_noise_mean,'string'));
            handles.noise_var=str2double(get(handles.edit_noise_var,'string'));
            handles.preprocess=imnoise(handles.original, 'gaussian', handles.noise_mean, handles.noise_var);
        case 3 %�ҶȲ�����
            handles.noise_mean=str2double(get(handles.edit_noise_mean,'string'));
            handles.noise_var=str2double(get(handles.edit_noise_var,'string'));
            if(numel(size(handles.original))==3) %�ж��ǲ�ͼ���ǻҶ�ͼ
                temp=rgb2gray(handles.original);
            else
                temp=handles.original;
            end
            handles.preprocess=imnoise(temp, 'gaussian', handles.noise_mean, handles.noise_var);
    end
    percentage=0.8;waitbar(percentage,h_waitbar,['������......',num2str(percentage*100),'%']);
    axes(handles.axes_preprocess);
    imshow(handles.preprocess,[]);
    title('Ԥ�����ͼ��');
    percentage=1;waitbar(percentage,h_waitbar,['������......',num2str(percentage*100),'%']);
    close(h_waitbar);
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['���������Ϣ��Ȼ�����ԡ�',char(10),'������Ϣ��',ex.message],'����ͼ�����');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ����Ԥ����ͼ��ť
try
    [filename,pathname]=uiputfile({'*.png';'*.jpg';'*.bmp'},'����ͼ��','saved_figure.png');
    if isequal(filename,0) || isequal(pathname,0)
        % do nothing
    else
        percentage=0;h_waitbar=waitbar(percentage,'������......0%','name','���Ժ�');
        imwrite(mat2gray(handles.preprocess),[pathname,filename]);  
        percentage=1;waitbar(percentage,h_waitbar,['������......',num2str(percentage*100),'%']);
        close(h_waitbar);
    end
catch ex
    if(exist('h_waitbar','var'))
        close(h_waitbar);
    end
    errordlg(['���������Ϣ��Ȼ�����ԡ�',char(10),'������Ϣ��',ex.message],'����ͼ�����');
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
