function [BER,BER_analytic,Gammab]=SER_BER_BPSK(Nsymb,BER_t,display_mode)

%%% this function caculates the BER based on error counting  for BPSK as function of the SNR per
%%% bit and display the detected  constellation diagram with red symbol being  symbols not correctly detected
%%%INPUT : Nsymb=number of symbols
%%%        BER_t=BER target
%%%OUTPUT : BER=BER calculation baser on bit error counting
%%%         BER_Analytic : Analytic formula of the BER for BPSK
%%%         Gammab=SNR per bit
%Author : David Dahan
% Date : 17/12/2013


% TRAMSMITTER

%%%PRBS Generation
rand('seed',0);
b1 = rand(1,Nsymb)>0.5; % random generation of bits 0,1


% symbol mapping 
S_I=2*b1-1;

S=S_I ;


Es=mean(abs(S).^2);
Eb=Es;% mean Energy per bit

%%channel with AWGN

SNRb_dB=[16:-1:0]; %% SNR per bit in dB
SNRb=10.^(SNRb_dB/10);%% SNR per bit in linear units

for i=1:length(SNRb)
    
    N0=Eb./SNRb(i); %noise variance
    n=sqrt(N0/2)*(randn(1,Nsymb)+1j*randn(1,Nsymb)); % complex noise generation
    En=mean(abs(n).^2); % mean noise energy
    Gammas(i)=Es/En; % signal to noise ratio per symbol
    Gammab(i)=Gammas(i); % signal to noise ratio per bit
    r=S+n; % add noise to signal
    
    
    
    %detection
    
    [symbol_decision]=decision_region_BPSK(r);
    
    
    %symbol error rate
    ind=find(symbol_decision~=S);
    
    SER(i)=sum(symbol_decision~=S)/(Nsymb);
    BER(i)=SER(i); % BER for gray coding
    
    figure(1)
    subplot(111)
    
    if display_mode==1
        display_constellation(imag(r),real(r),2)
        colorbar
        
    else
        
        Sm=[1,-1]; % symbol set
        
        if isempty(ind)
            plot(r,'.')
            hold on
            plot([1,-1],[0,0],'s','MarkerFaceColor','m');
            hold off
        else
            
            plot(r,'.');
            hold on
            plot(r(ind),'r.');
            plot([1,-1],[0,0],'s','MarkerFaceColor','m');
            hold off
        end
        
    end
    axis([-2,2,-2,2])
          line([0,0],[-2,2],'LineWidth',3,'Color',[0 0 0]);
     title (strcat(['BPSK with SNR per bit =',num2str(10*log10(Gammab(i))),'dB ans BER =', num2str(BER(i))]),'fontsize',14)
   xlabel('In-phase component','fontsize',14)
   ylabel('Quadrature component','fontsize',14)
    drawnow
    pause(1)
    
    
end


%%% Analytic BER formula for BSPK
BER_analytic=0.5*erfc(sqrt(2*Gammab/2));
figure(2)

Gammab_dB=10*log10(Gammab);
semilogy(Gammab_dB,BER,'-',Gammab_dB,BER_analytic,'--','Linewidth',2)

xlabel('SNR per bit [dB]')
ylabel('BER')
grid

Gammab_dB_target=interp1(log10(BER_analytic),Gammab_dB,log10(BER_t));
hold on
plot([min(Gammab_dB),max(Gammab_dB)],[1,1]*BER_t,'r:','LineWidth',2);
plot(Gammab_dB_target,BER_t,'ro')
hold off
legend('BPSK BER based on error counting','Analytic BPSK BER formula','Target BER','Location','Best')

disp(strcat(['For BPSK, the SNR per bit level of ',num2str(Gammab_dB_target),' dB is required to reach BER=',num2str(BER_t)]));
 
 