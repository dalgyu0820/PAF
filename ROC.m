close all
clear all
%% 스프레드시트에서 데이터 가져오기
% 
filename = "C:\Users\moong\OneDrive\3.Project\2. PAF\2) Document\crf_inOR_total_20230123 v5.xlsx";
sheet = "ROC";
range = "L2:R364";
Total = xlsread(filename,sheet,range);
Cutoff = Total(:,1);
TP = Total(:,2);
TN = Total(:,3);
FP = Total(:,4);
FN = Total(:,5);
SE = Total(:,6);
SP = Total(:,7);
SP_1 = 1-SP;

f1 = figure(1);



% p1 = plot(SP_1,SE,'o');
% p1.LineWidth = 1;
% p1.Color = 'black';
% hold on
p1 = plot(SP_1,SE);
p1.LineWidth = 5;
p1.Color = 'black';
hold on

p2 = line([0,1],[0,1]);
p2.Color = 'red';
p2.LineWidth = 5;
p2.LineStyle = '--';

% fitobject = fit(SP_1,SE,'poly4');
% p3 = plot(fitobject);
% p3.Color = 'blue';
% p3.LineWidth = 5;
% p3.LineStyle = '--';

hold off

set(gca,'LineWidth',3);
set(gca,'FontSize',25);
xlim([0 1]); ylim([0 1.1]);
xlabel('1 - Specificity');
ylabel('Sensitivity');
grid on
box off
% legend('Data','Ref','Curvefitting','Location','southeast')

AUC = 0;
for i = 2:length(SE)
    X_lengh = (SP_1(i-1) - SP_1(i));
    Y_lengh = SE(i);
    AUC = AUC + X_lengh*Y_lengh;
end



disp(AUC)