function [symbol_decision,error_vector]=decision_region_BPSK(r)
%%symbol decision according to decsion region criterion
%%INPUT : r=detected symbol vector
%%OUTPUT : symbol_decision=vector of the decision vector
%%%        error_vector=error vector 



S=[1,-1]; % symbol set [S0,S1]
N=length(r);
symbol_decision=-1*ones(1,N); % by default the decision veor is set to be -1

a=real(r);
%b=imag(r);

ind= a>=0; % find the  indexes of the vector elements that have a>=0
symbol_decision(ind)=1;
error_vector=r-symbol_decision;

