function XX=Matrix_convolution_filter(X,N)

nX=length(X);

if N<=16
    XX(1,1:N)=X(16:-1:16-N+1);
    
    for i=1:N-1
        XX(i+1,1:N)=[X(16+i),XX(i,1:N-1)];
    end
    
else
    XX(1,1:N)=[X(16:-1:1),zeros(1,N-16)];
    
    for i=1:N-1
        
        if 16+i<=31
            XX(i+1,1:N)=[X(16+i),XX(i,1:N-1)];
            
        else
            
            XX(i+1,1:N)=[0,XX(i,1:N-1)];
        end
    end
    
end