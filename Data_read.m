close all; %clear sig_PA;
disp("start")
%% loading control
numavg_idx = 0;
s_idx = 0;
e_idx = 0;
loadctrl = 0;
loadPA = 0;
sig_ctrl_idx = 0;
sig_PA_idx = 0;
temp_min_idx = 0; 
temp_max_idx = 0;

datapath = uigetdir('C:\Users\moong\OneDrive\3.Project\2. PAF\1) Experiment_Data','Select Data path');
numavg = 1;
s = 1;%10;
e = 1;%22.5;
temp_min = 3;
temp_max = 8.4;
prompt = {'Number of average','Low frequency','High frequency','Lengh min','Lengh max'};
dlgtitle = 'Input';
dims = [1 35];
definput = {num2str(numavg),num2str(s),num2str(e),num2str(temp_min),num2str(temp_max)};
answer = inputdlg(prompt,dlgtitle,dims,definput);

if numavg ~= str2num(answer{1,1})
    numavg = str2num(answer{1,1});
    numavg_idx = 1;
end

if s ~= str2num(answer{2,1})
    s = str2num(answer{2,1});
    s_idx = 1;
end

if e ~= str2num(answer{3,1})
    e = str2num(answer{3,1});
    e_idx = 1;
end

if temp_min ~= str2num(answer{4,1})
    temp_min = str2num(answer{4,1});
    temp_min_idx = 1;
end

if temp_max ~= str2num(answer{5,1})
    temp_max = str2num(answer{5,1});
    temp_max_idx = 1;
end



answer = questdlg('Load?', ...
	'Question', ...
	'PA','ctrl','both','Not at all');
switch answer
    case 'PA'
        loadctrl = 0;
        loadPA = 1;
    case 'ctrl'
        loadctrl = 1;
        loadPA = 0;
    case 'both'
        loadctrl = 1;
        loadPA = 1;
    case ''
        loadctrl = 0;
        loadPA = 0;
end
sig_ctrl_idx = exist("sig_ctrl","var");
sig_PA_idx = exist("sig_PA","var");

if loadctrl == 1 || sig_ctrl_idx == 0
    if exist("sig_ctrl","var")==1
        clear sig_ctrl;
        clear sig_ctrl_avg;
        clear sig_ctrl_bandpass;
        clear sig_ctrl_fft
    end
    sig_ctrl = PAFData(datapath);
end
if loadPA == 1 || sig_PA_idx == 0
    if exist("sig_PA","var")==1
        clear sig_PA;
        clear sig_PA_avg;
        clear sig_PA_bandpass;
        clear sig_PA_fft
    end
    [sig_PA, sizePixel] = PAFData(datapath);
end

if loadctrl == 1 || numavg_idx == 1
    disp("numavg_ctrl")
    parfor i = 1:size(sig_ctrl,2)-(numavg-1)
    sig_ctrl_avg(:,i) = mean(sig_ctrl(:,i:i+(numavg-1)),2);
    end
end

if loadPA == 1 || numavg_idx == 1
    disp("numavg_PA")
    parfor i = 1:size(sig_PA,2)-(numavg-1)
    sig_PA_avg(:,i) = mean(sig_PA(:,i:i+(numavg-1)),2);
    end
end


fs = 50; %MHz
dt = 1/fs; %us
t = (0:dt:(sizePixel/2-1)*dt)';
x = t*1.5-300; %mm
if exist("sig_ctrl_bandpass","var") == 0 && exist("sig_PA_bandpass","var") == 0
    disp("bandpass initializing")
    sig_ctrl_bandpass = zeros(size(sig_ctrl_avg));
    sig_PA_bandpass = zeros(size(sig_PA_avg));

end

if loadctrl == 1 || s_idx == 1 || e_idx == 1
    disp("bandpass_ctrl")
    parfor i = 1:size(sig_ctrl_avg,2)
        sig_ctrl_bandpass(:,i) = bandpass(sig_ctrl_avg(:,i),[s e].*1e06,fs*1e06);
    end
end

if loadPA == 1 || s_idx == 1 || e_idx == 1
    disp("bandpass_PA")
    parfor j = 1:size(sig_PA_avg,2)
        sig_PA_bandpass(:,j) = bandpass(sig_PA_avg(:,j),[s e].*1e06,fs*1e06);
    end
end
% sig_PA_bandpass = bandpass(sig_PA(:,10),[5 22.5].*1e06,fs*1e06);
% figure;plot(x,sig_PA(:,10));xlim([0 10]);
% hold on 
% plot(x,sig_PA_bandpass)
% hold off
%%

% f1 = figure(1); set(f1,'position', [0 0 1200 500]); 
% xlim([3 10]);  ylim([-1 1]);hold on
% xlabel('Distance [mm]');
% ylabel('PA amplitude [a.u]');
% set(gca, 'FontSize',25);
% set(gca,'LineWidth',4);
% set(gca,'FontWeight','bold');
% grid on
% for j = size(sig_PA,2)-100:size(sig_PA,2)
%     p1 = plot(x,sig_PA(:,j));
%     p1.LineWidth = 2;
%     pause(0.7);
%     title(numd');
% grid on
% for j = size(sig_PA,2)-1002str(j));
% end

% f2 = figure(2); set(f2,'position', [0 0 1200 500]); 
% xlim([5 10]);  ylim([-1 1]);hold on
% xlabel('Distance [mm]');
% ylabel('PA amplitude [a.u]');
% set(gca, 'FontSize',25);
% set(gca,'LineWidth',4);
% set(gca,'FontWeight','bol:size(sig_PA,2)
%     p1 = plot(x,abs(hilbert(sig_PA(:,j))));
% %     p1 = plot(x(xlim_min:xlim_max,:),temp(:,j));
%     p1.LineWidth = 2;
%     pause(0.7);
%     title(num2str(j));
% end

% temp_min = 4;
% temp_max = 6;
xlim_min = find(x<temp_min,1,'last');
xlim_max = find(x<temp_max,1,'last');
% temp = abs(hilbert(sig_PA(xlim_min:xlim_max,fix(size(sig_PA_avg,2)*0.5):size(sig_PA_avg,2))));
temp = abs(hilbert(sig_PA_bandpass(xlim_min:xlim_max,:)));
[PAsig_1 idx_1]= max(temp,[],2);
[PAsig_max idx_max]= max(PAsig_1);


temp = abs(hilbert(sig_ctrl_bandpass(xlim_min:xlim_max,:)));
RowSize=size(temp,1);
temp(temp == 0) = [];
temp = reshape(temp,RowSize,[]);

[PAsig_min idx_min]= max(mean(temp));
PAsig_min = max(temp(:,idx_min));

[PAsig_min2 idx_min2]= min(mean(temp));
%% final figure

% MaxFrame = fix(size(sig_PA_avg,2)*0.5)-1+idx_1(idx_max);
% MinFrame = fix(size(sig_PA_avg,2)*0.5)-1+idx_min;
MaxFrame = idx_1(idx_max);
MinFrame = idx_min;
f1 = figure(1); f1.WindowState = 'maximized';
subplot(2,3, [1 2]);p2 = plot(x,sig_ctrl_bandpass(:,MinFrame));
p2.Color = 'k';
p2.LineWidth = 4;
hold on
p3 = plot(x,sig_PA_bandpass(:,MaxFrame));
% p3 = plot(x,sig_PA_Blood(:,MaxFrame_blood));
p3.Color = 'r';
p3.LineWidth = 4;
% 
% p4 = plot(x,sig_PA_IC(:,MaxFrame_IC));
% p4.Color = 'b';
% p4.LineWidth = 4;
hold off

xlabel('Distance [mm]');
ylabel('PA amplitude [a.u]');


set(gca, 'FontSize',15);
set(gca,'LineWidth',4);
set(gca,'FontWeight','bold');
grid on
xlim([temp_min temp_max]); ylim([-0.2 0.2]);
title("PA signal")
box off


subplot(2,3, [4 5]); 
p4 = plot(x,abs(hilbert(sig_PA_bandpass(:,MaxFrame))));
p4.Color = 'r';
p4.LineWidth = 4;
hold on
line([x(xlim_min+idx_max-1) x(xlim_min+idx_max-1)],ylim,'Color','m','LineStyle','--','LineWidth',4)
line(xlim,[PAsig_min PAsig_min],'Color','k','LineStyle','--','LineWidth',4)

xlim([temp_min temp_max]); ylim([0 0.5]);
PAsig_idx= (PAsig_max - PAsig_min)*1000;
title(sprintf("PAsig diff amplitude = %4.0f",PAsig_idx));
set(gca, 'FontSize',15);
set(gca,'LineWidth',4);
set(gca,'FontWeight','bold');
grid on
box off
hold off

subplot(2,3,[3 6]);
L = xlim_max - xlim_min;
f = fs*(0:(L/2))/L;
df = f(2)-f(1);
f_s_idx = find(f<s,1,'last');
f_e_idx = find(f<e,1,'last');

sig_PA_fft = fft(sig_PA_avg(xlim_min:xlim_max,MaxFrame));
P2 = abs(sig_PA_fft/L); %양방향
P1 = P2(1:fix(L/2)+1); %단방향
P1(2:end-1) = 2*P1(2:end-1); %단방향 크기 2배
P1_nor_PA = P1/max(P1); %Normalization
P1_nor_PA_mean = mean(P1_nor_PA(f_s_idx:f_e_idx));
P1_nor_PA_area = sum(P1_nor_PA(f_s_idx:f_e_idx).*df);
plot(f,20*log10(P1_nor_PA),'r','LineWidth',4);xlim([0 25])
hold on
line(xlim,[20*log10(P1_nor_PA_mean) 20*log10(P1_nor_PA_mean)],'Color','m','LineStyle','--','LineWidth',3)

sig_ctrl_fft = fft(sig_ctrl_avg(xlim_min:xlim_max,MinFrame));
P2 = abs(sig_ctrl_fft/L); %양방향
P1 = P2(1:fix(L/2)+1); %단방향
P1(2:end-1) = 2*P1(2:end-1); %단방향 크기 2배
P1_nor_ctrl = P1/max(P1); %Normalization
P1_nor_ctrl_mean = mean(P1_nor_ctrl(f_s_idx:f_e_idx));
P1_nor_ctrl_area = sum(P1_nor_ctrl(f_s_idx:f_e_idx).*df);
plot(f,20*log10(P1_nor_ctrl),'k','LineWidth',4)
xlim([0 25]); ylim([-60 0]);
line(xlim,[20*log10(P1_nor_ctrl_mean) 20*log10(P1_nor_ctrl_mean)],'Color','blue','LineStyle','--','LineWidth',3)
line([s s],ylim,'Color','green','LineStyle','--','LineWidth',3)
line([e e],ylim,'Color','green','LineStyle','--','LineWidth',3)


Frequency_idx = (20*log10(P1_nor_PA_mean) - 20*log10(P1_nor_ctrl_mean));
% Frequency_idx = (P1_nor_PA_area -P1_nor_ctrl_area);
Overall_idx = (PAsig_idx + Frequency_idx)/2;
title(sprintf("Frequency idx = %4.2f\n Overall index = %4.0f" ...
    ,Frequency_idx,Overall_idx));

hold off
xlabel('Frequency [MHz]');
ylabel('Amplitude [a.u]');

set(gca, 'FontSize',15);
set(gca,'LineWidth',4);
set(gca,'FontWeight','bold');
grid on
box off
xlim([0 25])
% sig_PA_bandpass_fft = fft(sig_PA_bandpass(xlim_min:xlim_max,MaxFrame));
% P2 = abs(sig_PA_bandpass_fft/L); %양방향
% P1 = P2(1:fix(L/2)+1); %단방향
% P1(2:end-1) = 2*P1(2:end-1); %단방향 크기 2배
% P1_nor = P1/max(P1); %Normalization
% plot(f,20*log10(P1_nor),'m')

disp("end")