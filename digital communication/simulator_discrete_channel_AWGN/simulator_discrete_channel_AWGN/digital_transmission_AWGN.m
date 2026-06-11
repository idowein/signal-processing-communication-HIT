function varargout = digital_transmission_AWGN(varargin)
% DIGITAL_TRANSMISSION_AWGN MATLAB code for digital_transmission_AWGN.fig
%      DIGITAL_TRANSMISSION_AWGN, by itself, creates a new DIGITAL_TRANSMISSION_AWGN or raises the existing
%      singleton*.
%
%      H = DIGITAL_TRANSMISSION_AWGN returns the handle to a new DIGITAL_TRANSMISSION_AWGN or the handle to
%      the existing singleton*.
%
%      DIGITAL_TRANSMISSION_AWGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGITAL_TRANSMISSION_AWGN.M with the given input arguments.
%
%      DIGITAL_TRANSMISSION_AWGN('Property','Value',...) creates a new DIGITAL_TRANSMISSION_AWGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digital_transmission_AWGN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digital_transmission_AWGN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help digital_transmission_AWGN

% Last Modified by GUIDE v2.5 28-Mar-2015 18:44:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @digital_transmission_AWGN_OpeningFcn, ...
                   'gui_OutputFcn',  @digital_transmission_AWGN_OutputFcn, ...
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


% --- Executes just before digital_transmission_AWGN is made visible.
function digital_transmission_AWGN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digital_transmission_AWGN (see VARARGIN)

% Choose default command line output for digital_transmission_AWGN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digital_transmission_AWGN wait for user response (see UIRESUME)
% uiwait(handles.figure1);
A = imread('HIT.jpg');
image(A);
axis('off')

% --- Outputs from this function are returned to the command line.
function varargout = digital_transmission_AWGN_OutputFcn(hObject, eventdata, handles) 
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

SimulParam=SimulConfig(handles);






switch (SimulParam.mode_Type)
    
    
    case 1 % BER vs SNRb mode
        
        Nsymb=SimulParam.NB_symbols;
        %end
        BER_target=SimulParam.BER_target;
        
        switch(SimulParam.modulation_Type)
            
            case 1
                
                [BER,BER_analytic,Gammab]=SER_BER_BPSK(Nsymb,BER_target,SimulParam.display_mode);
            case 2
                
                [BER,BER_analytic,Gammab]=SER_BER_4QAM(Nsymb,BER_target,SimulParam.display_mode);
            case 3
                
                [BER,BER_analytic,Gammab]=SER_BER_16QAM(Nsymb,BER_target,SimulParam.display_mode);
                
            otherwise
                disp(' you did not enter the right number (1,2 or 3)to select the modulation type')
        end
        
        
        
        
    case 2 %%% Sending image mode
        
        filename = 'yarkon_park.jpg';%'earth-full-view.jpg';
        
        %-- Convert image to bits -------------------------------------------------%
        
        rgb_img = double(imread(filename));
        
               
%         %%convert into gray scale
%         I = .2989*rgb_img(:,:,1)...
%             +.5870*rgb_img(:,:,2)...
%             +.1140*rgb_img(:,:,3);
%         
%         
%         
%         I2=uint8(I);
%         [rows,cols]=size(I2);
%         figure(1)
%         subplot(121)
%         image(uint8(I2));
%         colormap(gray(256));
%         axis off
%         title('Original image')
%         clear bits;%imshow
%         for k=1:8
%             bits(:,k)=bitget(I2(:),k);
%         end;


        I2(:,:,1)=uint8(rgb_img(:,:,1));
        I2(:,:,2)=uint8(rgb_img(:,:,2));
        I2(:,:,3)=uint8(rgb_img(:,:,3));
        
        
       
        figure(1)
        subplot(121)
        image(I2);
        axis off
        title('Original image')
        clear bits;%imshow
        
        I21=I2(:,:,1);
        I22=I2(:,:,2);
        I23=I2(:,:,3);
        [rows,cols]=size(I21);
        
        for k=1:8
            bits1(:,k)=bitget(I21(:),k);
            bits2(:,k)=bitget(I22(:),k);
            bits3(:,k)=bitget(I23(:),k);
        end;
        
        
        bits=[bits1(:);bits2(:);bits3(:)];
        
        n=length(bits);
        
        SNRb_target=SimulParam.SNRb_target;
        
        switch(SimulParam.modulation_Type)
            
            case 1
                M=2;
                bits_tx = [bits(:); zeros(log2(M) - rem(length(bits(:)),log2(M)),1)];
                [bits_rx,BER,BER_analytic]=SER_BER_BPSK2(bits_tx,SNRb_target);
            case 2
                M=4;
                bits_tx = [bits(:); zeros(log2(M) - rem(length(bits(:)),log2(M)),1)];
                [bits_rx,BER,BER_analytic]=SER_BER_4QAM2(bits_tx,SNRb_target);
            case 3
                M=16;
                bits_tx= [bits(:); zeros(log2(M) - rem(length(bits(:)),log2(M)),1)];
                [bits_rx,BER,BER_analytic]=SER_BER_16QAM2(bits_tx,SNRb_target);
                
            otherwise
                disp(' you did not enter the right number (1,2 or 3)to select the modulation type')
        end
        
        
                
        
        %%reconvert into image
%         
%         
%         Xr = reshape(reshape(single(bits_rx(1:rows*cols*8)),rows*cols,8)*(2.^(0:7).'),rows,cols);
%         
%         figure(1)
%         subplot(122)
%         image((Xr))
%         title('Recovered image after transmission')
%         axis off

        
        bitr1=bits_rx(1:n/3);
       bitr2=bits_rx(n/3+1:2*n/3);
        bitr3=bits_rx(2*n/3+1:n);
        
        %%reconvert into image
        Xr1 = reshape(reshape(single(bitr1(1:rows*cols*8)),rows*cols,8)*(2.^(0:7).'),rows,cols);
        Xr2 = reshape(reshape(single(bitr2(1:rows*cols*8)),rows*cols,8)*(2.^(0:7).'),rows,cols);
        Xr3 = reshape(reshape(single(bitr3(1:rows*cols*8)),rows*cols,8)*(2.^(0:7).'),rows,cols);
        
        Xr(:,:,1)=uint8(Xr1);
        Xr(:,:,2)=uint8(Xr2);
        Xr(:,:,3)=uint8(Xr3);
        
        figure(1)
        subplot(122)
        image((Xr))
        title('Recovered image after transmission')
        axis off
         
end








function BER_target_Callback(hObject, eventdata, handles)
% hObject    handle to BER_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BER_target as text
%        str2double(get(hObject,'String')) returns contents of BER_target as a double


% --- Executes during object creation, after setting all properties.
function BER_target_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BER_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NB_symbols_Callback(hObject, eventdata, handles)
% hObject    handle to NB_symbols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NB_symbols as text
%        str2double(get(hObject,'String')) returns contents of NB_symbols as a double


% --- Executes during object creation, after setting all properties.
function NB_symbols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NB_symbols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SNRb_target_Callback(hObject, eventdata, handles)
% hObject    handle to SNRb_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRb_target as text
%        str2double(get(hObject,'String')) returns contents of SNRb_target as a double


% --- Executes during object creation, after setting all properties.
function SNRb_target_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRb_target (see GCBO)
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
