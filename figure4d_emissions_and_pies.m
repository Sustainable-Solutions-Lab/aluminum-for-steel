% Samuel Faucher
% October 2022
% Edited November 2024

% Four futures -- Figure 4d for paper

% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure4d_emissions_and_pies % with carbon cost, weighting, actual emissions, and matrix elasticity


%% Total carbon 

prod0=[70,1500]; % current production Mt/yr metal
eta=0.59; % kg Al required/kg steel required
carboncost=0; % carbon price ($/t CO2)
k=20;  % baseline 10
xelast=2; %.59; % baseline % cross elasticity between Al and steel


elast=[-.2 xelast;xelast -.18];
cost=costfun(); % El cost and cost of different pathways (no carbon cost yet)
carbon=carbonfun();

res=zeros(size(cost,1),size(carbon,1),22); 
% 1-5 cost pathways $/t, 6-10 emissions density pathways t CO2/t metal, 
% 11-15 production pathways Mt/y, 16-20 total emissions pathways 1-5 Mt CO2/y

for i=1:size(res,1)
    for j=1:size(res,2)
        res(i,j,1:5)=cost(i,2:6)+carboncost.*carbon(j,2:6);
        res(i,j,6:10)=carbon(j,2:6);
    end
end

prod=prodfun(res(:,:,1:5),k,elast,eta);
res(:,:,11:15)=prod;

res(:,:,16:20)=res(:,:,6:10).*res(:,:,11:15);
for i=1:size(res,1)
    for j=1:size(res,2)
        totalmetal(i,j)=prod(i,j,1)/eta+prod(i,j,2)/eta+prod(i,j,3)+prod(i,j,4)+prod(i,j,5);
        res(i,j,21)=sum(res(i,j,16:20));
        res(i,j,22)=res(i,j,21)/totalmetal(i,j);
        
        metaltots(i,j,:)=[res(i,j,11)+res(i,j,12),res(i,j,13)+res(i,j,14)+res(i,j,15)];
        metalprice(i,j,:)=[dot(res(i,j,11:12),res(i,j,1:2))/sum(res(i,j,11:12)),dot(res(i,j,13:15),res(i,j,3:5))/sum(res(i,j,13:15))];
        metalemits(i,j,:)=[dot(res(i,j,11:12),res(i,j,6:7))/sum(res(i,j,11:12)),dot(res(i,j,13:15),res(i,j,8:10))/sum(res(i,j,13:15))];
    end
end

%% Total emissions

figure(1),clf
imagesc(cost(:,1)*2.77777,carbon(:,1)*.27777,res(:,:,22)') % with conversion from c/kWh to $/GJ
set(gca,'YDir','normal')
colorbar
%caxis([0 15])
xlabel('Electricity Cost ($/GJ)')
ylabel('Carbon Intensity of Electricity (t CO_2/GJ)')
title('Total Emissions') % (t CO_2/t Steel Equivalent)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
caxis([0 2.5])
colormap jet 
box on
grid on
set(gcf,'position',[100,100,350,300]) % x0, y0, height, width

xlim([0 20])
xticks([-5 0 5 10 15 20])
ylim([0 0.2])
yticks([0,.05,0.1,0.15,0.2])

colormap(rdylbu(100)) % rdylbu replaces third-party brewermap(100,'RdYlBu')

%% Total production at sample points

inputs=[0,.391;5,.391;10,.391;15,.391;20,.391];
% Locations for 5 sample points -- (El cost $/kWh, CO2 int kg/kWh)

figure(2),clf
for k=1:size(inputs,1)
    input=inputs(k,:);
    i=find(cost(:,1)>input(1),1);
    j=find(carbon(:,1)>input(2),1);
    prods=reshape(res(i,j,11:15),[5 1]);
    prods2(k,:)=[prods(1) prods(2) prods(3)+prods(4) prods(5)];
    subplot(1,ceil(size(inputs,1)/1),k)
    x=categorical({'Conv. Al','Inert Al','BF-BOF Steel','DRI-EAF Steel','HDR-EAF Steel'});
    x=reordercats(x,{'Conv. Al','Inert Al','BF-BOF Steel','DRI-EAF Steel','HDR-EAF Steel'});
    b=bar(x,prods,'FaceColor','flat');
    b.CData=[0, 0.4470, 0.7410;0.8500, 0.3250, 0.0980;0.9290, 0.6940, 0.1250;0.4940, 0.1840, 0.5560;0.4660, 0.6740, 0.1880];
    title(num2str(k))
    ylim([0 totalmetal(1,1)])
    if k==1
        ylabel('Production (Mt/y)')
    end
    prods2(k,:)=[prods(1),prods(2),prods(3)+prods(4),prods(5)];
end
set(gcf,'position',[100,100,640,170]) % x0, y0, height, width

%% Pie charts at sample points

figure(3),clf
newColors=[0, 0.4470, 0.7410;0.8500, 0.3250, 0.0980;0.9290, 0.6940, 0.1250;0.4660, 0.6740, 0.1880];
% One pie per sample point (the original loop drew every pie on the same axes, so only the last survived).
% Slices: conventional Al, inert-anode Al, BF-BOF + DRI-EAF steel, HDR-EAF steel (production by mass, Mt/y).
% Sample points are in c/kWh as in the original 'inputs' array; $/GJ equivalents shown for reference.
for i=1:size(prods2,1)
    ax=subplot(1,size(prods2,1),i);
    p=pie(ax,prods2(i,:));
    delete(findobj(p,'Type','text'))%option 2
    colormap(ax,newColors);
    title(ax,sprintf('%g c/kWh (%.1f $/GJ)',inputs(i,1),inputs(i,1)*2.7778),'FontSize',10)
end
set(gcf,'position',[100,100,1000,260]) % x0, y0, width, height

%% Metal production versus electricity cost
for i=1:size(metaltots,1)
    metalavs(i,1)=mean(metaltots(i,:,1)); % Metal production only as a function of electricity cost (averaged over 
    metalavs(i,2)=mean(metaltots(i,:,2));
    
    metalprices(i,1)=mean(metalprice(i,:,1));
    metalprices(i,2)=mean(metalprice(i,:,2));
    metalprices(i,3)=metalprices(i,1)/metalprices(i,2);
end

figure(4),clf
t = tiledlayout(1,1);
ax1 = axes(t);
plot(ax1,cost(:,1),metalavs(:,1),'LineWidth',2)
hold on
plot(ax1,cost(:,1),metalavs(:,2),'LineWidth',2)
ax1.XColor = 'k';
ax1.YColor = 'k';
xlabel('Electricity Cost (¢/kWh)')
ylabel('Metal Production (Mt/y)')
legend({'Aluminum','Steel'},'AutoUpdate','off','Location','East')
grid on
ax2 = axes(t);
plot(ax2,metalprices(:,3),metalavs(:,1),'-w','LineWidth',.1)
set(gca,'YTick',[])
ax2.XAxisLocation = 'top';
ax2.YAxisLocation = 'right';
ax2.Color = 'none';
%ax1.Box = 'off';
ax2.Box = 'off';
xlim([metalprices(1,3),metalprices(size(metalprices,1),3)]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
xlabel('Al/Steel Price Ratio')
set(gcf,'position',[100,100,350,350]) % x0, y0, height, width
ax1.XTick=[0 10 20 30 40];
ax2.XTick=[2 3 4 5];
%ax1.xticklabels=['0','10','20','30','40'];
%}

%% Avoided emissions for steel and aluminum

emissionsave=zeros(size(res,1),size(res,2),2); % Al, steel
for i=1:size(res,1)
    for j=1:size(res,2)
        alsave=res(i,j,12).*(res(i,j,6)-res(i,j,7));
        stsave=res(i,j,15).*(res(i,j,9)-res(i,j,10));
        emissionsave(i,j,1)=alsave;
        emissionsave(i,j,2)=stsave;

        if alsave>0 && stsave>0
            emissionsave(i,j,3)=alsave/stsave;
        elseif alsave>0 && stsave<0 % al only
            emissionsave(i,j,3)=1e10;
        elseif alsave<0 && stsave>0 % st only
            emissionsave(i,j,3)=-2;
        else % neither
            emissionsave(i,j,3)=NaN;
        end

    end
end


figure(5),clf
for k=1:2
    subplot(1,2,k)
    imagesc(cost(:,1),carbon(:,1),emissionsave(:,:,k)')
    set(gca,'YDir','normal')
    colorbar
    %caxis([0 1500])
    xlabel('Electricity Cost (¢/kWh)')
    ylabel('Grid Emission Factor (kg CO_2/kWh)')
    caxis([0 inf])
end
subplot(1,2,1),title('Al Avoided Emiss. (Mt CO_2/year)')
subplot(1,2,2),title('Steel Avoided Emiss. (Mt CO_2/year)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gcf,'position',[400,100,750,350]) % x0, y0, height, width
%}


figure(6),clf
b=imagesc(cost(:,1),carbon(:,1),emissionsave(:,:,3)');
set(gca,'YDir','normal')
colorbar
%caxis([0 1500])
xlabel('Electricity Cost (¢/kWh)')
ylabel('Grid Emission Factor (kg CO_2/kWh)')
set(b,'AlphaData',~isnan(emissionsave(:,:,3)'))
caxis([.1 10])
set(gca,'ColorScale','log')
title('Avoided CO_2 (Green Al/Green Steel)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gcf,'position',[400,100,350,350]) % x0, y0, height, width
hold on
%jet0=jet(256);
%jet1=jet0(1:235,:);
colormap(jet);

%yl=95.65; yh=137.582; xl=0; xh=40;
%xx=[0 40]; yy=[yl yh-yl; yl yh-yl];


[past,fut]=overtime();
plot(past(:,2),past(:,3),'-o','LineWidth',2,'MarkerIndices',3:5:48,'MarkerSize',8,'Color',[.6 .6 .6])
plot(fut(:,2),fut(:,3),'-o','LineWidth',2,'MarkerIndices',5:5:30,'MarkerSize',10,'Color',[.3 .3 .3])
l=legend({'Past (1973-2021)','Projection (2021-2050)'},'Location','North','AutoUpdate','off','EdgeColor','none');


%yy=[96.65  96.65; 137.582 137.582];
%a=fill([xl xl xh xh],[yl yh yh yl],jet0(245,:));


% Text
[past,fut]=overtime();
plot(past(:,2),past(:,3),'-o','LineWidth',2,'MarkerIndices',3:5:48,'MarkerSize',8,'Color',[.6 .6 .6])
plot(fut(:,2),fut(:,3),'-o','LineWidth',2,'MarkerIndices',5:5:30,'MarkerSize',10,'Color',[.3 .3 .3])
%l=legend({'Past (1973-2021)','Projection (2021-2050)'},'Location','North','AutoUpdate','off','EdgeColor','none');

contour(cost(:,1),carbon(:,1),emissionsave(:,:,3)',[1 1],'--k','LineWidth',1)
contour(cost(:,1),carbon(:,1),emissionsave(:,:,3)',[1e6 1e6],'-k','LineWidth',1)
ylim([0 1])
%}

%% Four futures plot
% domain 1 = Al wins, Al emission intense
% domain 2 = Al wins, steel emission intense
% domain 3 = Steel wins, Al emission intense
% domain 4 = Steel wins, steel emission intense

domain=zeros(size(metaltots,1),size(metaltots,2));
for i=1:size(domain,1)
    for j=1:size(domain,2)
        if metaltots(i,j,1)<prod0(1); % If aluminum goes down
            domain(i,j)=domain(i,j)+2; % Steel wins
        end
        if metalemits(i,j,2)>eta*metalemits(i,j,1) % If steel is more emissions intensive
            domain(i,j)=domain(i,j)+1;
        end
    end
end

figure(10),clf, hold on;
cmap=[0.8941 0.1020 0.1098; 0.2157 0.4941 0.7216; 0.3020 0.6863 0.2902; 0.5961 0.3059 0.6392]; % fixed palette replaces third-party linspecer(4)
for i = 1:length(unique(domain))
s(i)=plot([25 26],[25 26],'color',cmap(i,:),'linewidth',10);
end
i1=imagesc(cost(:,1),carbon(:,1),domain');
set(gca,'YDir','normal')
xlabel('Electricity Cost ($/GJ)')
ylabel('Grid Emission Factor (kg CO_2/GJ)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gcf,'position',[100,100,350,400]) % x0, y0, height, width
colormap(cmap);
legend({['Al Production' char(8593) ', Steel is Lower-Carbon'],['Al Production' char(8593) ', Al is Lower-Carbon'],['Al Production' char(8595) ', Steel is Lower-Carbon'],['Al Production' char(8595) ', Al is Lower-Carbon']},'AutoUpdate','off','Location','northoutside')
xlim([min(cost(:,1)) max(cost(:,1))])
ylim([min(carbon(:,1)) max(carbon(:,1))])
%colormap(parula(4))
%colorbar
%legend({'1','2','3','4'})
xline(15,'--k','LineWidth',1.5)
yline(108.8,':k','LineWidth',2.5)
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
efactor=[.01:.01:2.75];

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






function [past,fut]=overtime() % year, elec price c/kWh, grid intensity kg/kwh

% year, elec price $/GJ, carbon intensity kg/GJ
past=[1973	22.03835085	191.9905333
1974	25.95498084	186.102982
1975	29.38026642	180.3092255
1976	29.1024214	184.3478656
1977	31.05175101	188.6341862
1978	32.3243013	182.2762523
1979	32.13984542	186.5005602
1980	33.79817287	188.4145115
1981	35.60600782	188.8044825
1982	38.99971215	184.6610501
1983	37.78586568	183.9795003
1984	34.99051171	183.8840133
1985	34.7666486	183.4536672
1986	33.8575147	181.4096252
1987	31.60521567	182.7492381
1988	29.90417488	181.5817655
1989	28.65094982	179.0360109
1990	27.29741137	174.785479
1991	26.69246818	172.6364327
1992	25.91243169	174.0879777
1993	25.26344675	174.7234915
1994	24.22640013	174.4392728
1995	23.01546005	170.192546
1996	22.06752355	171.7062208
1997	21.2442731	175.0199125
1998	20.68755283	175.6785048
1999	20.01462418	173.1067775
2000	20.28166215	176.1129917
2001	21.46305446	175.9753573
2002	20.4177259	171.6092093
2003	20.90363376	172.8125587
2004	20.9192474	171.1265738
2005	22.08366189	171.6431336
2006	22.99899691	167.4484359
2007	23.20172455	167.9942718
2008	24.33200342	165.7075046
2009	23.96278057	157.2349881
2010	23.36895746	158.7391179
2011	22.82119202	152.649701
2012	21.86673844	145.2786932
2013	22.26189693	145.8234748
2014	22.57422004	144.5257302
2015	21.9440741	135.4627083
2016	21.20027518	129.001558
2017	21.1265412	124.8013128
2018	20.7427334	121.8774348
2019	20.04971179	113.2265305
2020	19.39821702	104.5323244
2021	20.16666667	108.8206244];

fut=[2050	18.553787	64.35173471
2049	18.667366	64.62342377
2048	18.726257	64.97106183
2047	18.7451	65.13170084
2046	18.805063	65.53479219
2045	18.866459	65.88963621
2044	18.929935	66.3949038
2043	19.08062	66.85227845
2042	19.18539	67.56621932
2041	19.25886	68.01419647
2040	19.334475	68.34730845
2039	19.374485	69.080028
2038	19.411087	69.49777933
2037	19.516327	69.88798023
2036	19.657364	70.76701716
2035	19.709749	72.65565635
2034	19.875496	74.68494091
2033	19.859049	77.62921026
2032	19.816956	77.51050771
2031	19.792736	78.72697251
2030	19.778036	79.84529232
2029	19.746979	81.53728715
2028	19.723906	84.16515171
2027	19.638336	84.65983888
2026	19.646685	85.62967096
2025	19.872137	87.08920123
2024	20.10659	90.65237361
2023	20.806637	100.1869793
2022	21.733944	104.0977921
2021	21.928907	108.9532154];

past(:,2)=past(:,2)*.36; % convert to cent/kWh
fut(:,2)=fut(:,2)*.36; % convert to cent/kWh
past(:,3)=past(:,3)*.0036; % convert to kg/kWh
fut(:,3)=fut(:,3)*.0036; % convert to kg/kWh
end

