% Samuel Faucher
% Orca Sciences
% November 2024

% Four futures

% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure3_abatement_costs % with carbon cost, weighting, actual emissions, and matrix elasticity

%% Metal cost versus electricity price
close all

cost=costfun(); % Elec price (cents/kWh, Conv Al $/t, Inert Al $/t BF $/t, DRI $/t, HDR $/t)
cost(:,1)=cost(:,1)*2.78; % Convert elec price to $/GJ
figure(1),clf
hold on
for i=2:6
    plot(cost(:,1),cost(:,i),'LineWidth',2)
end
ylim([0 5000])
xlabel('Electricity Cost ($/GJ)')
ylabel('Metal Cost ($/t)')
set(gca,'FontSize',14)
legend({'Conv. Al','Inert Al','BF-BOF Steel','DRI-EAF Steel','HDR-EAF Steel'},'location','northwest','fontsize',12)
set(gcf,'position',[100,100,350,350]) % x0, y0, height, width
box on

%% CO2 versus Electricity CO2 intensity
carbon=carbonfun();
carbon(:,1)=carbon(:,1)*.2778; % convert carbon intensity from kg/kWh to t/GJ
figure(2),clf
hold on
for i=2:6
    plot(carbon(:,1),carbon(:,i),'LineWidth',2)
end
xlabel('Electricity Carbon Intensity (t CO_2/GJ)')
ylabel('Metal Carbon Intensity (t CO_2/t Metal)')
set(gca,'FontSize',14)
legend({'Conv. Al','Inert Al','BF-BOF Steel','DRI-EAF Steel','HDR-EAF Steel'},'location','northwest','fontsize',12)
set(gcf,'position',[100,100,350,350]) % x0, y0, height, width
box on


%% Cost and CO2 for each of five pathways

prod0=[70,1500]; % current production Mt/yr metal
eta=0.59; % kg Al required/kg steel required
carboncost=0; % carbon price ($/t CO2)
k=20;  % baseline 10
xelast=2; %.59; % baseline % cross elasticity between Al and steel
elast=[-.2 xelast;xelast -.18];

res=zeros(size(cost,1),size(carbon,1),22); 
% 1-5 cost pathways $/t, 6-10 emissions density pathways t CO2/t metal, 
% 11-15 production pathways Mt/y, 16-20 total emissions pathways 1-5 Mt CO2/y

for i=1:size(res,1)
    for j=1:size(res,2)
        res(i,j,1:5)=cost(i,2:6)+carboncost.*carbon(j,2:6);
        res(i,j,6:10)=carbon(j,2:6);
    end
end
titles={'Conv. Al','Inert Al','BF-BOF Steel','DRI-EAF Steel','HDR-EAF Steel'};

figure(3),clf
for i=1:5
    subplot(3,2,i),h=pcolor(cost(:,1),carbon(:,1),res(:,:,i)');
    title(titles(i))
    set(h,'EdgeColor','none');
    colorbar
    %clim([0 5000])
    xlabel('Electricity Cost ($/GJ)')
    ylabel('Elec. CO_2 Int. (t CO_2/GJ)')
    sgtitle('Metal Cost ($/t Metal)')
end

figure(4),clf
for i=1:5
    subplot(3,2,i),h=pcolor(cost(:,1),carbon(:,1),res(:,:,i+5)');
    title(titles(i))
    set(h,'EdgeColor','none');
    colorbar
    %clim([0 8])
    xlabel('Electricity Cost ($/GJ)')
    ylabel('Elec. CO_2 Int. (t CO_2/GJ)')
    sgtitle('Metal Carbon Intensity (t CO_2/t Metal)')
end


%% Cost of CO2 emissions reductions ($/t CO2)



for i=1:size(cost,1)
    for j=1:size(carbon,1)
        delta(i,j,1)=res(i,j,2)-res(i,j,1); % Al cost difference ($/t)
        delta(i,j,2)=res(i,j,5)-(res(i,j,4)+res(i,j,3))/2; % Steel cost difference ($/t)
        delta(i,j,3)=res(i,j,7)-res(i,j,6); % Al CO2 difference (t CO2/t metal)
        delta(i,j,4)=res(i,j,10)-(res(i,j,9)+res(i,j,8))/2; % Steel CO2 difference (t CO2/t metal)
    end
end

figure(5),clf
titles2={'Al Cost \Delta, Elec - Conv ($/t)','Steel Cost \Delta, Elec - Conv ($/t)','Al CO_2 \Delta, Elec - Conv (t CO_2/t)','Steel CO_2 \Delta, Elec - Conv (t CO_2/t)'};
for i=1:4
    subplot(2,2,i),h=pcolor(cost(:,1),carbon(:,1),delta(:,:,i)');
    if i<2.5
        caxis([-400 900])
    else
        caxis([-4 2])
    end
    title(titles2(i))
    set(h,'EdgeColor','none');
    colorbar
    xlabel('Electricity Cost ($/GJ)')
    ylabel('Elec. CO_2 Int. (t CO_2/GJ)')
end

delta2=NaN([size(delta,1),size(delta,2),2]);
for i=1:size(delta,1)
    for j=1:size(delta,2)
        if delta(i,j,3)<0 % If Al electrification can achieve CO2 savings
            delta2(i,j,1)=-delta(i,j,1)/delta(i,j,3);
        end
        if delta(i,j,4)<0 % If steel electrification can achieve CO2 savings
            delta2(i,j,2)=-delta(i,j,2)/delta(i,j,4);
        end
    end
end

[past,fut]=overtime();

figure(6),clf
%colormap jet
subplot(1,2,1)
h=pcolor(cost(:,1),carbon(:,1),delta2(:,:,1)');
%alpha(h,0.5)
title('Abatement Cost - Aluminum')
set(h,'EdgeColor','none');
cb=colorbar('southoutside');
cb.Ticks = [-200 0 200 400 600 800 1000];
cb.TickLabels={'<0','0','200','400','600','800','1000'}
cb.Ruler.TickLabelRotation=0;
xlabel('Electricity Cost ($/GJ)')
ylabel('Carbon Intensity of Electricity (t CO_2/GJ)')
ylim([0 0.2])
caxis([-200 1000])
hold on
plot(past(:,2),past(:,3),'-','LineWidth',3,'Color',[.4 .4 .4])
inds=1:6:52;
scatter(past(inds,2),past(inds,3),200,'filled',"square",'MarkerFaceColor',[.4 .4 .4])
plot(fut(:,2),fut(:,3),'-','LineWidth',3,'Color',[0 0 0])
inds=1:6:30;
scatter(fut(inds,2),fut(inds,3),200,'filled',"square",'MarkerFaceColor',[0 0 0])%l=legend({'',['EIA US History' newline '(1973-2024)'],['EIA US Projection' newline '(2024-2050)']},'Location','North','AutoUpdate','off','EdgeColor','none')
set(gca,'FontSize',24,'LineWidth',2)
set(gca, 'layer', 'top');

subplot(1,2,2)
h=pcolor(cost(:,1),carbon(:,1),delta2(:,:,2)');
title('Abatement Cost - Steel')
set(h,'EdgeColor','none');
greys = [.85 .85 .85];
greys = repmat(greys,20,1);
colormap([greys;rdylbu(100)]) % rdylbu replaces third-party brewermap(100,'RdYlBu')
cb=colorbar('southoutside');
cb.Ticks = [-200 0 200 400 600 800 1000];
cb.TickLabels={'<0','0','200','400','600','800','1000'}
cb.Ruler.TickLabelRotation=0;
xlabel('Electricity Cost ($/GJ)')
ylabel('Carbon Intensity of Electricity (t CO_2/GJ)')
ylim([0 0.2])
caxis([-200 1000])
hold on
plot(past(:,2),past(:,3),'-','LineWidth',3,'Color',[.4 .4 .4])
inds=1:6:52;
scatter(past(inds,2),past(inds,3),200,'filled',"square",'MarkerFaceColor',[.4 .4 .4])
plot(fut(:,2),fut(:,3),'-','LineWidth',3,'Color',[0 0 0])
inds=1:6:30;
scatter(fut(inds,2),fut(inds,3),200,'filled',"square",'MarkerFaceColor',[0 0 0])
%l=legend({'',['EIA US History' newline '(1973-2024)'],['EIA US Projection' newline '(2024-2050)']},'Location','North','AutoUpdate','off','EdgeColor','none')
set(gcf,'position',[100,100,1200,650]) % x0, y0, height, width
set(gca,'FontSize',24,'LineWidth',2)
set(gca, 'layer', 'top');

% Find abatement cost in 2050 for aluminum and steel
iii=find(cost(:,1)>fut(1,2),1);
jjj=find(carbon(:,1)>fut(1,3),1);
al2050=delta2(iii,jjj,1);
steel2050=delta2(iii,jjj,2);
fprintf('2050 abatement cost (EIA projection: %.2f $/GJ, %.4f t CO2/GJ; nearest grid point above)\n',fut(1,2),fut(1,3));
fprintf('  Aluminum: %.1f $/t CO2\n  Steel:    %.1f $/t CO2\n',al2050,steel2050);

%% Predict $/t CO2 for each year
alltime=zeros(size(past,1)+size(fut,1),5); % was zeros(78,5): 52+27=79 rows caused a size-mismatch error
alltime(:,1:3)=[past(:,:);flipud(fut)];
alltime(:,4)=interp2(cost(:,1),carbon(:,1),delta2(:,:,1)',alltime(:,2),alltime(:,3)); % Interp from cost difference array
alltime(:,5)=interp2(cost(:,1),carbon(:,1),delta2(:,:,2)',alltime(:,2),alltime(:,3)); % Interp from cost difference array
end

function carbon=carbonfun()

esens=[1,0,0,0,0,0,1,0,0]; % Sensitivity of co2 to electricity co2 intensity

cost0=[5.5266048	7.4458368	0	0.1292544	0.6188544
1.515056	0	0.288834	1.12148	0
0	0	0	0	0
1.77363	0	0	0	0
0	0	1.724016	0	0
0	0	0	0	0
0	0	0	0	0.82722816
0	0	0	0	0
0	0	0	0	0]; % ($/t)

elec=.3917; % electricity co2 intensity (kg/kWh)
efactor=[0:.01:2.75]; %[.01:.01:2.75];

for i=1:length(efactor)
    res(i,1)=efactor(i)*elec; % price of electricity (cents/kWh)
    
    for j=1:5
        cost1(:,j)=cost0(:,j)+(efactor(i)-1)*esens(:).*cost0(:,j);
        res(i,j+1)=sum(cost1(:,j));
    end
end

carbon=res; % Carbon intensity of elec (kg CO2/kWh), emissions of 5 processes (kg CO2/kg metal)
end

function cost=costfun() % 

esens=[1,0,0,0,0,0,0.567,0,0]; % Sensitivity of cost to electricity price
esens=[1,0,0,0,0,0,1,0,0];


cost0=[1013.1	1364.9	0.0	23.7	113.4
140.3	0.0	26.8	103.9	0.0
163.7	163.7	0.0	0.0	0.0
154.8	0.0	0.0	0.0	0.0
0.0	0.0	137.8	0.0	0.0
0.0	0.0	174.3	174.3	174.3
0.0	0.0	0.0	0.0	220.0
920.1	839.8	116.4	109.1	155.2
332.7	332.7	168.3	168.3	168.3]; % ($/t)

elec=7.18; % electricity price (cents/kWh)
efactor=[.01:.01:3]; % multiplication factor

for i=1:length(efactor)
    res(i,1)=efactor(i)*elec; % price of electricity (cents/kWh)
    
    for j=1:5
        cost1(:,j)=cost0(:,j)+(efactor(i)-1)*esens(:).*cost0(:,j);
        res(i,j+1)=sum(cost1(:,j));
    end
end

cost=res; % First column elec cost (c/kWh), then metal costs ($/t)
end

function prod=prodfun(costs,k,elast,eta)

c=zeros(5);
for i=1:size(costs,1)
    for j=1:size(costs,2)
        
        c=costs(i,j,:);

% Calculate weights within each metal using k
alpossible=c(1:2); % Possible prices
steelpossible=c(3:5);
kk=k; % Logistic parameter

% Al weights
costdiff=alpossible/min(alpossible)-1;
weights1=0.5*exp(-kk.*costdiff); % not normalized weights
alweights=weights1/(sum(weights1));
% Steel weights
costdiff=steelpossible/min(steelpossible)-1;
weights1=0.5*exp(-kk.*costdiff); % not normalized weights
weights1(2:3)=weights1(2:3)*.5; % MULTIPLY DIRTY STEEL PATHWAYS BY 1/2
steelweights=weights1/(sum(weights1));
alprice=dot(alpossible,alweights);
steelprice=dot(steelpossible,steelweights);


% Calculate total aluminum and steel production using elast
demand0=[70 1500]; % Demand for Al, steel Mt/yr
pricerat0=[3.188,1]; %1430/534; % Price ratio at current demand
% NOTE I CHANGED THIS PRICERAT FROM MY OWN ESTIMATIONS TO AN ARBITRARY VALUE TO MAKE THE TOTAL STEEL/ALUMINUM DEMAND 
% BE ACCURATE AT CURRENT ELECTRICITY COST
pricerat1=alprice/steelprice;

%{
thresh=demand0(2)/demand0(1)*eta;
perchange(i)=(pricerat1-pricerat)/pricerat*100; % percent change
deltad(i)=elast*perchange(i); % change in aluminum demand (%)
if deltad(i)<-1
    deltad(i)=-1;
end
if deltad(i)>thresh
    deltad(i)=thresh;
end
deltad2(i)=demand0(1)*deltad(i); % change in aluminum demand (Mt/y)
demand1=[demand0(1)+deltad2(i)  demand0(2)-deltad2(i)/eta];
%}

demand1=demandcalc(demand0,pricerat0,pricerat1,elast,eta);

prod(i,j,1:5)=[reshape(demand1(1).*alweights,[1 2 1]) reshape(demand1(2).*steelweights,[1 3 1])];
    end
end


end



function Dout=demandcalc(D0nl,P0nl,pricerat,eps,eta)
%D0nl=[70; 1500]; % current demand non log
%P0nl=[1430; 534]; % current price non log
P=[pricerat,1]; % [1400;700];
D0=log(D0nl)';
P0=log(P0nl)';
P1=log(P)';
D1=D0+eps*(P1-P0);
D1nl=exp(D1); % Not normalized, not log
quant=[1/eta,1]; % equivalence to t steel equiv
% Normalize D1nl to Dout, given substitution ratio
Dout=D1nl'.*dot(D0nl',quant)./dot(D1nl',quant);
end






function [past,fut]=overtime() % year, elec price $/GJ, grid intensity t/GJ

% year, elec price $/GJ, carbon intensity kg/GJ
past=[1973	25.46077327	191.6457928
1974	29.98563218	185.7865972
1975	33.94284387	180.0176492
1976	33.6218512	184.0572698
1977	35.87389989	188.3571756
1978	37.34406953	182.0249251
1979	37.13096878	186.2276734
1980	39.04682443	188.1543784
1981	41.13540521	188.5447608
1982	45.05613126	184.4009614
1983	43.65378179	183.7281085
1984	40.42432628	183.6437621
1985	40.16569857	183.2191672
1986	39.11538169	181.1793645
1987	36.51331426	182.5249166
1988	34.54811214	181.3697542
1989	33.10026882	171.8605228
1990	31.53653405	166.931439
1991	30.83764684	164.87244
1992	29.93647541	165.6480802
1993	29.18670704	166.3461025
1994	27.98861336	165.9095568
1995	26.58962161	162.1100985
1996	25.49447631	163.7272884
1997	24.54338006	166.8608812
1998	23.9002045	167.774595
1999	23.12277411	165.384396
2000	23.43128146	168.4898507
2001	24.79613683	168.6008007
2002	23.58847508	164.4932745
2003	24.14984149	165.6019535
2004	24.16787983	164.1361531
2005	25.51312084	165.1577371
2006	26.57060185	160.9961449
2007	26.80481187	161.8754018
2008	28.1106162	159.8731372
2009	27.68405528	151.6429214
2010	26.99801504	152.8639755
2011	26.36518493	146.992373
2012	25.26251049	139.6291716
2013	25.7190347	140.0045165
2014	26.0798597	138.996777
2015	25.35185591	130.2049907
2016	24.49254952	123.9840629
2017	24.4073651	119.9515177
2018	23.96395428	117.210143
2019	23.16331061	108.7796116
2020	22.41064264	100.4626159
2021	23.04169588	104.9380619
2022	24.63215278	101.0163012
2023	22.94535609	94.34829659
2024	22.47222222	90.19715441];

fut=[2050	22.24057177	64.35173471
2049	22.45080402	64.62342377
2048	22.59621843	64.97106183
2047	22.67755078	65.13170084
2046	22.82539825	65.53479219
2045	22.96819227	65.88963621
2044	23.02345846	66.3949038
2043	23.03164349	66.85227845
2042	23.07488435	67.56621932
2041	23.06461046	68.01419647
2040	22.91182354	68.34730845
2039	22.726986	69.080028
2038	22.46818635	69.49777933
2037	22.16722245	69.88798023
2036	21.98431577	70.76701716
2035	21.84530224	72.65565635
2034	21.9028717	74.68494091
2033	21.79327937	77.62921026
2032	21.42976817	77.51050771
2031	21.41605008	78.72697251
2030	21.42402747	79.84529232
2029	21.47971911	81.53728715
2028	21.69906063	84.16515171
2027	22.10901877	84.65983888
2026	22.74459967	85.62967096
2025	23.65055528	87.08920123
2024	22.47222222	90.19715441];

%{
past(:,2)=past(:,2)*.36; % convert to cent/kWh
fut(:,2)=fut(:,2)*.36; % convert to cent/kWh
past(:,3)=past(:,3)*.0036; % convert to kg/kWh
fut(:,3)=fut(:,3)*.0036; % convert to kg/kWh
%}
past(:,3)=past(:,3)*.001;
fut(:,3)=fut(:,3)*.001;
end

