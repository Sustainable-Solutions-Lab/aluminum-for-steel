% Samuel Faucher
% 27 October 2022

% Four futures

% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure4c_production_vs_electricity % with carbon cost, weighting, actual emissions, and matrix elasticity

elastarray=[.59,4,10]; % .59, 2, 10
fprintf('Figure 4c cross-price elasticities used: %s\n',mat2str(elastarray));
figure(1),clf

colors={[25,132,197],
    [194, 55, 40],
    [99, 191, 240],
    [222, 110, 86],
    [167, 213, 237],
    [225, 166, 146]};

for ii=1:length(elastarray)

xelast=elastarray(ii); %10; %2 %.59; % baseline % cross elasticity between Al and steel



prod0=[70,1500]; % current production Mt/yr metal
eta=0.59; % kg Al required/kg steel required
carboncost=0; % carbon price ($/t CO2)
k=20;  % baseline 10
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
for i=1:size(metaltots,1)
    metalavs(i,1)=mean(metaltots(i,:,1)); % Metal production only as a function of electricity cost (averaged over 
    metalavs(i,2)=mean(metaltots(i,:,2)); 
    metalprices(i,1)=mean(metalprice(i,:,1));
    metalprices(i,2)=mean(metalprice(i,:,2));
    metalprices(i,3)=metalprices(i,1)/metalprices(i,2);
end


plot(cost(:,1)*2.78,metalavs(:,1),'LineWidth',2,'Color',cell2mat(colors(ii*2-1))*1/256)
hold on
plot(cost(:,1)*2.78,metalavs(:,2),'LineWidth',2,'Color',cell2mat(colors(ii*2))*1/256)

end

xlabel('Electricity Cost ($/GJ)')
ylabel('Metal Production (Mt/y)')
lh=legend({'Aluminum','Steel'},'AutoUpdate','off','Location','East');
set(lh,'Edgecolor','none') %'Color',[1 1 1])
box on
set(gcf,'Position',[100 100 400 350])
set(gca,'FontSize',14)
xlim([0 30])
ylim([0 1700])

vq=interp1(metalprices(:,3),cost(:,1)*2.78,[3,4,5,6]);
for i=1:length(vq)
    xline(vq(i)) 
end
text(vq(1)+1,470,'Al/Steel Price Ratio = 3','rotation',90,'FontSize',12)
text(vq(2)+1,470,'Al/Steel Price Ratio = 4','rotation',90,'FontSize',12)
text(vq(3)+1,470,'Al/Steel Price Ratio = 5','rotation',90,'FontSize',12)
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

