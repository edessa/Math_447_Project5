function [Y, C]=dct(X) 
[m,n]=size(X);n=m;
for i=2:n
    for j=1:n
        C(i,j)=sqrt(2/n)*cos((i-1)*(j-1/2)*pi/n);
    end
end
C(1,1:n)=ones(1,n)/sqrt(n);
Y=C*X*C';
  