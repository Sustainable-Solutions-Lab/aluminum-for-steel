% Samuel Faucher
% Orca Sciences
% March 2024

% FeAl paper -- Figure 4

% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure4b_price_history

%% Substitution ratio plot

figure(1),clf
steel=[518+235+111;349+226+99;289+400+103;282+207+100;199+33+38];
al=[76+33;91+57;62+32;115+137;134+301];
scatter(steel,al,100,'Filled')
xlabel('Mass Steel (kg)')
ylabel('Mass Aluminum (kg)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gcf,'position',[100,100,350,350]) % x0, y0, height, width
box on
grid on
hold on
x=steel; y=al;
% Fit the range from 10 to 20 with a line.
coeffs = polyfit(x, y, 1)
% Define the range where we want the line
xFitting = 200:1000; % Or wherever...
yFitted = polyval(coeffs, xFitting);
% Plot the fitted line over the specified range.
hold on; % Don't blow away prior plot
plot(xFitting, yFitted, '-k', 'LineWidth', 1);
%legend('Original Data', 'Line Fit');
text(380,450,'\eta=0.59 kg Al/kg steel','FontSize',16)

%% Price history plot

data=[1990	659.3	3575.65367
1991	678.3	3401.193225
1992	559.7	2573.910383
1993	531.2	2556.992668
1994	621.3	2413.423904
1995	668.8	4132.02952
1996	521.7	3088.66213
1997	573.9	3000.317598
1998	507.5	2786.279888
1999	426.9	2238.234494
2000	488.5	2982.679324
2001	365.2	2797.141957
2002	346.2	2331.046997
2003	407.9	2292.442538
2004	564.4	2604.37005
2005	934.4	2874.746576
2006	720.9	3614.729293
2007	692.5	4127.557366
2008	796.8	3487.952806
2009	1010.3	2024.25533
2010	645.1	3127.007578
2011	673.5	3316.198751
2012	777.9	2864.946634
2013	706.7	2674.321846
2014	725.7	2231.0041
2015	583.4	2340.987571
2016	422.1	1886.815256
2017	578.7	2234.315583
2018	649.8	2690.601325
2019	758.9	2216.940249
2020	573.9	2094.677654
2021	1057.0	2261.209514
2022	1417.0	3140.505377
2023	716.0	2503.501163
2024	1081.0	2201.566522];

figure(2),clf
yyaxis left
plot(data(:,1),data(:,3),'-o','LineWidth',2,'MarkerSize',8,'Color',[0.8500, 0.3250, 0.0980])
hold on
plot(data(:,1),data(:,2),'-o','LineWidth',2,'MarkerSize',8,'Color',[0, 0.4470, 0.7410])
legend({'Aluminum','Steel'},'Location','northwest','autoupdate','off','location','northeast')
xlabel('Year')
ylabel('Metal Price ($/t)')
set(gca,'FontSize',14)
set(gcf,'position',[100,100,350,350])
xlim([1990 2024])
ylim([0 6000])

yyaxis right
plot(data(:,1),smooth5(data(:,3)./data(:,2)),'--','Color',[.4 .4 .4]) % smooth5 replaces Curve Fitting Toolbox smooth() (same default 5-point moving average)
ylabel('Al/Steel Price Ratio')
ylim([0 6.3])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [.4 .4 .4];
legend boxoff 
end