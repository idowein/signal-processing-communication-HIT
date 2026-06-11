function varargout = digital_transmission_AWGN_bandlimited(varargin)
% DIGITAL_TRANSMISSION_AWGN_BANDLIMITED MATLAB code for digital_transmission_AWGN_bandlimited.fig
%      DIGITAL_TRANSMISSION_AWGN_BANDLIMITED, by itself, creates a new DIGITAL_TRANSMISSION_AWGN_BANDLIMITED or raises the existing
%      singleton*.
%
%      H = DIGITAL_TRANSMISSION_AWGN_BANDLIMITED returns the handle to a new DIGITAL_TRANSMISSION_AWGN_BANDLIMITED or the handle to
%      the existing singleton*.
%
%      DIGITAL_TRANSMISSION_AWGN_BANDLIMITED('CALLBACK',hObject,eventData,handles,...) calls the local
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help digital_transmission_AWGN_bandlimited
% Last Modified by GUIDE v3.1 25/05/2019
%Author : Dr. David Dahan

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @digital_transmission_AWGN_bandlimited_OpeningFcn, ...
                   'gui_OutputFcn',  @digital_transmission_AWGN_bandlimited_OutputFcn, ...
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


%      function named CALLBACK in DIGITAL_TRANSMISSION_AWGN_BANDLIMITED.M with the given input arguments.
%
%      DIGITAL_TRANSMISSION_AWGN_BANDLIMITED('Property','Value',...) creates a new DIGITAL_TRANSMISSION_AWGN_BANDLIMITED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digital_transmission_AWGN_bandlimited_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digital_transmission_AWGN_bandlimited_OpeningFcn via varargin.
%
% --- Executes just before digital_transmission_AWGN_bandlimited is made visible.
function digital_transmission_AWGN_bandlimited_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digital_transmission_AWGN_bandlimited (see VARARGIN)

% Choose default command line output for digital_transmission_AWGN_bandlimited
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digital_transmission_AWGN_bandlimited wait for user response (see UIRESUME)
% uiwait(handles.figure1);
A = imread('HIT.jpg');
image(A);
axis('off')

% --- Outputs from this function are returned to the command line.
function varargout = digital_transmission_AWGN_bandlimited_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimulParam


SimulParam=SimulConfig(handles);

if SimulParam.Equalizer_flag
    
    SimulParam0=SimulParam;
    
    SimulParam0.Equalizer_flag=0;
    SimulParam0.calculate_flag=1;
    X=channel_bandlimited_Impulse_resp(SimulParam0);
    XX=Matrix_convolution_filter(X,SimulParam0.NbTaps);
    q=zeros(SimulParam0.NbTaps,1);
    q(fix(SimulParam0.NbTaps/2+1))=1;
    C=XX^-1*q; %%% Tap coeffcients;
    C=C';
    C(abs(C)<1e-5)=0;%
    set(handles.C,'string',num2str(C));
    SimulParam=SimulConfig(handles);
    
elseif SimulParam.Equalizer_MMSE_flag
    SimulParam0=SimulParam;
    NbTaps=SimulParam0.NbTaps;
    SimulParam0.Equalizer_MMSE_flag=0;
    SimulParam0.calculate_flag=1;
    X=channel_bandlimited_Impulse_resp(SimulParam0);
    
    % mmse equalization
   hAutoCorr = xcorr(X,X); % channel autocorrellation vector
   
   % Channel covariance matrix
   if NbTaps>31
   hX = toeplitz([hAutoCorr([31:end]) zeros(1,NbTaps-31)], [ hAutoCorr([31:end]) zeros(1,NbTaps-31) ]);
   Nbpad=(NbTaps-31)/2;
   X1=[zeros(1,Nbpad),X,zeros(1,Nbpad)];
   dX=fliplr(X1)';
   else
    hX = toeplitz(hAutoCorr(31:NbTaps+30), hAutoCorr(31:NbTaps+30)); 
    dX=fliplr(X(16-fix(NbTaps/2):16+fix(NbTaps/2)))';
   end
    
   SimulParam.hX=hX;
   SimulParam.dX=dX;
    
    
    
    
end
    


if SimulParam.Transmission_mode==1
    
    
    %BER=bpsk_simulator_bandlimited(SimulParam);
    BER=PAM4_simulator_bandlimited(SimulParam);
    if SimulParam.SNRb_mode==2
        
        set(handles.BER,'String',num2str(BER,'%10.2e'));
    else
        
       set(handles.BER,'String',' '); 
    end
    
else %% channel impulse response mode
    SimulParam.calculate_flag=0;
    X=channel_bandlimited_Impulse_resp(SimulParam);
    save('Channel_response.mat','X')
    
end


function BW_Callback(hObject, eventdata, handles)
% hObject    handle to BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BW as text
%        str2double(get(hObject,'String')) returns contents of BW as a double


% --- Executes during object creation, after setting all properties.
function BW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Ideal.
function Ideal_Callback(hObject, eventdata, handles)
% hObject    handle to Ideal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ideal


% --- Executes on button press in Non_Ideal.
function Non_Ideal_Callback(hObject, eventdata, handles)
% hObject    handle to Non_Ideal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Non_Ideal



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Equalizer_flag.
function Equalizer_flag_Callback(hObject, eventdata, handles)
% hObject    handle to Equalizer_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Equalizer_flag

if get(hObject,'value')
    
    set(handles.MMSE_flag,'value',0);
    set(handles.C,'enable','on')
    set(handles.ClearTaps,'enable','on')
    set(handles.Calculate,'enable','on') 
    set(handles.NbTaps,'enable','on')
 else
     set(handles.C,'enable','off')
     set(handles.ClearTaps,'enable','off')
     set(handles.Calculate,'enable','off')
     set(handles.NbTaps,'enable','off')
end

% --- Executes on button press in Cm5.
function Cm5_Callback(hObject, eventdata, handles)
% hObject    handle to Cm5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Cm5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Cm4_Callback(hObject, eventdata, handles)
% hObject    handle to Cm4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cm4 as text
%        str2double(get(hObject,'String')) returns contents of Cm4 as a double


% --- Executes during object creation, after setting all properties.
function Cm4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cm3_Callback(hObject, eventdata, handles)
% hObject    handle to Cm3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cm3 as text
%        str2double(get(hObject,'String')) returns contents of Cm3 as a double


% --- Executes during object creation, after setting all properties.
function Cm3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cm2_Callback(hObject, eventdata, handles)
% hObject    handle to Cm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cm2 as text
%        str2double(get(hObject,'String')) returns contents of Cm2 as a double


% --- Executes during object creation, after setting all properties.
function Cm2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cm1_Callback(hObject, eventdata, handles)
% hObject    handle to Cm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cm1 as text
%        str2double(get(hObject,'String')) returns contents of Cm1 as a double


% --- Executes during object creation, after setting all properties.
function Cm1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C5_Callback(hObject, eventdata, handles)
% hObject    handle to C5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C5 as text
%        str2double(get(hObject,'String')) returns contents of C5 as a double


% --- Executes during object creation, after setting all properties.
function C5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C4_Callback(hObject, eventdata, handles)
% hObject    handle to C4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C4 as text
%        str2double(get(hObject,'String')) returns contents of C4 as a double


% --- Executes during object creation, after setting all properties.
function C4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C3_Callback(hObject, eventdata, handles)
% hObject    handle to C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C3 as text
%        str2double(get(hObject,'String')) returns contents of C3 as a double


% --- Executes during object creation, after setting all properties.
function C3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C2_Callback(hObject, eventdata, handles)
% hObject    handle to C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C2 as text
%        str2double(get(hObject,'String')) returns contents of C2 as a double


% --- Executes during object creation, after setting all properties.
function C2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C1_Callback(hObject, eventdata, handles)
% hObject    handle to C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C1 as text
%        str2double(get(hObject,'String')) returns contents of C1 as a double


% --- Executes during object creation, after setting all properties.
function C1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C_Callback(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C as text
%        str2double(get(hObject,'String')) returns contents of C as a double


% --- Executes during object creation, after setting all properties.
function C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel8.
function uipanel8_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel8 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% if get(handles.Tap_5,'value')
%   
%   set(handles.Cm5,'String','0') 
%   set(handles.Cm5,'Enable','off')  
%   set(handles.Cm4,'String','0') 
%   set(handles.Cm4,'Enable','off')
%   set(handles.Cm3,'String','0') 
%   set(handles.Cm3,'Enable','off')  
%   set(handles.C3,'String','0') 
%   set(handles.C3,'Enable','off')
%   set(handles.C4,'String','0') 
%   set(handles.C4,'Enable','off')
%   set(handles.C5,'String','0') 
%   set(handles.C5,'Enable','off')
%     
% end
% 
% 
% if get(handles.Tap_7,'value')
%   
%   set(handles.Cm5,'String','0') 
%   set(handles.Cm5,'Enable','off')  
%   set(handles.Cm4,'String','0') 
%   set(handles.Cm4,'Enable','off')
%   set(handles.Cm3,'String','0') 
%   set(handles.Cm3,'Enable','on')  
%   set(handles.C3,'String','0') 
%   set(handles.C3,'Enable','on')
%   set(handles.C4,'String','0') 
%   set(handles.C4,'Enable','off')
%   set(handles.C5,'String','0') 
%   set(handles.C5,'Enable','off')
%     
% end
% 
% 
% 
% if get(handles.Tap_9,'value')
%   
%   set(handles.Cm5,'String','0') 
%   set(handles.Cm5,'Enable','off')  
%   set(handles.Cm4,'String','0') 
%   set(handles.Cm4,'Enable','on')
%   set(handles.Cm3,'String','0') 
%   set(handles.Cm3,'Enable','on')  
%   set(handles.C3,'String','0') 
%   set(handles.C3,'Enable','on')
%   set(handles.C4,'String','0') 
%   set(handles.C4,'Enable','on')
%   set(handles.C5,'String','0') 
%   set(handles.C5,'Enable','off')
%     
% end
% 
% 
% 
% if get(handles.Tap_11,'value')
%   
%   set(handles.Cm5,'String','0') 
%   set(handles.Cm5,'Enable','on')  
%   set(handles.Cm4,'String','0') 
%   set(handles.Cm4,'Enable','on')
%   set(handles.Cm3,'String','0') 
%   set(handles.Cm3,'Enable','on')  
%   set(handles.C3,'String','0') 
%   set(handles.C3,'Enable','on')
%   set(handles.C4,'String','0') 
%   set(handles.C4,'Enable','on')
%   set(handles.C5,'String','0') 
%   set(handles.C5,'Enable','on')
%     
% end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearTaps.
function ClearTaps_Callback(hObject, eventdata, handles)
% hObject    handle to ClearTaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.C,'String','insert Taps coeffcients');



function SNRb_val_Callback(hObject, eventdata, handles)
% hObject    handle to SNRb_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRb_val as text
%        str2double(get(hObject,'String')) returns contents of SNRb_val as a double


% --- Executes during object creation, after setting all properties.
function SNRb_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRb_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BER_Callback(hObject, eventdata, handles)
% hObject    handle to BER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BER as text
%        str2double(get(hObject,'String')) returns contents of BER as a double


% --- Executes during object creation, after setting all properties.
function BER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbTaps_Callback(hObject, eventdata, handles)
% hObject    handle to NbTaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbTaps as text
%        str2double(get(hObject,'String')) returns contents of NbTaps as a double


% --- Executes during object creation, after setting all properties.
function NbTaps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbTaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global SimulParam
 SimulParam=SimulConfig(handles);
 SimulParam.Equalizer_flag=0;
 SimulParam.Equalizer_MMSE_flag=0;
 SimulParam.calculate_flag=1;
 
 X=channel_bandlimited_Impulse_resp(SimulParam);
 XX=Matrix_convolution_filter(X,SimulParam.NbTaps);
 
 SimulParam=SimulConfig(handles);
 NbTaps=SimulParam.NbTaps;
 if SimulParam.Equalizer_flag
 q=zeros( NbTaps,1);
 q(fix(NbTaps/2+1))=1;
 C=XX^-1*q; %%% Tap coeffcients;
 C=C';
 set(handles.C,'string',num2str(C));
 
 elseif SimulParam.Equalizer_MMSE_flag
     
 % mmse equalization
   hAutoCorr = xcorr(X,X); % channel autocorrellation vector
   
   % Channel covariance matrix
   if NbTaps>31
   hX = toeplitz([hAutoCorr([31:end]) zeros(1,NbTaps-31)], [ hAutoCorr([31:end]) zeros(1,NbTaps-31) ]);
   Nbpad=(NbTaps-31)/2;
   X1=[zeros(1,Nbpad),X,zeros(1,Nbpad)];
   dX=fliplr(X1)';
   else
    hX = toeplitz(hAutoCorr(31:NbTaps+30), hAutoCorr(31:NbTaps+30)); 
    dX=fliplr(X(16-fix(NbTaps/2):16+fix(NbTaps/2)))';
   end
    
   SNRb_dB=SimulParam.SNRb_val;%35;%0:12 %%SNR per bit in dB
   SNRb=10.^(SNRb_dB/10); %%SNR per bit 
   
   N0=1/SNRb;
   
   if SimulParam.flag_mod==1 %4-PAM
       
       sigI=5;
   else
       
       sigI=1;
   end
   RX=hX+0.5*N0*eye(length(hX))/sigI;
   
   C=inv(RX)*dX;
   C=C';
  set(handles.C,'string',num2str(C)); 
   
 end
 
 t=-fix(SimulParam.NbTaps/2):1/32:fix(SimulParam.NbTaps/2)+1-1/32;
 df=1/fix(SimulParam.NbTaps);
 fMax=32;
 
 if SimulParam.PAM4==1
 SR=SimulParam.BitRate/2;
 else
 SR=SimulParam.BitRate;    
 end
 
 f=(-fMax/2:df:fMax/2-df)*SR;%100;
 
 
 C2=upsample(C,32);
 
 figure(2)
 subplot(211)
 plot(-fix(SimulParam.NbTaps/2):1/32:fix(SimulParam.NbTaps/2)+1-1/32,C2)
  axis([-fix(SimulParam.NbTaps/2),fix(SimulParam.NbTaps/2),-1,1]);
 xlabel(' T/Ts')
 ylabel('e(t)')
 title('Equalizer Impulse response')
 
 Cf=fftshift(fft(C2));
 subplot(212)
 plot(f,((abs(Cf))))
 V=axis;
 axis([-1.5*SR,1.5*SR,V(3),V(4)]);
 xlabel('Frequency [MHz]')
 ylabel('Amplitude  ')
 title('Equalizer  transfert response')
 grid on
 


% --- Executes on button press in MMSE_flag.
function MMSE_flag_Callback(hObject, eventdata, handles)
% hObject    handle to MMSE_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MMSE_flag

if get(hObject,'value')
    
    set(handles.Equalizer_flag,'value',0);
    set(handles.C,'enable','on')
    set(handles.ClearTaps,'enable','on')
    set(handles.Calculate,'enable','on') 
    set(handles.NbTaps,'enable','on')
 else
     set(handles.C,'enable','off')
     set(handles.ClearTaps,'enable','off')
     set(handles.Calculate,'enable','off')
     set(handles.NbTaps,'enable','off')
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BitRate_Callback(hObject, eventdata, handles)
% hObject    handle to BitRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BitRate as text
%        str2double(get(hObject,'String')) returns contents of BitRate as a double


% --- Executes during object creation, after setting all properties.
function BitRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BitRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
