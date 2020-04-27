close all;
clc
figPosition = [0 0 1 1];
data = readtable('FertilityExample.xlsx', 'PreserveVariableNames', true);
yearRange = data.Properties.VariableNames;
yearRange = yearRange(:,2:end);
countries = table2cell(data(:,1));
numCountries = numel(countries);
dataMat = table2array(data(:, 2:end));
fig = figure('Name', 'Pie chart with Country legends', 'units','normalized','outerposition',figPosition);
numRange = size(dataMat,2);
numCols = 4;
numRows = floor(numRange/4);
idx = 1;
for nR = 1: numRange
    hold on; subplot(numRows, numCols, idx); pie(dataMat(:,nR), countries);
    idx = idx+1;
end
saveas(fig, 'PiechartsWithCountryLegends.jpg');

fig = figure('Name', 'Pie chart with year legends', 'units','normalized','outerposition',figPosition);
numRange = size(dataMat,2);
numCols = 4;
numRows = floor(numRange/4);
idx = 1;
% I MAY CHANGE LABELS
labs = cell(size(countries));
for nC = 1: numCountries
    labs{nC} = ' ';
end
idx = 1;
for nR = 1: numRange
    
    hold on; subplot(numRows, numCols, idx); pie(dataMat(:,nR),labs);
    title(yearRange{nR})
    idx = idx+1;
end
saveas(fig, 'PiechartsWithYearTitle.jpg');

% I MAY NOT USE LABELS LABELS
idx = 1;
for nR = 1: numRange
  
    hold on; subplot(numRows, numCols, idx); pie(dataMat(:,nR),labs);
    title(yearRange{nR})
    idx = idx+1;
end
saveas(fig, 'PiechartsWithYearTitle.jpg');

meanWorld = mean(dataMat);

figSparks = figure('Name', 'With SparkLines',  'units','normalized','outerposition',figPosition);
h = plot(dataMat); legend(yearRange);
saveas(figSparks, 'PlotPerRange.jpg');


