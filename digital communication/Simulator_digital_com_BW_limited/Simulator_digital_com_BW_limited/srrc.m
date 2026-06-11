function gsrrc=srrc(beta,t,Tb,V0)

%%generate square root raised cosine pulse
%%beta=roll off factor
%%t =time evtor defined for the pulse
%%Tb=symbol time slot
%%V0=voltage peak value of teh pulse

%gsrrc=V0*((4*beta*Ts*Rs).*cos(pi*(1+beta)*Ts*Rs).*sin(pi*(1-beta)*Ts*Rs))./(pi*Ts*Rs.*(1-(4*beta*Ts*Rs).^2));

gsrrc=V0*((4*beta*t/Tb).*cos(pi*(1+beta)*t/Tb)+sin(pi*(1-beta)*t/Tb))./(pi*t/Tb).*1./(1-(4*beta*t/Tb).^2);
ind=find(isnan(gsrrc)==1);
gsrrc(ind)=interp1(t([ind-10:ind-1,ind+1:ind+10]),gsrrc([ind-10:ind-1,ind+1:ind+10]),0,'spline');%V0*4*beta/pi;
ind2=find(t==Tb/(4*beta));
ind3=find(t==-Tb/(4*beta));
gsrrc(ind2)=V0*(4*beta+pi*(1-beta))/pi;
gsrrc(ind3)=V0*(4*beta+pi*(1-beta))/pi;