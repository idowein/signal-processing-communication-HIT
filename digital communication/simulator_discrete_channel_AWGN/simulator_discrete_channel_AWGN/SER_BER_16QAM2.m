function [bits_rx,BER,BER_analytic,Gammab]=SER_BER_16QAM2(bits_tx,SNRb_dB)

%%% this function caculates the BER based on error counting  for 16 QAM as function of the SNR per
%%% bit and display the detected  constellation diuagram with red symbol being  symbols not correctly detected
% It also returns the recovered bits
%%%INPUT : bits_tx=bit stream to be sent
%%%        required SNR_b_dB=SNR per bit in dB  
%%%OUTPUT : bits_rx=recovered bits at receiver after AWGN channel
%%%         BER=BER calculation baser on bit error counting
%%%         BER_Analytic : Analytic formula of the BER for 16QAM
%%%         
%Author : David Dahan
% Date : 17/12/2013



% TRAMSMITTER

%%%convert bits in
% rand('seed',0);
% b1 = rand(1,Nsymb)>0.5; % random generation of bits 0,1
% b2 =rand(1,Nsymb)>0.5;  % random generation of bits 0,1
% b3 =rand(1,Nsymb)>0.5;  % random generation of bits 0,1
% b4 =rand(1,Nsymb)>0.5;  % random generation of bits 0,1

%Symbol Maping with Gray coding
nn=length(bits_tx);
b1=bits_tx(1:4:nn);
b2=bits_tx(2:4:nn);
b3=bits_tx(3:4:nn);
b4=bits_tx(4:4:nn);

S=Gray_Mapping_16QAM(b1,b2,b3,b4);

Nsymb=length(S);

Es=mean(abs(S).^2);% mean Energy per Symbol
Eb=Es/4;% mean Energy per bit

%% channel with AWGN

% N0=[0.05:0.01:0.50] %total noise energy per symbol

%SNRb_dB=[16:-1:2]; %% SNR per bit in dB
SNRb=10.^(SNRb_dB/10);%% SNR per bit in linear units

for i=1:length(SNRb)
    
    N0=Eb./SNRb(i); %noise variance
    
    n=sqrt(N0/2)*(randn(1,Nsymb)+1j*randn(1,Nsymb)); % complex noise generation
    En=mean(abs(n).^2); % mean noise energy
    Gammas(i)=Es/En; % signal to noise ratio per symbol
    Gammab(i)=Gammas(i)/4; % signal to noise ratio per bit
    r=S+n; % add noise to signal
    
    
    
    %detection based on  decision regions
    
    
    [b11,b22,b33,b44,symbol_decision]=decision_16QAM_Gray(r);
    
    %%recovered bit stream
    bits_rx(1:4:nn)=b11;
    bits_rx(2:4:nn)=b22;
    bits_rx(3:4:nn)=b33;
    bits_rx(4:4:nn)=b44;
    
    %symbol error rate
    ind=find(symbol_decision~=S); % gives the symbol index of the symbols not correctly detected
    
    SER(i)=sum(symbol_decision~=S)/(Nsymb); %Symbol Error Rate
    BER(i)=SER(i)/4; % BER for gray coding
    
    figure(4)
    %%constellation symbols
    
        Sm=[-3-3j,-1-3j,1-3j,3-3j,-3-1j,-1-1j,1-1j,3-1j,-3+1j,-1+1j,1+1j,3+1j,-3+3j,-1+3j,1+3j,3+3j]; % symbol set
        
        if isempty(ind)
            plot(r,'.')
            hold on
            plot(Sm,'s','MarkerFaceColor','m');
            hold off
        else
            
            plot(r,'.');
            hold on
            plot(r(ind),'r.');
            plot(Sm,'s','MarkerFaceColor','m');
            hold off
        end
        axis([-5,5,-5,5])
        
 
     line([-5,5],[-2,-2],'LineWidth',3,'Color',[0 0 0]);
     line([-5,5],[0,0],'LineWidth',3,'Color',[0 0 0]);
     line([-5,5],[2,2],'LineWidth',3,'Color',[0 0 0]);
     line([-2,-2],[-5,5],'LineWidth',3,'Color',[0 0 0]);
     line([0,0],[-5,5],'LineWidth',3,'Color',[0 0 0]);
     line([2,2],[-5,5],'LineWidth',3,'Color',[0 0 0]);
     title (strcat(['16QAM  with SNR per bit =',num2str(10*log10(Gammab(i))),'dB and BER =', num2str(BER(i))]),'fontsize',14)
   xlabel('In-phase component','fontsize',14)
   ylabel('Quadrature component','fontsize',14)
    drawnow
    pause(1)
    
end

%%% Analytic BER formula for 16QAM
BER_analytic=3/8*erfc(sqrt(4*Gammab/10));
% figure(6)
% 
% Gammab_dB=10*log10(Gammab);
% % semilogy(Gammab_dB,BER,'-',Gammab_dB,BER_analytic,'--','Linewidth',2)
% % 
% % xlabel('SNR per bit [dB]')
% % ylabel('BER')
% % grid
% % 
% % Gammab_dB_target=interp1(log10(BER_analytic),Gammab_dB,log10(BER_t));
% % hold on
% % plot([min(Gammab_dB),max(Gammab_dB)],[1,1]*BER_t,'r:','LineWidth',2);
% % plot(Gammab_dB_target,BER_t,'ro')
% % 
% % legend('16-QAM BER based on error counting','Analytic 16-QAM BER formula','Target BER','Location','Best')
% % 
% % hold off
% % disp(strcat(['For 16-QAM, the SNR per bit level of ',num2str(Gammab_dB_target),' dB is required to reach BER=',num2str(BER_t)]));
% %  
 