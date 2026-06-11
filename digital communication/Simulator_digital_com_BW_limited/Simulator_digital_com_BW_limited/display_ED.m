function display_ED(Eye)

[a,b]=size(Eye);
X=1:a;
X=repmat(X,1,b);
Ex=Eye';
Ex=Eye(:);
Ex=Ex';
%ax=subplot(2,nb_group,[i;i+nb_group]);
Imin=min(X);
Imax=max(X);
Qmax=max(Ex);
%Qx=Qx/max(Qx);
data=[Ex',X'];
count=hist2d(data,-1.1*Qmax:Qmax/100:1.1*Qmax,Imin:1:Imax);
h=imagesc((Imin:1:Imax)/(0.5*Imax)-0.5,-1.1*Qmax:Qmax/100:1.1*Qmax,count);
%colormap([0,0,0;hot(128)])
colormap([0,0,0;parula(128)])
%xticks([-1.5:0.25:1.5])
set(gca,'xtick',-1.5:0.25:1.5)
set(gca,'YDir','normal')
%view([-180 90])
%colormap([0,0,0;jet(128)])