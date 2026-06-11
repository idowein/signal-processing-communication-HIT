function E=EyePattern(x,Nb,num,offset)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% x= input 
%%% Nb=number of samples per bit slot
%%% num= number of bit slot to be showed for the transitions overlapping
%%% offset= initial sample offset
%%% E= Eye diagram matrix
%%% Author : David Dahan

n=length(x);

N=fix(n/Nb);
%E=zeros(N,num*Nb);

for i=1:N-(num+2)

    ind1=offset+1+(i-1)*Nb;
    ind2=ind1+num*Nb-1;
    
E(i,:)=x(ind1:ind2);
end
E=E';
