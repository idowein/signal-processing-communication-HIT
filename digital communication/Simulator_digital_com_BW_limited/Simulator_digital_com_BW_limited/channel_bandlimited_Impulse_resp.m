%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This program  calculates theimpulse resposne of the digital
%%% transmission system 
%%% 
%%% Author : Dr David Dahan
%%% Date : 07/04/2015

function X=channel_bandlimited_Impulse_resp(SimulParam)



Nb_Trial=1; %% number of trails
Nbit=100; %%% number of bit  to be send  at each trial
% 
% Rs=SimulParam.BitRate*1e6; %%bit Rate
% Tsymb=1/Rs;%% symbol time slot
% 


Rb=SimulParam.BitRate*1e6;%100*1e6; %%bit Rate
if SimulParam.flag_mod==1
Rs=Rb/2; % symbol rate
else
  Rs=Rb;  
end   
Tsymb=1/Rs;%% symbol time slot


Nsample=20; %Number of samples per symbol
dt=Tsymb/(Nsample);  %% time resolution
Ts=0:dt:Tsymb ;%% definition of the time vector  
V0=1/sqrt(Nsample); %% signal peak voltage

SNRb_dB=SimulParam.SNRb_val;%35;%0:12 %%SNR per bit in dB
SNRb=10.^(SNRb_dB/10); %%SNR per bit 

%% Bit & symbol generation

I=zeros(1,Nbit);%;
I(26)=1;



%%%32 samples per symbol


e=upsample(I,Nsample);%% insert 31 zeros between each symbol



%% basic pulse shape

Ts=-25*Tsymb:dt:25*Tsymb; %%the pulse shape is define between in the time segment -6T to +6T
ng=length(Ts);

if SimulParam.modulation_Type==1  %%%NRZ
%%pulse definition for rectangular pulse shape
g=zeros(1,ng);
ind1=find(abs(Ts+Tsymb/2)==min(abs(Ts+Tsymb/2)));
ind2=find(abs(Ts-Tsymb/2)==min(abs(Ts-Tsymb/2)));
g(ind1(1):ind2(1)-1)=V0 ;
% %
else
 g=srrc(SimulParam.beta,Ts,1/Rs,V0); %rcosdesign(SimulParam.beta, 30, 20,'sqrt');
end




%% BPSK generation
s = conv(g,e);
n=length(s);
s=s(fix(ng/2):n-fix(ng/2)); 
n=length(s);

%%time vector definition for the BPSK signal
t=0:dt:(n-1)*dt;
t=t-25*Nsample*dt;

%%frequency vector definition for BPSK signal
Fmax=1/dt;
df=1/((n-1)*dt);
f=-Fmax/2:df:Fmax/2;




%% channel transfer function

%%%for  cut off frequency of 1000 MHz, the channel acts as an all pass filter 

Fc=SimulParam.BW*1e6 ;%%channel cutoff frequency

ind1=find(abs(f+Fc)==min(abs(f+Fc)));
ind2=find(abs(f-Fc)==min(abs(f-Fc)));

C1=zeros(1,n);
C1(ind1:ind2)=1;


if SimulParam.Channel_Type==1 % ideal channel
    
 C=C1;
 
elseif SimulParam.Channel_Type==2 % non ideal channel 1
%      a1=0*0.25;
%     a2=0.5;
%     a3=0.15;
%     T1=0.5*Tsymb;
%     T2=1.2*Tsymb;
%     T3=-2.5*Tsymb;
    
%    a1=0*0.45;
%     a2=-0.4;%0.55;
%     a3=0.3;%-0*0.15;
%     T1=-0.45*Tsymb;
%     T2=-1.8*Tsymb;
%     T3=+2.5*Tsymb;
%     
%     
%     
%     a1=0.75;
%     a2=0.3;%0.55;
%     a3=0.2;%-0*0.15;
%     T1=-0.85*Tsymb;
%     T2=-1.8*Tsymb;
%     T3=+2.5*Tsymb;
    
    
    T0=8e-11;
    a1=0.75;
    a2=0.3;%0.55;
    a3=0.2;%-0*0.15;
    T1=-0.85*T0;
    T2=-1.8*T0;
    T3=+2.5*T0;
    
    
C=C1.*(1+a1*exp(1j*2*pi*f*T1)+a2*exp(1j*2*pi*f*T2)+a3*exp(1j*2*pi*f*T3)); 

else %  non ideal channel 2
    
%     a1=-0.90;
%     a2=0;
%     a3=0;
%     T1=-0.5*Tsymb;
%     T2=1.2*Tsymb;
%     T3=-2.5*Tsymb;
    
%     T0=6.6667e-10
%      a1=0.5;
%     a2=-0.3;
%     a3=1.0;%1.05;
%     T1=-1.2*T0;
%     T2=-1.5*T0;
%     T3=-2.5*T0;
    
    
      T0=350e-12;%330e-12;%0.5*6.6667e-10;
     a1=-0.15;%-0.6;
    a3=0.79;%-0.78;%-0.3;
    a2=0*0.15;%1.0;%1.05;
    T1=0.95*T0;%-1.2*T0;
    T3=-4.1*T0;%-1.5*T0;
    T2=-2.5*T0;
     T4=-0.7*T0;
% %     
%     a1=-0.15;
%     a2=-0*0.3;
%     a3=-0.80;
%     T1=-0.5*Tsymb;
%     T2=-1.5*Tsymb;
%     T3=-3.5*Tsymb;
    
%     
%     T0=4e-10;  
%     a1=-0.2;%0.2;
%     a2=0.2;
%     a3=0.15;%-0.80;
%     T1=0.9*T0;%-0.5*T0;
%     T2=1.1*T0;
%     T3=-2.5*T0;%-3.5*T0;
    
    
C=C1.*(1+a1*exp(1j*2*pi*f*T1)+a2*exp(1j*2*pi*f*T2)+a3*exp(1j*2*pi*f*T3))./(1-0.2*exp(1j*2*pi*f*T4)); 
      
    
    
end


%%% calculation of convolution of s(t) by c(t) in frequency domain

S=fftshift(fft(s));
S2=S.*C;
s2=real(ifft(ifftshift(S2)));



        
        r=s2; %%signal at the receiver

        
        %%%RX
        
        %%receiver filter
        y=conv(r,g);
        ny=length(y);
        if SimulParam.modulation_Type==1  %%%NRZ
            
        y2=y(ceil(ng/2):end);    
        else
            
        y2=y(ceil(ng/2)+1:end);%ny-ceil(ng/2)+1); %%keep y2 with length n
        end
        
        if SimulParam.Equalizer_flag %%% ZF equalizer
        
            E=SimulParam.C;
            E(abs(E)<1e-5)=0;
            e=upsample(E,Nsample);
            ne=length(e);
            y3=conv(y2,e);
            y4=y3(fix(SimulParam.NbTaps/2)*Nsample:end);
            
               
    elseif SimulParam.Equalizer_MMSE_flag %%%MMSE Equalizer
            
             N0=1/SNRb;
        
            hX=SimulParam.hX;
            dX=SimulParam.dX;
            
            RX=hX+0.5*N0*eye(length(hX));
            
            cTaps=inv(RX)*dX;
            cTaps(abs(cTaps)<1e-5)=0;
            e=upsample(cTaps,Nsample);
            ne=length(e);
            y3=conv(y2,e);
            y4=y3(fix(SimulParam.NbTaps/2)*Nsample:end);
            
            
        else
            
           y4=y2; 
        end
        
 
        
       X=interp1(t/Tsymb,y4(1:length(t)),[-15:15]);
       X1=interp1(t/Tsymb,y4(1:length(t)),[-15:70]); 
       if SimulParam.calculate_flag==0
           figure(1)
           subplot(211)
           plot(t/Tsymb,y4(1:length(t)))
           V=axis;
           hold on
           stem([-15:70],X1,'r');
           hold off
           
           if (SimulParam.Equalizer_flag==0) &&(SimulParam.Equalizer_MMSE_flag==0)
            axis([-15,15,-2,V(4)])
           elseif SimulParam.NbTaps<75
           axis([-15,SimulParam.NbTaps,-2,V(4)])
           
           else
             axis([-15,70,-2,V(4)])   
           end
           xlabel('t/Tb')
           ylabel('system impulse response')
           grid on
           legend('Impulse response before sampler','Impulse response after sampler','Location','Best')
           
           Y4f=fftshift(fft(y4(1:length(t))));
           subplot(212)
           plot(f*1e-6,100*(abs(Y4f)/(length(f))))
           V=axis;
%            
%            if Rs<1500e6
%                axis([-2*Rs*1e-6,2*Rs*1e-6,V(3),V(4)])
%            else
               axis([-3000,3000,V(3),V(4)])
           %end
           xlabel('Frequency [MHz]')
           ylabel('Amplitude ')
           title('system  transfert response')
           grid on
           
       end