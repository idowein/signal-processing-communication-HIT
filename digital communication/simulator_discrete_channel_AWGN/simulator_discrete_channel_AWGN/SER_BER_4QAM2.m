function [bits_rx,BER,BER_analytic]=SER_BER_4QAM2(bits_tx,SNRb_dB)

%%% this function caculates the BER based on error counting  for 4QAM as function of the SNR per
%%% bit and display the detected  constellation diuagram with red symbol being  symbols not correctly detected
% It also returns the recovered bits
%%%INPUT : bits_tx=bit stream to be sent
%%%        required SNR_b_dB=SNR per bit in dB  
%%%OUTPUT : bits_rx=recovered bits at receiver after AWGN channel
%%%         BER=BER calculation baser on bit error counting
%%%         BER_Analytic : Analytic formula of the BER for 4QAM
%%%   
%Author : David Dahan
% Date : 17/12/2013


% TRAMSMITTER

%Symbol Maping with Gray coding
nn=length(bits_tx);
b1=logical(bits_tx(1:2:nn));
b2=logical(bits_tx(2:2:nn));

% 4QAM symbol mapping 
I=(2*b1-1);
Q=(2*b2-1);
S=transpose(I +1j*Q); %symbol sequence
Nsymb=length(S);

Es=mean(abs(S).^2);% mean  Energy per Symbol
Eb=Es/2;% mean Energy per bit

%%channel with AWGN

%SNRb_dB=[16:-1:0]; %% SNR per bit in dB
SNRb=10.^(SNRb_dB/10);%% SNR per bit in linear units


for i=1:length(SNRb)
    
    N0=Eb./SNRb(i); %noise variance
    n=sqrt(N0/2)*(randn(1,Nsymb)+1j*randn(1,Nsymb)); % complex noise generation
    En=mean(abs(n).^2); % mean noise energy
    Gammas(i)=Es/En; % signal to noise ratio per symbol
    Gammab(i)=Gammas(i)/2; % signal to noise ratio per bit
    r=S+n; % add noise to signal
    
    
    
    %detection
    
    [symbol_decision]=decision_region_QPSK(r); %QPSK=4QAM
    b11=real(symbol_decision)>0;
    b22=imag(symbol_decision)>0;
    
    
    %%recovered bit stream
    bits_rx(1:2:nn)=b11;
    bits_rx(2:2:nn)=b22;
    
    
    
    %symbol error rate
    ind=find(symbol_decision~=S);
    
    SER(i)=sum(symbol_decision~=S)/(Nsymb);
    BER(i)=SER(i)/2; % BER for gray coding
    
    figure(3)
    Sm=[1+1j,-1+1j,-1-1j,1-1j]; % symbol set
    
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
    axis([-2,2,-2,2])
     line([-2,2],[0,0],'LineWidth',2,'Color',[0 0 0]);
     line([0,0],[-2,2],'LineWidth',2,'Color',[0 0 0]);
     title (strcat(['4QAM with SNR per bit =',num2str(10*log10(Gammab(i))),'dB and BER =', num2str(BER(i))]),'fontsize',14)
   xlabel('In-phase component','fontsize',14)
   ylabel('Quadrature component','fontsize',14)
    drawnow
    pause(1)
    
end

%%% Analytic BER formula for 16QAM
BER_analytic=0.5*erfc(sqrt(2*Gammab/2));
% figure(4)
% Gammab_dB=10*log10(Gammab);
% semilogy(Gammab_dB,BER,'-',Gammab_dB,BER_analytic,'--','Linewidth',2)
% 
% xlabel('SNR per bit [dB]')
% ylabel('BER')
% grid on
% 
% Gammab_dB_target=interp1(log10(BER_analytic),Gammab_dB,log10(BER_t));
% hold on
% plot([min(Gammab_dB),max(Gammab_dB)],[1,1]*BER_t,'r:','LineWidth',2);
% plot(Gammab_dB_target,BER_t,'ro')
% legend('4-QAM BER based on error counting','Analytic 4-QAM BER formula','Target BER','Location','Best')
% 
% hold off
% disp(strcat(['For 4-QAM, the SNR per bit level of ',num2str(Gammab_dB_target),' dB is required to reach BER=',num2str(BER_t)]));
%  