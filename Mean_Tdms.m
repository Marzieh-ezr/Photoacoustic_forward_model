%TDMS mean channels

function Mean_signal=Mean_Tdms(channels)
A=zeros(1,1800);
for i=0:34
    
   C = channels.(['v',num2str(i),'_CH0']).data;
   C=C(1:1800);
   A=A+C;
   
end 

Mean_signal=A/35;
