function display_constellation(Ix,Qx,M)

data=[Ix',Qx'];


if M<=4
     count=hist2d(data,-2:0.025:2,-2:0.025:2);
    imagesc(-2:0.025:2,-2:0.025:2,count);
 
    
else
    count=hist2d(data,-5:0.05:5,-5:0.05:5);
    imagesc(-5:0.05:5,-5:0.05:5,count); 
    
    
end

%colormap([0,0,0;hot(128)])
colormap([1,1,1;jet(256)])