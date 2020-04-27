function sparklines()
    close all;
    clc

    figPosition = [0 0 1 1];
    uigetfile = ('*.xlsx', 'Select File');

    data = readtable('FertilityExamplePOCHE.xlsx', 'PreserveVariableNames', true);
    yearRange = data.Properties.VariableNames;
    yearRange = yearRange(:,2:end);
    countries = table2cell(data(:,1));
    numCountries = numel(countries);
    dataMat = table2array(data(:, 2:end));
    numRange = size(dataMat,2);
    numCols = 4;
    numRows = floor(numRange/4);

    meanEveryNation = mean(dataMat);
    livelloDisostituzione = ones(size(meanEveryNation))*2.1;
    figSparks = figure('Name', 'With SparkLines',  'units','normalized','outerposition',figPosition);
    h = plot(dataMat');
    for nC = 1: numel(countries)
         addTip = dataTipTextRow('country',[repmat(string(countries{nC}),numel(yearRange),1) yearRange']);
         addTip(1).Label = 'Years';
         addTip(1).Value = yearRange; 
         addTip(2).Label = 'Feartility';

         h(nC).DataTipTemplate.DataTipRows(end+1) = addTip;
    end
    hold on; plot(meanEveryNation, 'k--', 'LineWidth', 1.5);
    hold on; plot(livelloDisostituzione, 'k.-', 'LineWidth', 1.5);
    ax = gca;
    ax.XTickLabelRotation = 0;
    set(ax,'XTick',1:numel(yearRange), 'XTickLabel', yearRange, 'fontsize', 6);


    fig = figure('Name', 'With SparkLines',  'units','normalized','outerposition',figPosition);

    developed = {'Spain','Germany','Italy','Japan', ...
        'United Kingdom', 'Sweden', 'France', 'Norway', 'Brazil'};
    notDev = {'India', 'Niger', 'Yemen'};
    observe = {'China'};
    countriesDev = cell(0); 
    countriesNotDev = cell(0); 
    countriesObserve = cell(0); 
    countriesImportanti = cell(0); 
    countriesDevM = [];
    countriesObsM = [];
    countriesNotDevM = [];
    nonImportanti = [];
    importanti = [];
    idxDev = 1;
    for nC = 1: numel(countries)
         if ~contains(cell2mat(developed),countries{nC}) && ...  
          ~contains(cell2mat(observe),countries{nC}) && ...  
          ~contains(cell2mat(notDev),countries{nC})
             nonImportanti = [nonImportanti; dataMat(nC,:)];
             color = [211,211,211]/255; 
             hold on; h = plot(dataMat(nC,:)','Color', color); 
             addTip = dataTipTextRow('country',repmat(string(countries{nC}),numel(yearRange),1));
            h(1).DataTipTemplate.DataTipRows(end+1) = addTip;
         else
             importanti=[];
             if numel(countriesImportanti) ==0  
                 countriesImportanti{1} = countries{nC};
             else; countriesImportanti{end+1} = countries{nC}; end
             if contains(cell2mat(developed),countries{nC}) 
               if numel(countriesDev) ==0; countriesDev(1) = {countries{nC}};
               else;    countriesDev(end+1) = {countries{nC}}; end
               countriesDevM = [countriesDevM; dataMat(nC,:)]; 
             elseif contains(cell2mat(observe),countries{nC})
                  if numel(countriesObserve) ==0;  countriesObserve(1) = {countries{nC}}; 
                  else; countriesObserve(end+1) = {countries{nC}}; end
               countriesObsM = [countriesObsM; dataMat(nC,:)]; 
             elseif contains(cell2mat(notDev),countries{nC})
                  if numel(countriesNotDev)==0; countriesNotDev(1) = {countries{nC}};
                 else; countriesNotDev(end+1) = {countries{nC}}; end
               countriesNotDevM = [countriesNotDevM; dataMat(nC,:)]; 
             end
         end
         % Gli importanti li plotto dop così stanno sopra i grigi!
    end
    % Apply the colors to the lines
    cmap = [141,211,199;
        255,255,179;
        190,186,218;
        251,128,114;
        128,177,211;
        253,180,98;
        179,222,105;
        252,205,229;
        217,217,217;
        188,128,189;
        204,235,197;
        255,237,111];
    cmap = cmap./255;
    set(gca, 'ColorOrder', cmap);
    idx = 1;
    for nC = 1: size(importanti,1)
        if contains(cell2mat(observe),countriesImportanti{nC}); color= 'r'; 
        else; color = cmap(idx, :); idx = idx+1; end
        hold on; h = plot(importanti(nC,:)', 'LineWidth', 1.5, 'Color', color); 
        text(1-0.35, importanti(nC,1)+0.05, countriesImportanti{nC}, 'FontSize',6);
        addTip = dataTipTextRow('country',repmat(string(countriesImportanti{nC}),numel(yearRange),1));
        h(1).DataTipTemplate.DataTipRows(end+1) = addTip;
    end

    hold on; plot(meanEveryNation, 'k--', 'LineWidth', 1.5);
    hold on; plot(livelloDisostituzione, 'k.-', 'LineWidth', 1.5);
    ax = gca;
    ax.XTickLabelRotation = 0;
    set(ax,'XTick',1:numel(yearRange), 'XTickLabel', yearRange, 'fontsize', 6);
    saveas(fig, 'PlotPerRange.jpg');


    cmap= [228,26,28
    55,126,184
    77,175,74]./255;

    figSimple = figure('Name', 'SimplestPlot',  'units','normalized','outerposition',figPosition);

    color = [211,211,211]/255; 
    Xs = [0.75 2.25];
    hold on; h = plot(Xs, [nonImportanti(:,1) nonImportanti(:,end)]','Color', color);
    %color = cmap(1,:)

    hold on; h = plot(Xs, [countriesObsM(:,1) countriesObsM(:,end)]', 'Color', cmap(1,:), 'LineWidth', 1); 
    hold on; h = plot(Xs, [countriesDevM(:,1) countriesDevM(:,end)]', 'Color', cmap(3,:), 'LineWidth', 1);  
    hold on; h = plot(Xs, [countriesNotDevM(:,1) countriesNotDevM(:,end)]', 'Color', cmap(2,:), 'LineWidth', 1);  

    hold on; plot([Xs(1) Xs(1)], [0 max(dataMat(:))], 'k'); 
    hold on; plot([Xs(2) Xs(2)], [0 max(dataMat(:))], 'k');

    hold on; plot(Xs, [meanEveryNation(1) meanEveryNation(end)], 'k--', 'LineWidth', 1);
    hold on; plot(Xs, [livelloDisostituzione(1) livelloDisostituzione(end)], 'k.-', 'LineWidth', 1);
    text(Xs(1)-0.05,meanEveryNation(1) , num2str(meanEveryNation(1)), 'fontsize', 4); 
    text(Xs(2)+0.05,meanEveryNation(end) , num2str(meanEveryNation(end)), 'fontsize', 4); 
    text(Xs(1)-0.05,livelloDisostituzione(1) , num2str(livelloDisostituzione(1)), 'fontsize', 4); 
    text(Xs(2)+0.05,livelloDisostituzione(end) , num2str(livelloDisostituzione(end)), 'fontsize', 4); 

    hold on; plot(Xs, [meanEveryNation(1) meanEveryNation(end)], 'k--', 'LineWidth', 1.5);
    hold on; plot(Xs, [livelloDisostituzione(1) livelloDisostituzione(end)] , 'k.-', 'LineWidth', 1.5);
    ax = gca;
    XLim = [0.5 2.5];
    % ax.XTickLabelRotation = 0;
    % ax.XTick = Xs;
    % ax.XTickLabel = [yearRange(1), yearRange(end)];
    ax.XLim = XLim;
    set(ax,'XTick',Xs, 'XTickLabel', [yearRange(1), yearRange(end)], 'fontsize', 6);
    saveas(figSimple, 'PlotPerRange.jpg');

end