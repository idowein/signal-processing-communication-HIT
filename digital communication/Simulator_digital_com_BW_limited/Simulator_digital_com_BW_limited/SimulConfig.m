function SimulParam=SimulConfig(handles)

SimulParam.Transmission_mode=get(handles.Transmission_mode,'value');
SimulParam.Impulse_mode=get(handles.Impulse_mode,'value');
SimulParam.NRZ=get(handles.NRZ,'value');
SimulParam.SSRC=get(handles.SRRC,'value');
SimulParam.BitRate=str2num(get(handles.BitRate,'string'));
SimulParam.PAM2=get(handles.PAM2,'value');
SimulParam.PAM4=get(handles.PAM4,'value');


if SimulParam.Transmission_mode==1
    SimulParam.mode_Type=1;
else
     SimulParam.mode_Type=2;
end

if SimulParam.PAM4==1
    SimulParam.flag_mod=1;
else
    SimulParam.flag_mod=0;
end

if SimulParam.NRZ==1
    SimulParam.modulation_Type=1;
elseif SimulParam.SSRC==1
    SimulParam.modulation_Type=2;

end

if get(handles.Ideal,'value')
    
    SimulParam.Channel_Type=1; % ideal
elseif get(handles.Non_Ideal,'value')
    
    SimulParam.Channel_Type=2; % non-ideal channel 1
    
else
    
    SimulParam.Channel_Type=3; % non-ideal channel 2
end


SimulParam.BW=str2num(get(handles.BW,'string')); % NB of symbols to be sent
SimulParam.beta=str2num(get(handles.beta,'string')); % beta




if get(handles.SNRb_Range,'Value')

     SimulParam.SNRb_mode=1; % SNRb range  
else
     SimulParam.SNRb_mode=2; % SNRb single value 
    
end


SimulParam.SNRb_val=str2num(get(handles.SNRb_val,'string'));

% if get(handles.Tap_5,'value')
%     
%     SimulParam.NbTaps=5;
%     C(1)=str2num(get(handles.Cm2,'string'));
%     C(2)=str2num(get(handles.Cm1,'string'));
%     C(3)=str2num(get(handles.C0,'string'));
%     C(4)=str2num(get(handles.C1,'string'));
%     C(5)=str2num(get(handles.C2,'string'));
%     
% elseif get(handles.Tap_7,'value')
%     
%     SimulParam.NbTaps=7;
%     C(1)=str2num(get(handles.Cm3,'string'));
%     C(2)=str2num(get(handles.Cm2,'string'));
%     C(3)=str2num(get(handles.Cm1,'string'));
%     C(4)=str2num(get(handles.C0,'string'));
%     C(5)=str2num(get(handles.C1,'string'));
%     C(6)=str2num(get(handles.C2,'string'));
%     C(7)=str2num(get(handles.C3,'string'));
%     
% elseif get(handles.Tap_9,'value')
%     
%     SimulParam.NbTaps=9;
%     
%     C(1)=str2num(get(handles.Cm4,'string'));
%     C(2)=str2num(get(handles.Cm3,'string'));
%     C(3)=str2num(get(handles.Cm2,'string'));
%     C(4)=str2num(get(handles.Cm1,'string'));
%     C(5)=str2num(get(handles.C0,'string'));
%     C(6)=str2num(get(handles.C1,'string'));
%     C(7)=str2num(get(handles.C2,'string'));
%     C(8)=str2num(get(handles.C3,'string'));
%     C(9)=str2num(get(handles.C4,'string'));
%     
% elseif get(handles.Tap_11,'value')
%     
%     SimulParam.NbTaps=11;
%     
%     C(1)=str2num(get(handles.Cm5,'string'));
%     C(2)=str2num(get(handles.Cm4,'string'));
%     C(3)=str2num(get(handles.Cm3,'string'));
%     C(4)=str2num(get(handles.Cm2,'string'));
%     C(5)=str2num(get(handles.Cm1,'string'));
%     C(6)=str2num(get(handles.C0,'string'));
%     C(7)=str2num(get(handles.C1,'string'));
%     C(8)=str2num(get(handles.C2,'string'));
%     C(9)=str2num(get(handles.C3,'string'));
%     C(10)=str2num(get(handles.C4,'string'));
%     C(11)=str2num(get(handles.C5,'string'));
%     
% end
SimulParam.Equalizer_flag=get(handles.Equalizer_flag,'value');
SimulParam.Equalizer_MMSE_flag=get(handles.MMSE_flag,'value');
SimulParam.C=str2num(get(handles.C,'string'));
SimulParam.NbTaps=str2num(get(handles.NbTaps,'string'));
  if (rem(SimulParam.NbTaps,2)==0)
     error('The equalizer must have an odd number of taps ') 
%      
  end
    
