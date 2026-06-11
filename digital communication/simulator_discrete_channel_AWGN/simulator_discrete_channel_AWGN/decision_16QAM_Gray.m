function [b1,b2,b3,b4,symbol_decision]=decision_16QAM_Gray(r)
%%symbol decision according to decision region criterion
%%INPUT : r=detected symbol vector
%%OUTPUT : symbol_decision=vector of the decision vector
%%%        b1=decision for bit1 
%%%        b2=decision for bit2 
%%%        b3=decision for bit3 
%%%        b4=decision for bit4 

N=length(r);
b1=zeros(1,N);
b2=zeros(1,N);
b3=zeros(1,N);
b4=zeros(1,N);



symbol_decision_I=-3*ones(1,N); %in phase component of the decision vector
symbol_decision_Q=-3*ones(1,N); %in phase component of the decision vector

a=real(r);
b=imag(r);


% For the inphase component of the decision vector and bits b1 & b2
ind= a>=-2; % find the  indexes of the vector elements that have a>=-2
symbol_decision_I(ind)=-1;
b1(ind)=0;
b2(ind)=1;

ind= a>=0; % find the  indexes of the vector elements that have a>=0
symbol_decision_I(ind)=1;
b1(ind)=1;
b2(ind)=1;

ind= a>=2; % find the  indexes of the vector elements that have a>=2
symbol_decision_I(ind)=3;
b1(ind)=1;
b2(ind)=0;


% For the quadrature phase component of the decision vector and bits b3 & b4
ind= b>=-2; % find the  indexes of the vector elements that have b>=-2
symbol_decision_Q(ind)=-1;
b3(ind)=0;
b4(ind)=1;

ind= b>=0; % find the  indexes of the vector elements that have b>=0
symbol_decision_Q(ind)=1;
b3(ind)=1;
b4(ind)=1;

ind= b>=2; % find the  indexes of the vector elements that have b>=2
symbol_decision_Q(ind)=3;
b3(ind)=1;
b4(ind)=0;


symbol_decision=symbol_decision_I+1j*symbol_decision_Q;



% 
% 
% ind= b>=0; % find the  indexes of the vector elements that have a>=0
% symbol_decision_Q(ind)=1;
% 
% symbol_decision=symbol_decision_I+1j*symbol_decision_Q;
% 
% error_vector=r-symbol_decision;
% 
% for i=1:N
%     
%     a=real(r(i));
%     b=imag(r(i));
%     
%     if a<-2
%         I=-3;
%         b1(i)=0;
%         b2(i)=0;
%     elseif (a>=-2) && (a<0)
%         I=-1;
%         b1(i)=0;
%         b2(i)=1;
%     elseif (a>=0) && (a<2)
%         I=1;
%         b1(i)=1;
%         b2(i)=1;
%     else % b>=2 (a>=0) && (a<2)
%         I=3;
%         b1(i)=1;
%         b2(i)=0;
%     end
%     
%     
%     
%     if b<-2
%         Q=-3;
%         b3(i)=0;
%         b4(i)=0;
%     elseif (b>=-2) && (b<0)
%         Q=-1;
%         b3(i)=1;
%         b4(i)=0;
%     elseif (b>=0) && (b<2)
%         Q=1;
%         b3(i)=1;
%         b4(i)=1;
%     else % b>=2 (a>=0) && (a<2)
%         Q=3;
%         b3(i)=1;
%         b4(i)=0;
%     end
%     
%    decision(i)=I+1j*Q; 
% end
% 
% 
