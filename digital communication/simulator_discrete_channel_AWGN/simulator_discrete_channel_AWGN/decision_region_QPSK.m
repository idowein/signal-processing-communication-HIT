function [symbol_decision,error_vector]=decision_region_QPSK(r)
%%symbol decision according to decsion region criterion
%%INPUT : r=detected symbol vector
%%OUTPUT : symbol_decision=vector of the decision vector
%%%        error_vector=error vector 


S=[1+1j,-1+1j,-1-1j,1-1j]; % symbol set [S0,S1,S2,S3]
N=length(r);
symbol_decision_I=-1*ones(1,N); %in phase component of the decision vector
symbol_decision_Q=-1*ones(1,N); %in phase component of the decision vector

a=real(r);
b=imag(r);

ind= a>=0; % find the  indexes of the vector elements that have a>=0
symbol_decision_I(ind)=1;
ind= b>=0; % find the  indexes of the vector elements that have a>=0
symbol_decision_Q(ind)=1;

symbol_decision=symbol_decision_I+1j*symbol_decision_Q;

error_vector=r-symbol_decision;

% 
% 
% for i=1:N
%     
%     a=real(r(i));
%     b=imag(r(i));
%     
%     if a>=0
%         
%        if b>=0
%          
%            symbol_decision(i)=(1+1j); % select S0
%        
%        else
%            symbol_decision(i)=(1-1j); % select S3
%        end
%         
%     else
%         
%         if b>=0
%          
%            symbol_decision(i)=(-1+1j); % select S1
%        
%        else
%            symbol_decision(i)=(-1-1j); % select S2
%        end
%         
%         
%     end
%     error_vector(i)=r(i)-symbol_decision(i); % calculate the error vector
%       
%     
%     
%     
% end
%     