% Samuel Faucher
% Orca Sciences
% March 2024

% FeAl paper -- Figure 2

% Data from FeAlCostsFinal

% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure2_costs_and_intensities

%% Energy vs Non-Energy Costs
costs=[1308.2	1416.5
1364.9	1336.2
164.5	459.0
127.6	451.7
333.4	497.7];

xx=[0:10:2500];
yy=xx;
for i=1:length(xx)
    for j=1:length(yy)
        summ(i,j)=xx(i)+yy(j);
    end
end

for i=1:length(xx)
    yl(i,1)=xx(i)*1/3;
    yl(i,2)=xx(i);
    yl(i,3)=xx(i)*3;
end


figure(1),clf
hold on
h=pcolor(xx,yy,summ);
set(h,'EdgeColor','none');
a=colorbar;
ylabel(a,'Total Metal Cost ($/t)') %,'Rotation',270);
hold on
%scatter(costs(:,1),costs(:,2),100,'filled')
plot(xx,yl(:,1),'-k','LineWidth',1)
plot(xx,yl(:,2),'k','LineWidth',1)
plot(xx,yl(:,3),'-k','LineWidth',1)

for i=1:5
    scatter(costs(i,1),costs(i,2),100,'filled','markeredgecolor','k')
end
legend({'','','','','Conv. Al','Inert Al','BF/BOF Steel','DRI/EAF Steel','HDR/EAF Steel'},'location','northeast','autoupdate','off')


xlabel('Energy Costs ($/t metal)')
ylabel('Non-Energy Costs ($/t metal)')
xlim([0 2200])
ylim([0 2200])
t1 = text(1000,270,'Energy = 75% of Total Cost','FontSize',10);
t1.Rotation=18;
t1 = text(500,420,'Energy = 50% of Total Cost','FontSize',10);
t1.Rotation=45;
t1 = text(400,1000,'Energy = 25% of Total Cost','FontSize',10);
t1.Rotation=72;
set(gcf,'Position',[100 100 400 350])
set(gca,'FontSize',14)
caxis([0 4000])

%% CO2 Intensity
clear
x=[0:1:100];
y=[0:.001:.15];

for i=1:length(x)
    for j=1:length(y)
        z(i,j)=x(i)*y(j);
    end
end

figure(2),clf
hold on
h=pcolor(x,y,z');
set(h,'EdgeColor','none');
a=colorbar;

xlabel('Energy Intensity (GJ/t Metal)')
ylabel('Carbon Intensity of Energy (t CO_2/GJ)')
ylabel(a,'Metal Carbon Intensity (t CO_2/t Metal)')

res=[90.236	0.088747648
68.436	0.1088
16.98	0.089194523
22.388	0.053262212
11.452	0.126273364
68.436	0.00574
11.452	0.006661848];

for i=1:7
    scatter(res(i,1),res(i,2),100,'filled','markeredgecolor','k')
end
legend({'','Conv. Al','Inert Al','BF/BOF Steel','DRI/EAF Steel','HDR/EAF Steel','Inert Al, Renew Elec','HDR/EAF Steel, Renew Elec'},'location','northoutside','autoupdate','off')
set(gcf,'Position',[100 100 400 450])
set(gca,'FontSize',14)
caxis([0 15])
colormap('jet');
end