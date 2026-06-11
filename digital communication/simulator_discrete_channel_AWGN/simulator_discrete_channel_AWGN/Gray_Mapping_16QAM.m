function [IQ]=Gray_Mapping_16QAM(b1,b2,b3,b4)
%% symbol mapping according to gray coding

N=length(b1);

I=zeros(1,N);
Q=zeros(1,N);


ind= (b1==0) & (b2==0);
I(ind)=-3;

ind= (b1==0) & (b2==1);
I(ind)=-1;

ind= (b1==1) & (b2==1);
I(ind)=1;

ind= (b1==1) & (b2==0);
I(ind)=3;


ind= (b3==0) & (b4==0);
Q(ind)=-3;

ind= (b3==0) & (b4==1);
Q(ind)=-1;

ind= (b3==1) & (b4==1);
Q(ind)=1;

ind= (b3==1) & (b4==0);
Q(ind)=3;

IQ=I+1j*Q;



% 
% for k=1:N
%     
%      switch num2str([b1(k) b2(k)])
%          
%          case '0  0'
%                I(k)=-3;
%          case '0  1'
%               I(k)=-1;
%          case  '1  1'
%                 I(k)=1;
%          case '1  0'
%                 I(k)=3;
%                     
%      end
%      
%      
%      switch num2str([b3(k) b4(k)])
%          
%          case '0  0'
%                Q(k)=-3;
%          case '0  1'
%               Q(k)=-1;
%          case  '1  1'
%                 Q(k)=1;
%          case '1  0'
%                 Q(k)=3;
%                     
%      end
%      
% end
% IQ=I+1j*Q;
% 
% 
% 
% 
% 
% 
