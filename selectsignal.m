function [Xseries, Yseries] = selectsignal(X,Y,distance,cuvette_length)
% this function tries to find the section of the data which behaves exponentially.

xlimit1=distance;
xlimit2=cuvette_length+distance;
nearest= min(abs(X-xlimit1));
% find index of nearest time value
indexX1 = find(X==xlimit1+nearest | X==xlimit1-nearest);
nearest= min(abs(X-xlimit2));
% find index of nearest time value
indexX2 = find(X==xlimit2+nearest | X==xlimit2-nearest);
%define the new set of data
X=X(indexX1:indexX2);
Y=Y(indexX1:indexX2);

% rearranging data to be compatible with the exponential model.
Xseries=distance + cuvette_length - X';
Yseries=Y';

end