function sparklines()

% BMC BioInformatics https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-018-2302-3
% IEEE Access https://ieeexplore.ieee.org/document/8981975
    close all;
    clc

    figPosition = [0 0 1 1];
    fn = uigetfile('*.xlsx', 'Select File');

    data = readtable(fn, 'PreserveVariableNames', true, 'ReadRowNames', true);
    yearRange = data.Properties.VariableNames;
    countries = data.Properties.RowNames;
    dataMat = table2array(data);
  
    meanWorld = mean(dataMat);
    livelloDisostituzione = ones(size(meanWorld))*2.1;
    figSparks = figure('Name', 'With SparkLines',  'units','normalized','outerposition',figPosition);
    h = plot(dataMat');
    for nC = 1: numel(countries)
    %     hold on; h = plot(dataMat(nC,:));
         addTipCountry = dataTipTextRow('country',repmat(string(countries{nC}),numel(yearRange),1));
         addTipYear = dataTipTextRow('years',yearRange');
         h(nC).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
         h(nC).DataTipTemplate.DataTipRows(1,2) = addTipYear;
         h(nC).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
         h(nC).DataTipTemplate.DataTipRows(1,3).Value = dataMat(nC,:);
    end
    hold on; h2 = plot(meanWorld, 'k--', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'World'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    h2(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    h2(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    h2(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    h2(1).DataTipTemplate.DataTipRows(1,3).Value = meanWorld;
    
    hold on; hSub = plot(livelloDisostituzione, 'k.-', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'Substitution Level'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    hSub(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    hSub(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    hSub(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    hSub(1).DataTipTemplate.DataTipRows(1,3).Value = livelloDisostituzione;
    ax = gca;
    ax.XTickLabelRotation = 0;
    set(ax,'XTick',1:numel(yearRange), 'XTickLabel', yearRange, 'fontsize', 6);
    saveas(figSparks, 'Artistic.jpg');

    
    
    figSparksColored = figure('Name', 'Class-Colored SparkLines',  'units','normalized','outerposition',figPosition);
    colors = [201,148,199;  %China
                255,255,179;  %Italy
                255,237,160;  % Europe
               199,233,192;  %Oceania
                252,187,161;  % Africa
                208,209,230;  % Asia
            254,178,76;   % America
            ];
    classes = {'China', 'Italy', 'Europe', 'Oceania', 'Africa', 'Asia', 'America' };
    
    h = plot(dataMat', 'Color', [240,240,240]/255, 'LineWidth', 2);
    for nC = 1: numel(countries)
        index = 0; flag = false;
        while ~flag && index<numel(classes); index = index+1; flag = contains(countries{nC}, classes{index}); end 
        disp( [countries{nC} ' - color = ' num2str(colors(index, :))]);
        if strcmpi(countries{nC}, 'Italy'); h(nC).LineStyle = '-.'; end
         h(nC).Color = colors(index, :)/255;
         addTipCountry = dataTipTextRow('country',repmat(string(countries{nC}),numel(yearRange),1));
         addTipYear = dataTipTextRow('years',yearRange');
         h(nC).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
         h(nC).DataTipTemplate.DataTipRows(1,2) = addTipYear;
         h(nC).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
         h(nC).DataTipTemplate.DataTipRows(1,3).Value = dataMat(nC,:);
    end
    hold on; h2 = plot(meanWorld, 'k--', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'World'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    h2(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    h2(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    h2(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    h2(1).DataTipTemplate.DataTipRows(1,3).Value = meanWorld;
    
    hold on; hSub = plot(livelloDisostituzione, 'k.-', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'Substitution Level'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    hSub(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    hSub(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    hSub(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    hSub(1).DataTipTemplate.DataTipRows(1,3).Value = livelloDisostituzione;
    ax = gca;
    ax.XTickLabelRotation = 0;
    set(ax,'XTick',1:numel(yearRange), 'XTickLabel', yearRange, 'fontsize', 6);

    
    
    % E SE VOLESSI CONFRONTARMI ALL'ITALIA ?????
   
    figSparksColored = figure('Name', 'w.r.t. Italy',  'units','normalized','outerposition',figPosition);
    colors = [201,148,199;  %China
                255,255,179;  %Italy
                255,237,160;  % Europe
               199,233,192;  %Oceania
                252,187,161;  % Africa
                208,209,230;  % Asia
            254,178,76;   % America
            ];
    classes = {'China', 'Italy', 'Europe', 'Oceania', 'Africa', 'Asia', 'America' };
    dataMatIT = dataMat-repmat(dataMat(strcmpi(countries, 'Italy'),:), numel(countries), 1);
     meanWorldIT = mean(dataMat)-dataMat(strcmpi(countries, 'Italy'),:);
    livelloDisostituzioneIT = ones(size(meanWorld))*2.1-dataMat(strcmpi(countries, 'Italy'),:);
    h = plot(dataMatIT', 'Color',[240,240,240]/255, 'LineWidth', 2);
    for nC = 1: numel(countries)
        index = 0; flag = false;
        while ~flag && index<numel(classes); index = index+1; flag = contains(countries{nC}, classes{index}); end 
        disp( [countries{nC} ' - color = ' num2str(colors(index, :))]);
        if strcmpi(countries{nC}, 'Italy') 
            h(nC).LineStyle = ':'; h(nC).Color = [0.2 0.2 0.2]; 
         else; h(nC).Color = colors(index, :)/255; end
         addTipCountry = dataTipTextRow('country',repmat(string(countries{nC}),numel(yearRange),1));
         addTipYear = dataTipTextRow('years',yearRange');
         h(nC).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
         h(nC).DataTipTemplate.DataTipRows(1,2) = addTipYear;
         h(nC).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
         h(nC).DataTipTemplate.DataTipRows(1,3).Value = dataMatIT(nC,:);
    end
    hold on; h2 = plot(meanWorldIT, 'k--', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'World'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    h2(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    h2(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    h2(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    h2(1).DataTipTemplate.DataTipRows(1,3).Value = meanWorldIT;
    
    hold on; hSub = plot(livelloDisostituzioneIT, 'k.-', 'LineWidth', 1.5);
    addTipCountry = dataTipTextRow('country',repmat({'Substitution Level'},numel(yearRange),1));
    addTipYear = dataTipTextRow('years',yearRange');
    hSub(1).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
    hSub(1).DataTipTemplate.DataTipRows(1,2) = addTipYear;
    hSub(1).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
    hSub(1).DataTipTemplate.DataTipRows(1,3).Value = livelloDisostituzioneIT;
    ax = gca;
    ax.XTickLabelRotation = 0;
    set(ax,'XTick',1:numel(yearRange), 'XTickLabel', yearRange, 'fontsize', 6);

    
    
    
    developed = {'America - Northern' ,'America - United States of', 'Europe - Eastern', 'Europe - Northern', ...                 }
    'Europe - Southern', 'Europe - Western', 'Oceania'}; 
    observe = {'China'};
    special = {'Italy'};
    
    % Apply the colors to the lines
    cmap= [228,26,28
    55,126,184
    77,175,74]./255;

    figSimple = figure('Name', 'SimplestPlot',  'units','normalized','outerposition',figPosition);

    color = [211,211,211]/255; 
    Xs = [0.75 2.25];
    idxNotImp = find(~(contains(countries, developed) | contains(countries, special) | contains(countries, observe)));
    hold on; h = plot(Xs, [dataMat(idxNotImp ,1) dataMat(idxNotImp ,end)]','Color', color);
    for nC = 1: numel(idxNotImp)
         addTipCountry = dataTipTextRow('country',repmat(string(countries{idxNotImp(nC)}),numel(yearRange),1));
         addTipYear = dataTipTextRow('years',yearRange');
         h(nC).DataTipTemplate.DataTipRows(1,1) = addTipCountry;         
         h(nC).DataTipTemplate.DataTipRows(1,2) = addTipYear;
         h(nC).DataTipTemplate.DataTipRows(1,3).Label = 'Fertility';
         h(nC).DataTipTemplate.DataTipRows(1,3).Value = [dataMat(idxNotImp(nC),1) dataMat(idxNotImp(nC),end)];
    end
    idxDev = contains(countries, developed);
    hold on; h = plot(Xs, [dataMat(idxDev ,1) dataMat(idxDev ,end)]', 'Color', cmap(1,:), 'LineWidth', 1); 
    idxObs = contains(countries, observe);
    hold on; h = plot(Xs, [dataMat(idxObs ,1) dataMat(idxObs ,end)]', 'Color', cmap(3,:), 'LineWidth', 1);  
    hold on; h = plot(Xs, [dataMat(contains(countries, special) ,1) dataMat(contains(countries, special) ,end)]', 'Color', cmap(2,:), 'LineWidth', 1);  

    hold on; plot([Xs(1) Xs(1)], [0 max(dataMat(:))], 'k'); 
    hold on; plot([Xs(2) Xs(2)], [0 max(dataMat(:))], 'k');

    hold on; plot(Xs, [meanWorld(1) meanWorld(end)], 'k--', 'LineWidth', 1);
    hold on; plot(Xs, [livelloDisostituzione(1) livelloDisostituzione(end)], 'k.-', 'LineWidth', 1);
    text(Xs(1)-0.05,meanWorld(1) , num2str(meanWorld(1)), 'fontsize', 4); 
    text(Xs(2)+0.05,meanWorld(end) , num2str(meanWorld(end)), 'fontsize', 4); 
    text(Xs(1)-0.05,livelloDisostituzione(1) , num2str(livelloDisostituzione(1)), 'fontsize', 4); 
    text(Xs(2)+0.05,livelloDisostituzione(end) , num2str(livelloDisostituzione(end)), 'fontsize', 4); 

    hold on; plot(Xs, [meanWorld(1) meanWorld(end)], 'k--', 'LineWidth', 1.5);
    hold on; plot(Xs, [livelloDisostituzione(1) livelloDisostituzione(end)] , 'k.-', 'LineWidth', 1.5);
    ax = gca;
    XLim = [0.5 2.5];
   
    ax.XLim = XLim;
    set(ax,'XTick',Xs, 'XTickLabel', [yearRange(1), yearRange(end)], 'fontsize', 6);
    saveas(figSimple, 'PlotPerRange.jpg');
    
    
    % QUALCUNO CHIEDEVA I BOXPLOTS??
% ? boxplot includono il 50% delle osservazioni;
% ? il bordo inferiore delle scatole corrisponde al 25° percentile o primo quartile (Q1);
% ? la linea interna alle scatole corrisponde alla mediana ovvero al 50° percentile o secondo quartile (Q2);
% ? il bordo superiore delle scatole corrisponde al 75° percentile o terzo quartile (Q3);
% ? i baffi (whiskers) corrispondono al valore minimo (baffo inferiore) e al valore massimo (baffo superiore) osservati;
% ? la differenza interquartile [2] viene definita come IQR = Q3 – Q1 ovvero come differenza tra il valore corrispondente al terzo quartile (Q3) e il valore corrispondente al primi quartile (Q1);
% ? i valori inferiori a Q2 - 1.5 · IQR e i valori superiori a Q2 + 1.5 · IQR sono considerati outliers (dati anomali o dati aberranti) e sono riportati come punti singoli separati.
    
    figSimple = figure('Name', 'BoxPlots',  'units','normalized','outerposition',figPosition);
    boxplot(dataMat')
    ax = gca;
    set(ax, 'XTickLabel', countries, 'fontsize', 6, 'XTickLabelRotation', 90);
    
    
end