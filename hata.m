% program for simulation of large scale path loss using HATA model
% program by: Deepak Kumar Rout
% vss university of technology, Burla, Orissa, India

clc;
clear all;
close all;
f=1;
t=input ('Enter type of city (1 - small or medium city, 2 - large city)--:');
u=input ('Enter type of city (1 - urban , 2 - suburban, 3-rural)--:');
ht=input('Enter height of transmitting antenna(30 to 200m)--:');
hr=input('Enter height of receiving antenna(1 to 10m)--:');
f=input('Enter freuency in MHZ from 150 to 1500--:');
display('The median path loss for your given data is L50 in dB is');

        if t==1
            cf=(1.1*log(f)-0.7)*hr-(1.566*log(f)-0.8);
            elseif f <= 300
                cf=8.29*(log(1.54*hr))*(log(1.54*hr))-1.1;
        else
            cf=3.2*(log(11.75*hr))*(log(11.75*hr))-4.97;
        end
            L50=69.55+26.16*log(f)-13.82*log(ht)-cf;
if u==2
    L50=L50-(2*log(f/28)*log(f/28))-5.4;
    elseif u==3
        L50=L50-(4.78*log(f)*log(f))+18.33*log(f)-40.94;
end
    
display(L50);
figure
f=1;
% plot for entire range of frequencies
display('The plot for entire range of frequencies from 150 MHz to 1500 MHz is shown in the plot');
h = waitbar(0,'plotting the path loss for the entire range of frequencies please wait......');

 for f=150:2:1500
      if t==1
            cf=(1.1*log(f)-0.7)*hr-(1.566*log(f)-0.8);
            elseif f <= 300
                cf=8.29*(log(1.54*hr))*(log(1.54*hr))-1.1;
        else
            cf=3.2*(log(11.75*hr))*(log(11.75*hr))-4.97;
        end
            L50=69.55+26.16*log(f)-13.82*log(ht)-cf;
if u==2
    L50=L50-(2*log(f/28)*log(f/28))-5.4;
    elseif u==3
        L50=L50-(4.78*log(f)*log(f))+18.33*log(f)-40.94;
        
end

subplot(1,1,1);
plot(f,L50);hold on;
title('The plot for entire range of frequencies from 150 MHz to 1500 MHz');
xlabel('frequency(in MHz)');ylabel('Median path loss in dB');
waitbar(f / 1500)
 end
close(h);

