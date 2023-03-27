close all
clear all
%% 스프레드시트에서 데이터 가져오기
% 
filename = "C:\Users\moong\OneDrive\3.Project\2.PAF\2.Document\0.실험결과\BoxPlot.xlsx";
sheet = "SLNbData";
range = "J2:S299";
Total = xlsread(filename,sheet,range);

HotBlue = zeros(length(Total),3);
ColdBlue = zeros(length(Total),3);
HotNonblue = zeros(length(Total),3);
ColdNonblue = zeros(length(Total),3);
Control = zeros(length(Total),3);

j = 1; k = 1; l = 1; m = 1; c=1;
for i = 1:length(Total)
    if Total(i,1)>0 %Exp
        if Total(i,3)>0 %Hot
            if Total(i,5)>0 %HotBlue
                HotBlue(j,1) = j;
                HotBlue(j,2) = Total(i,4);
                HotBlue(j,3) = Total(i,10);
                j = j+1;
            else %HotNonblue
                HotNonblue(k,1) = k;
                HotNonblue(k,2) = Total(i,4);
                HotNonblue(k,3) = Total(i,10);
                k = k+1;
            end
        else %cold
            if Total(i,5)>0 %ColdBlue
                ColdBlue(l,1) = l;
                ColdBlue(l,2) = Total(i,4);
                ColdBlue(l,3) = Total(i,10);
                l = l+1;
            else %coldNonblue
                ColdNonblue(m,1) = m;
                ColdNonblue(m,2) = Total(i,4);
                ColdNonblue(m,3) = Total(i,10);
                m = m+1;
            end
        end
    else
        Control(c,1) = c;
        Control(c,2) = Total(i,4);
        Control(c,3) = Total(i,10);
        c = c+1;
    end
end
HotBlue(j:end,:) = [];
HotNonblue(k:end,:) = [];
ColdBlue(l:end,:) = [];
ColdNonblue(m:end,:) = [];
Control(c:end,:) = [];

HotBlue_PAF = HotBlue(:,3);           HotBlue_Gamma = HotBlue(:,2);
ColdBlue_PAF = ColdBlue(:,3);         ColdBlue_Gamma = ColdBlue(:,2);
HotNonblue_PAF = HotNonblue(:,3);     HotNonblue_Gamma = HotNonblue(:,2);
ColdNonblue_PAF = ColdNonblue(:,3);   ColdNonblue_Gamma = ColdNonblue(:,2);
Control_PAF = Control(:,3);           Control_Gamma = Control(:,2);

Blue = [HotBlue_PAF; ColdBlue_PAF];
Nonblue = [HotNonblue_PAF; ColdNonblue_PAF];
NonblueSLN = HotNonblue_PAF;

% f1= figure(1);
% set(f1,'position',[0 0 500 700]);
% x = [HotBlue; ColdBlue; HotNonblue; ColdNonblue; Control];
% g1 = repmat(1,size(HotBlue(:,1),1),1);
% g2 = repmat(2,size(ColdBlue(:,1),1),1);
% g3 = repmat(3,size(HotNonblue(:,1),1),1);
% g4 = repmat(4,size(ColdNonblue(:,1),1),1);
% g5 = repmat(5,size(Control(:,1),1),1);
% g = [g1; g2; g3; g4; g5];
% b1 = boxplot(x,g,'Symbol','','Colors','k','Labels',{'HotBlue','ColdBlue','HotNonblue','ColdNonblue','Control'});
% % set(b1,'linewidth',4);
% % set(b1,'linestyle','-');
% % title('Relative increament [a.u.]')
% hold on
% scatter(g(:),x(:),75,'filled','MarkerFaceColor',[1 0 0],'MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.15);
% % scatter(g2(:),x(:),75,'filled','MarkerFaceColor',[0 1 0],'MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.15);
% 
% box off; hold off;
% set(gca,'LineWidth',5,'FontSize',15)
% % ylim([-25 50]);yticks([-70 -30 0 25 50 100]);
% grid on
% ax = gca;
% ax.LineWidth = 2;
% ax.XGrid = 'off';
%% PAF box plot
f2= figure(2);
set(f2,'position',[0 0 500 700]);
x = [Blue; NonblueSLN; Control_PAF];
g1 = repmat(1,size(Blue(:,1),1),1);
g2 = repmat(2,size(NonblueSLN(:,1),1),1);
g3 = repmat(3,size(Control_PAF(:,1),1),1);

g = [g1; g2; g3];
b1 = boxplot(x,g,'Symbol','','Colors','k','Labels',{'Blue','Nonblue','Control'});
% set(b1,'linewidth',4);

hold on
scatter(g1(:),Blue(:),'o','filled','MarkerFaceColor',[0 0 1],'MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.15);
scatter(g2(:),NonblueSLN(:),'d','filled','MarkerFaceColor',[0 1 0],'MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.15);
scatter(g3(:),Control_PAF(:),'^','filled','MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.15);

box off; hold off;
set(gca,'LineWidth',5,'FontSize',15)
ylim([0 60]);yticks([0 8 9 10 20 30 40 50 60]);
grid on
ax = gca;
ax.LineWidth = 2;
ax.XGrid = 'off';

% [h1 p1] = ttest2(Blue,Nonblue);
% [h2 p2] = ttest2(Nonblue,Control);
% [h3 p3] = ttest2(Blue,Control);

%H0: x와 y의 데이터가 중앙값이 같은 연속 분포(?)에서 추출된 표본이다.
[p1 h1] = ranksum(Blue,NonblueSLN);
[p2 h2] = ranksum(NonblueSLN,Control_PAF);
[p3 h3] = ranksum(Blue,Control_PAF);
