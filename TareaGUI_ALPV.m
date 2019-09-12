function varargout = pruebasTareaAL(varargin)
% PRUEBASTAREAAL MATLAB code for pruebasTareaAL.fig
%      PRUEBASTAREAAL, by itself, creates a new PRUEBASTAREAAL or raises the existing
%      singleton*.
%
%      H = PRUEBASTAREAAL returns the handle to a new PRUEBASTAREAAL or the handle to
%      the existing singleton*.
%
%      PRUEBASTAREAAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRUEBASTAREAAL.M with the given input arguments.
%
%      PRUEBASTAREAAL('Property','Value',...) creates a new PRUEBASTAREAAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pruebasTareaAL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pruebasTareaAL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pruebasTareaAL

% Last Modified by GUIDE v2.5 11-Sep-2019 22:05:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pruebasTareaAL_OpeningFcn, ...
                   'gui_OutputFcn',  @pruebasTareaAL_OutputFcn, ...
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


% --- Executes just before pruebasTareaAL is made visible.
function pruebasTareaAL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pruebasTareaAL (see VARARGIN)

% Choose default command line output for pruebasTareaAL
handles.output = hObject;

%data = struct('val',0,'diffMax',1);
data.nombreArchivo = input('nombre del archivo (tiene que estar en el path): ');
datos=load(data.nombreArchivo);
data.datos = datos;
set(handles.PCA,'UserData',data);
set(handles.tSNE,'UserData',data);
% Update handles structure
guidata(hObject, handles);

figure(1),clf
subplot(211)
imagesc(data.datos.Spikes)
xlabel('Cells'), ylabel('Vectors(t)')

% UIWAIT makes pruebasTareaAL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pruebasTareaAL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PCA.
function PCA_Callback(hObject, eventdata, handles)
% hObject    handle to PCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'UserData');

Spikes = data.datos.Spikes;
[~,dimensiones] = pca(Spikes'); % metodo 1 de reduccion de dims

figure(1)

subplot(212)
plot3(dimensiones(:,1),dimensiones(:,2),dimensiones(:,3),'o')
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')

data.dimensiones = dimensiones;
set(handles.Kmeans,'UserData',data);
set(handles.GMM,'UserData',data);
% Update handles structure
guidata(hObject, handles);
title('PCA')

% --- Executes on button press in Kmeans.
function Kmeans_Callback(hObject, eventdata, handles)
% hObject    handle to Kmeans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'UserData');

x= data.dimensiones(:,1);
y= data.dimensiones(:,2);
z= data.dimensiones(:,3);

nGrupos = input('Cuantos clusters quieres? ');
idx = kmeans(data.dimensiones(:,1:3),nGrupos); % metodo 1 de clustering (kMeans)

figure(1)
subplot(212)
scatter3(x, y, z, 20, idx)
xlabel('C1'), ylabel('C2'), zlabel('C3')
% Update handles structure
guidata(hObject, handles);
title ('K-means')
%colormap([0 1 0;0 0 1;1 0 0;.8 .8 0])




% --- Executes on button press in tSNE.
function tSNE_Callback(hObject, eventdata, handles)
% hObject    handle to tSNE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(hObject,'UserData');
Spikes = data.datos.Spikes;
dimensiones = tsne(Spikes'); % metodo 2 de reduccion de dims
data.dimensiones = dimensiones;

figure(1)
subplot(212)
gscatter(dimensiones(:,1),dimensiones(:,2))
xlabel('PC1'), ylabel('PC2')
% Update handles structure
guidata(hObject, handles);

set(handles.Kmeans,'UserData',data);
set(handles.GMM,'UserData',data);
title('t-SNE')


% --- Executes on button press in GMM.
function GMM_Callback(hObject, eventdata, handles)
% hObject    handle to GMM (see GCBO)
% eventdata  reserved - to be defined in a future version  of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'UserData');

x= data.dimensiones(:,1);
y= data.dimensiones(:,2);
z= data.dimensiones(:,3);

nGrupos = input('Cuantos clusters quieres? ');
gm = fitgmdist([x y z],nGrupos);
idx = cluster(gm,[x y z]); % metodo 2 de clustering que es GMM

figure(1)
subplot(212)
scatter3(x, y, z, 20, idx)
xlabel('C1'), ylabel('C2'), zlabel('C3')
% Update handles structure
guidata(hObject, handles);
title('GMM')
