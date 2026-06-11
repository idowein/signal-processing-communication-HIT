%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This program  calculates the error probability for signal BPSK in AWGN
%%% channel without bandwidth limitation : C(f) =1 for all f
%%% In order to make the calculation  not time cosuming, instead of sending
%%% a large number of bits once, the total number of bits is breaken into Nb_Trails blocks
%%% of Nbits that are sent in the system independently
%%% The BER is calculated as following:  BER=1/Nbit*1/Nb_Trial*sum(Nberror per trial)
%%%
%%% Author : Dr David Dahan
%%% Date : 28/12/2011

function BER=PAM4_simulator_bandlimited(SimulParam)

Nb_Trial=2*25; %% number of trails
Nbit=2^12; %%% half number of bit  to be send  at each trial



Rb=SimulParam.BitRate*1e6;%100*1e6; %%bit Rate
if SimulParam.flag_mod==1
    Rs=Rb/2; % symbol rate
else
    Rs=Rb;
end
Tsymb=1/Rs;%% symbol time slot

Nsample=40; %Number of samples per symbol
dt=Tsymb/(Nsample);  %% time resolution
Ts=0:dt:Tsymb ;%% definition of the time vector
V0=1/sqrt(Nsample); %% signal peak voltage

if SimulParam.SNRb_mode==1
    
    if SimulParam.Channel_Type==3
        SNRb_dB=[20,2:15,16:2:20];
    else
        
        if  SimulParam.flag_mod==0
            SNRb_dB=[8,2:1:10]; %%SNR per bit in dB
        else
            SNRb_dB=[10,2:2:8,9:15]; %%SNR per bit in dB
        end
    end
else
    SNRb_dB=SimulParam.SNRb_val; %%SNR per bit in dB
end


SNRb=10.^(SNRb_dB/10); %%SNR per bit

%% Bit & symbol generation
%defaultStream = RandStream.getDefaultStream;
rand('seed',0)
% bits=rand(1,Nbit)>0.5;
%
% %%%BPSK symbol mapping :bit0 I=-1,bit1 I=+1
%
% ind_bit0=find(bits==0);
% ind_bit1=find(bits==1);
% I=double(bits);
% I(ind_bit0)=-1;
%
%
% %% Bit & symbol generation


if SimulParam.flag_mod==1 %4-PAM
    bits1=rand(1,Nbit)>0.5;
    bits2=rand(1,Nbit)>0.5;
    %%PAM4 symbol mapping : -3(00) -1 (01) 1 (11)  3 (10)
    
    ind=(bits1==0) & (bits2==0);
    I(ind)=-3;
    ind=(bits1==0) & (bits2==1);
    I(ind)=-1;
    ind=(bits1==1) & (bits2==1);
    I(ind)=1;
    ind=(bits1==1) & (bits2==0);
    I(ind)=3;
else %2-PAM
    
    bits=rand(1,Nbit)>0.5;
    
    I=2*bits-1;
    ind_bit0=find(bits==0);
    ind_bit1=find(bits==1);
    
    
end


%%%32 samples per symbol


e=upsample(I,Nsample);%% insert 31 zeros between each symbol



%% basic pulse shape

Ts=-25*Tsymb:dt:25*Tsymb; %%the pulse shape is define between in the time segment -25T to +25T
ng=length(Ts);

if SimulParam.modulation_Type==1  %%%NRZ
    %%pulse definition for rectangular pulse shape
    g=zeros(1,ng);
    ind1=find(abs(Ts+Tsymb/2)==min(abs(Ts+Tsymb/2)));
    ind2=find(abs(Ts-Tsymb/2)==min(abs(Ts-Tsymb/2)));
    g(ind1(1):ind2(1)-1)=V0 ;
    % %
else
    g=srrc(SimulParam.beta,Ts,1/Rs,V0);
    %  g=rcosdesign(SimulParam.beta, 30, 20,'sqrt');
end


%%% bit energy at TX
if SimulParam.flag_mod==1 %4-PAM
    Eb=2.5*trapz(Ts,g.^2);
    sigI=5;
else
    Eb=1*trapz(Ts,g.^2);
    sigI=1;
end



%% BPSK generation
s = conv(g,e);
n=length(s);
s=s(fix(ng/2):n-fix(ng/2));
n=length(s);

%%time vector definition for the BPSK signal
t=0:dt:(n-1)*dt;

%%frequency vector definition for BPSK signal
Fmax=1/dt;
df=1/((n-1)*dt);
f=-Fmax/2:df:Fmax/2;

figure(1)
subplot(211);
s0=s(100*Nsample+1:end-100*Nsample);
plot(t(1:length(s0))*1e6,s0)
xlabel('time [us]')
ylabel('Signal amplitude [V]')
if SimulParam.flag_mod==1
    title('PAM4 signal at the Transmitter')
else
    title('PAM2 signal at the Transmitter')
end
Tmax=40*Tsymb*1e6;
axis([0,Tmax,-0.75,0.75])
subplot(212)
E=EyePattern(s(2*Nsample+1:end-100*Nsample),Nsample,2,1); %%calculation of the signal eye diagram after the receiver filter
if SimulParam.modulation_Type==1
    plot(E);
else
    display_ED(E)
end
grid on
xlabel('Fractional Time sample over symbol period')
if SimulParam.flag_mod==1
    text=strcat('PAM4 signal  eye diagram at Transmitter');
else
    text=strcat('PAM2 signal  eye diagram at Transmitter');
end
title(text)

%%calculation of the PSD of s(t)
PSD=abs(fftshift(fft(s/n))).^2;
figure(2)
subplot(111)
plot(f*1e-9,10*log10(PSD))
axis([-10*Rs*1e-9,+10*Rs*1e-9,-100,-20]);
grid on

xlabel('Frequency [GHz]');
ylabel('Power spectral density [W/Hz]')
if SimulParam.flag_mod==1
    title('PAM4 signal at the Transmitter')
else
    title('PAM2 signal at the Transmitter')
end




%% channel transfer function

%%%for  cut off frequency of 1000 MHz, the channel acts as an all pass filter

Fc=SimulParam.BW*1e6; %%channel cutoff frequency

ind1=find(abs(f+Fc)==min(abs(f+Fc)));
ind2=find(abs(f-Fc)==min(abs(f-Fc)));

C1=zeros(1,n);
C1(ind1:ind2)=1;


if SimulParam.Channel_Type==1 % ideal channel
    
    C=C1;
    
elseif SimulParam.Channel_Type==2 % non ideal channel 1
    
    T0=8e-11;
    a1=0.75;
    a2=0.3;%0.55;
    a3=0.2;%-0*0.15;
    T1=-0.85*T0;
    T2=-1.8*T0
    T3=+2.5*T0;
    
    C=C1.*(1+a1*exp(1j*2*pi*f*T1)+a2*exp(1j*2*pi*f*T2)+a3*exp(1j*2*pi*f*T3));
    
else %  non ideal channel 2
    %
    %     a1=-1.3;
    %     a2=0.5;
    %     a3=0;
    %     T1=-1.1*Tsymb;
    %     T2=+1.8*Tsymb;
    %     T3=-2.5*Tsymb;
    %     T0=330e-12;%0.5*6.6667e-10;
    %     a1=0.5;
    %     a2=-0.3;
    %     a3=1.0;%1.05;
    %     T1=-1.2*T0;
    %     T2=-1.5*T0;
    %     T3=-2.5*T0;
    
    
    T0=800e-12;%330e-12;%0.5*6.6667e-10;
    %      a1=0*0.5;
    %     a2=-0.3;
    %     a3=1.6;%1.0;%1.05;
    
     T0=350e-12;%330e-12;%0.5*6.6667e-10;
     a1=-0.15;%-0.6;
    a3=0.79;%-0.78;%-0.3;
    a2=0*0.15;%1.0;%1.05;
    T1=0.95*T0;%-1.2*T0;
    T3=-4.1*T0;%-4.1*T0;%-1.5*T0;
    T2=-2.5*T0;
    T4=-0.7*T0;
    % %
    %     T0=4e-10;
    %     a1=-0.15;
    %     a2=-0*0.1;
    %     a3=-0.80;
    %     T1=-0.5*T0;
    %     T2=1.1*T0;
    %     T3=-3.5*T0;
    %
    %
    %     T0=4e-10;
    %     a1=0.2;
    %     a2=-0*0.2;
    %     a3=-0.8;%-0.80;
    %     T1=-0.5*T0;
    %     T2=1.1*T0;
    %     T3=-3.5*T0;
    
    %
    %      T0=4e-10;
    %     a1=-0.2;%0.2;
    %     a2=0.2;
    %     a3=0.15;%-0.80;
    %     T1=0.9*T0;%-0.5*T0;
    %     T2=1.1*T0;
    %     T3=-2.5*T0;%-3.5*T0;
    
    
    
    %C=C1.*(1+a1*exp(1j*2*pi*f*T1)+a2*exp(1j*2*pi*f*T2)+a3*exp(1j*2*pi*f*T3));

C=C1.*(1+a1*exp(1j*2*pi*f*T1)+a2*exp(1j*2*pi*f*T2)+a3*exp(1j*2*pi*f*T3))./(1-0.2*exp(1j*2*pi*f*T4)); 
    
    
end


%%% calculation of convolution of s(t) by c(t) in frequency domain

S=fftshift(fft(s));
S2=S.*C;
s2=ifft(ifftshift(S2));



%%%calculation of the energy bit after the channel filter  by sending a single symbol (before adding
%%%the noise)

g2=[zeros(1,1000),g,zeros(1,n-ng-1000)];
G2=fftshift(fft(g2));
G22=C.*G2;
g22=ifft(ifftshift(G22));

%Eb=trapz(t,g22.^2);%%energy after channel filter


%% BER calculation
Ps=mean(abs(s2).^2);


%N0=Eb./SNRb; %% noise PSD

N0=(Ps/dt)./(SNRb*Rb); % calulation of the nois PSD for a given SNRb


ykk=[];
ykk0=[];
ykk1=[];
for i=1:length(N0)
    ykk=[];
    ykk0=[];
    ykk1=[];
    randn('seed',i); %%use the same random seed  for a gicen snrb level
    for j=1:Nb_Trial
        
        N=sqrt(0.5*N0(i))*randn(1,n); %%generation of teh noise vector
        r=s2+N; %%signal at the receiver
        
        
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
            
            cTaps=SimulParam.C;
            cTaps(abs(cTaps)<1e-4)=0;
            e=upsample(cTaps,Nsample);
            ne=length(e);
            y3=conv(y2,e);
            y4=y3(fix(SimulParam.NbTaps/2)*Nsample:end);
            
        elseif SimulParam.Equalizer_MMSE_flag %%%MMSE Equalizer
            
            hX=SimulParam.hX;
            dX=SimulParam.dX;
            
            RX=hX+0.5*N0(i)*eye(length(hX))/sigI;
            
            cTaps=inv(RX)*dX;
            cTaps(abs(cTaps)<1e-4)=0;
            e=upsample(cTaps,Nsample);
            ne=length(e);
            y3=conv(y2,e);
            y4=y3(fix(SimulParam.NbTaps/2)*Nsample:end);
            
            
            
        else
            
            
            y4=y2;
        end
        
        
        %         if SimulParam.Channel_Type==1 % ideal channel
        %
        if SimulParam.SNRb_mode==1
            if j==1 && i~=1
                figure(3)
                subplot(211)
                sRX=y4(100*Nsample+1:end-100*Nsample);
                plot(t(1:length(sRX))*1e6,sRX)
                V=axis;
                xlabel('time [us]')
                ylabel('Signal amplitude [V]')
                if SimulParam.flag_mod
                    title(strcat('PAM4 signal at the Receiver for SNRb=',num2str(SNRb_dB(i)),'dB'))
                else
                    title(strcat('PAM2 signal at the Receiver for SNRb=',num2str(SNRb_dB(i)),'dB'))
                end
                axis([0,Tmax,V(3),V(4)])
                subplot(212)
                E=EyePattern(y4(100*Nsample+1:end-100*Nsample),Nsample,2,0); %%calculation of the signal eye diagram after the receiver filter
                %plot(E)
                display_ED(E)
                if SimulParam.flag_mod
                    
                    text=strcat('PAM-4 signal  eye diagram after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
                else
                    text=strcat('PAM-2 signal  eye diagram after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
                    
                end
                xlabel('Fractional Time sample over two symbol period')
                title(text)
            end
            
        else
            
            if j==1
                figure(3)
                subplot(211)
                sRX=y4(100*Nsample+1:end-200*Nsample);
                plot(t(1:length(sRX))*1e6,sRX)
                V=axis;
                xlabel('time [us]')
                ylabel('Signal amplitude [V]')
                if SimulParam.flag_mod
                    title('PAM4 signal at the Receiver')
                else
                    title('PAM2 signal at the Receiver')
                end
                axis([0,Tmax,V(3),V(4)])
                subplot(212)
                E=EyePattern(y4(100*Nsample+1:end-200*Nsample),Nsample,2,0); %%calculation of the signal eye diagram after the receiver filter
                %plot(E)
                display_ED(E)
                if SimulParam.flag_mod
                    
                    text=strcat('PAM-4 signal  eye diagram after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
                else
                    text=strcat('PAM-2 signal  eye diagram after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
                    
                end
                xlabel('Fractional Time sample over  two symbol period')
                title(text)
            end
            
            
        end
        
        
        %         else
        %
        %             if j==1
        %                 figure(3)
        %                 E=EyePattern(y4(1:end-15*Nsample),Nsample,1,Nsample/2); %%calculation of the signal eye diagram after the receiver filter
        %                 plot(E)
        %                 text=strcat('BPSK signal  eye diagram after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
        %                 title(text)
        %             end
        %         end
        
        
        if (i==1) && (j==1)
            
            for kk=1:Nsample-1
                
                t0=kk; %% sampling reference time
                
                yk=y4(t0:Nsample:n); %%%sampling of the detected signal
               
                if length(yk)>1024
                    
                    yk=y4(t0:Nsample:n-Nsample/2+t0);
                    
                    
                    %                     cTaps=SimulParam.C;
                    %                     y3=conv(yk1,cTaps);
                    %                     yk=y3(fix(SimulParam.NbTaps/2):end-fix(SimulParam.NbTaps/2)-1);
                    
                    
                end
                
                
                
                %%%decision
                if  SimulParam.flag_mod==0
                    received_bits=yk>0;
                    Nb_error0(kk)=sum(bits(100:end-100)~=received_bits(100:end-100));
                    
                    %% number of error in a given trail
                else
                    received_bits1=yk>0;
                    received_bits2=abs(yk)<2;
                    
                    Nb_error0(kk)=sum(bits1(100:end-100)~=received_bits1(100:end-100))+sum(bits2(100:end-100)~=received_bits2(100:end-100));
                end
            end
            
            [Err_min,ind0]=min(Nb_error0);
            if Err_min==0
                t0=find(Nb_error0==0);
            else
                t0=ind0;
            end
        else
            for kk=1:length(t0)
                yk=y4(t0(kk):Nsample:n); %%%sampling of the detected signal
                 
                if length(yk)>1024
                    
                    yk=y4(t0(kk):Nsample:n-Nsample/2+t0(kk));
                   
                end
                %%%decision
                if  SimulParam.flag_mod==0
                    
                    received_bits=yk>0;
                    %                     ykk=[ykk,yk];
                    %                     ykk0=[ykk0,yk(ind_bit0)];
                    %                     ykk1=[ykk1,yk(ind_bit1)];
                    Nb_error00(kk)=sum(bits(100:end-100)~=received_bits(100:end-100)); %% number of error in a given trail
                    
                else
                    %% number of error in a given trail
                    received_bits1=yk>0;
                    received_bits2=abs(yk)<2;
                    
                    Nb_error00(kk)=sum(bits1(100:end-100)~=received_bits1(100:end-100))+sum(bits2(100:end-100)~=received_bits2(100:end-100));
                end
                
            end
            
            [Nb_error(i,j),indmin]=min(Nb_error00);
            
            if  SimulParam.flag_mod==0
                yk=y4(t0(indmin):Nsample:n); %%%sampling of the detected signal
                
                if length(yk)>1024
                    
                    yk=y4(t0(indmin):Nsample:n-Nsample/2+t0(indmin));
                end
                
                ykk=[ykk,yk];
                ykk0=[ykk0,yk(ind_bit0)];
                ykk1=[ykk1,yk(ind_bit1)];
                
                
            end
            
        end
        
        
        
    end
    
    if  SimulParam.flag_mod==0
        
        if (i~=1  &&  SimulParam.SNRb_mode==1) || SimulParam.SNRb_mode==2
            figure(4)
            subplot(311)
            hist(ykk,1000);
            
            dbin=(max(ykk)-min(ykk))/1000;
            
            h = findobj(gca,'Type','patch');
            set(h,'EdgeColor','k')
            V=axis;
            line([0,0],[V(3),V(4)],'Color','m','LineWidth',2)
            text=strcat('PAM-2 symbol  pdf after the receiver filter for SNRb=',num2str(SNRb_dB(i)),'dB');
            title(text)
            subplot(312)
            Nbin0=fix((max(ykk0)-min(ykk0))/dbin);
            hist([ykk0],Nbin0);
            line([0,0],[V(3),V(4)],'Color','m','LineWidth',2)
            h = findobj(gca,'Type','patch');
            set(h,'EdgeColor','r')
            axis(V)
            title('pdf for bit 0')
            subplot(313)
            Nbin1=fix((max(ykk1)-min(ykk1))/dbin);
            hist([ykk1],Nbin1);
            line([0,0],[V(3),V(4)],'Color','m','LineWidth',2)
            h = findobj(gca,'Type','patch');
            set(h,'EdgeColor','b')
            axis(V)
            title('pdf for bit 1')
            drawnow
        end
        
        if  SimulParam.flag_mod==0
            BER(i)=sum(Nb_error(i,:))/((Nbit-200)*Nb_Trial); %%average BER
        else
            
            BER(i)=sum(Nb_error(i,:))/(2*(Nbit-200)*Nb_Trial); %%average BER
        end
    else
        if  SimulParam.flag_mod==0
            BER(i)=sum(Nb_error(i,:))/((Nbit-200)*Nb_Trial); %%average BER
        else
            BER(i)=sum(Nb_error(i,:))/(2*(Nbit-200)*Nb_Trial); %%average BER
        end
    end
end



if SimulParam.SNRb_mode==1
    
    if  SimulParam.flag_mod==0
        BERa=0.5*erfc(sqrt(SNRb));
    else
        BERa = 3/4*qfunc(sqrt(4/5*SNRb));
    end
    figure(5)
    semilogy(10*log10(SNRb(2:end)),[BER(2:end);BERa(2:end)],'LineWidth',2)
    if SimulParam.Channel_Type==3
        axis([0,10*log10(SNRb(end)),10^-10,1] )
    end
    xlabel ('SNR per bit  [dB]')
    ylabel('BER')
    if SimulParam.flag_mod==1
        title('PAM4')
    else
        title('PAM2')
    end
    legend('Simulation results','Analytical (theoritical) result','Location','Best')
    grid on
else
    BER
end

