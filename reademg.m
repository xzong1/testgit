%row1--time,row2--switch,row3--startle,row4--audio
f1=fopen('061915_MO01_trial1_tg1.txt');
[data,count]=fread(f1,[15,inf],'double');
data=data';
w1=[59/1500,61/1500];
w2=[30/1500];
[b,a]=butter(4,w1,'stop');
[d,c]=butter(4,w2,'high');
filt1=filtfilt(b,a,data(:,5:12));
%demean
filt1=filtfilt(d,c,filt1);

data(:,5:12)=abs(bsxfun(@minus,filt1,nanmean(filt1)));



figure 
subplot(5,1,1);
plot(data(:,1),data(:,5))%ch2
title('ED3')

subplot(5,1,2);
plot(data(:,1),data(:,6))%ch1
title('ED2')

subplot(5,1,3);
plot(data(:,1),data(:,7))%ch3
title('ED4')

subplot(5,1,4);
plot(data(:,1),data(:,8))%ch4
title('EDN')

subplot(5,1,5);
plot(data(:,1),data(:,9))%ch5
title('thumb')


