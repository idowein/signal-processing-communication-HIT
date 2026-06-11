function SimulParam=SimulConfig(handles)

SimulParam.BER_mode=get(handles.BER_mode,'value');
SimulParam.Image_mode=get(handles.Image_mode,'value');
SimulParam.pdf_display=get(handles.pdf_display,'value');
SimulParam.error_display=get(handles.error_display,'value');
SimulParam.BPSK=get(handles.BPSK,'value');
SimulParam.QAM4=get(handles.QAM4,'value');
SimulParam.QAM16=get(handles.QAM16,'value');


if SimulParam.BER_mode==1
    SimulParam.mode_Type=1;
else
     SimulParam.mode_Type=2;
end

if SimulParam.pdf_display==1
    SimulParam.display_mode=1;
else
     SimulParam.display_mode=2;
end

if SimulParam.BPSK==1
    SimulParam.modulation_Type=1;
elseif SimulParam.QAM4==1
    SimulParam.modulation_Type=2;
elseif SimulParam.QAM16==1
    SimulParam.modulation_Type=3;
end



SimulParam.NB_symbols=str2num(get(handles.NB_symbols,'string')); % NB of symbols to be sent
SimulParam.BER_target=str2num(get(handles.BER_target,'string')); %BER target  
SimulParam.SNRb_target=str2num(get(handles.SNRb_target,'string')); % [dB]
