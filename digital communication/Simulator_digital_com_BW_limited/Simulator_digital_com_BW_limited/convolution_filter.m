function XX=convolution_filter(X,N)

nX=length(X);

if N<=6
XX(1,1:N)=X(6:-1:6-N);

for i=1:N-1
XX(i+1,1:N)=X(6+i:-1:6+i-N);    
end
