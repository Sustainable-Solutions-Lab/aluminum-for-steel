% Reproducibility edits (2026): see README.md, 'Changes from the original code'.

function figure4a_substitution_ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Samuel Faucher
% Fe/Al Substitution Ratio
% November 2024

% A. Pacini edits to make scatter points line up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% specify three colors
cols = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];

% initiate figure
figure('units','normalized','outerposition',[0 0 .3 .4]);
hold on
box on
grid on

% create two dashed and greyed rectangles
rectangle('Position',[.9 .29 .2 .69],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off')
rectangle('Position',[1.4 .29 .2 .69],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
rectangle('Position',[.895 .4 .21 .3],'FaceColor',[.8 .8 .8],'LineStyle','none','HandleVisibility','off')
rectangle('Position',[1.395 .4 .21 .3],'FaceColor',[.8 .8 .8],'LineStyle','none','HandleVisibility','off');
%yline(0.59,'Color',[.2 .2 .2])

% Data input for steel to cast Al rectangle
cast = [{'General'	0.5
'General'	0.52
'General'	0.6
'General'	0.65
'Body'	0.49
'Body'	0.55
'Body'	0.58
'Body'	0.62
'Body' 0.29
'Body' 0.98
'Chassis'	0.598
'Chassis'	0.83}];

% Go through input data to see if any points are close together on y-axis
% Define x location according to y distances
yvars = cell2mat(cast(:,2)); % y variables to loop through
xval = ones(1,length(yvars)); % x variable default (centered on 1)
index = [1:length(yvars)]; % index into the y variables
for i = 1:length(yvars) % loop through each data point
    vector_distances = yvars(i)-yvars; % see how far that data point is from all others
    vector_logical = abs(vector_distances) < .02; % if that data point is within 0.02 t/t, flag it
    if sum(vector_logical)>1 % when we have two or more points within 0.02 of each other
        index_subset = index(vector_logical); % find what data point number they are (i.e. index)
        if sum(vector_logical)==2 % if there are 2 data points within that threshold from each other
            xval(index_subset(1)) = .98; % put the first a little to the left
            xval(index_subset(2)) = 1.02; % put the second a little to the right
        elseif sum(vector_logical)==3 %if there are 3 data points within that threshold from each other
            xval(index_subset(1)) = .98; % put the first a little to the left
            xval(index_subset(2)) = 1; % put the second in the center
            xval(index_subset(3)) = 1.02; % put the third a little to the right
        end
    end
end

cast_xy = [cast,num2cell(xval')]; % add the newly-defined xvector to the cell array so it can be indexed like the y variables

names={'General','Body','Chassis'}; % the three unique names
%marks={'b*','r>','yo'}; % define the markers
xvals1 = [.95 1 1.05]; % designate 3 x values to scatter the points onto

% cycle through each name for steel to cast Al
for i=1:length(names)
    subset = cast_xy(strcmp(cast_xy(:, 1), names{i}), :);
    %x=ones(size(subset,1),1)-0.03+0.06*rand(size(subset,1),1);
    %x = xvals1(i);
    scatter(cell2mat(subset(:,3)), cell2mat(subset(:,2)), 100, 'filled','markerfacecolor',cols(i,:),'HandleVisibility','off');
    %plot(x, cell2mat(subset(:,2)), marks{i}, 'MarkerSize', 10, 'LineWidth', 3);
    hold on
end

grid on; 
hold on;
% Plot Red
set(gca,'ColorOrderIndex',1)

% Data input for steel to wrought Al rectangle
wrought = [{'General'	0.6
'General'	0.65
'General'	0.55
'General'	0.5
'General'	0.52
'Body'	0.555
'Body'	0.568
'Body'	0.582
'Body'	0.617
'Body'	0.476
'Body'	0.488
'Body'	0.698
'Body'	0.72
'Body' 0.29
'Body' 0.98
'Chassis'	0.765
'Chassis'	0.88
'Chassis'	0.535
'Chassis'	0.42}];


% Go through input data to see if any points are close together on y-axis
% Define x location according to y distances
yvars = cell2mat(wrought(:,2)); % y variables to loop through
xval = ones(1,length(yvars)).*1.5; % x variable default (centered on 1.5)
index = [1:length(yvars)]; % index into the y variables
for i = 1:length(yvars) % loop through each data point
    vector_distances = yvars(i)-yvars; % see how far that data point is from all others
    vector_logical = abs(vector_distances) < .02; % if that data point is within 0.02 t/t, flag it
    if sum(vector_logical)>1 % when we have two or more points within 0.02 of each other
        index_subset = index(vector_logical); % find what data point number they are (i.e. index)
        if sum(vector_logical)==2 % if there are 2 data points within that threshold from each other
            xval(index_subset(1)) = 1.48; % put the first a little to the left
            xval(index_subset(2)) = 1.52; % put the second a little to the right
        elseif sum(vector_logical)==3 %if there are 3 data points within that threshold from each other
            xval(index_subset(1)) = 1.48; % put the first a little to the left
            xval(index_subset(2)) = 1.5; % put the second in the center
            xval(index_subset(3)) = 1.52; % put the third a little to the right
        end
    end
end

wrought_xy = [wrought,num2cell(xval')];  % add the newly-defined xvector to the cell array so it can be indexed like the y variables
names={'General','Body','Chassis'}; % the three unique names
marks={'bo','ro','yo'}; % define the markers
xvals2 = [1.45 1.5 1.55]; % designate 3 x values to scatter the points onto

% cycle through each name for steel to wrought Al
for i=1:length(names)
    subset = wrought_xy(strcmp(wrought_xy(:, 1), names{i}), :);
    %x=1.5*ones(1,size(subset,1))-0.03+.06*rand(1,size(subset,1));
    %plot(x, cell2mat(subset(:,2)), marks{i}, 'MarkerSize', 10, 'LineWidth', 3);
    y = cell2mat(subset(:,2));
    %x = xvals2(i).*ones(length(y),1);
    scatter(cell2mat(subset(:,3)),y, 100, 'filled','markerfacecolor',cols(i,:));
    hold on
end
plot([10 11],[10 11],'LineWidth',10,'Color',[.8 .8 .8])
plot([.895 .895+.21],[.59 .59],'k','LineWidth',1.5)
plot([1.395 1.395+.21],[.59 .59],'k','LineWidth',1.5)

% Set up axes.
xlim([.7 2.2]);
ylim([.2, 1.001]);
ax = gca;
ax.XTick = [1, 1.5];
ax.XTickLabel = '';
ax.YTick = [0.2:0.2:1];
% make x-tick labels two line text stringgs
myLabels = {'Steel to','Steel to';...
    'cast Al','wrought Al'};

for i = 1:length(myLabels)
    xt=get(ax,'XTick'); yl=get(ax,'YLim'); % equivalent to ax.XTick(i), ax.YLim(1)
    text(xt(i),yl(1),sprintf('%s\n%s', myLabels{:,i}), ...
        'horizontalalignment', 'center', 'verticalalignment', 'top','fontsize',20);    
end
set(gca,'FontSize',20)

% label y axis, legend
ylabel('Substitution ratio (t/t)')
[~,objh]=legend({'General','Body','Chassis','Range','Median'},'location','east');
objhl = findobj(objh, 'type', 'patch');
set(objhl, 'Markersize', 12);
end
