function timeseries = eyeTimeSeries()
    addpath("spiderplot");
    close all
    tab = readtable("EEG-Eye-State.csv", 'ReadRowNames', true, "ReadVariableNames", true);
    numPts = size(tab,1);
    labels = 1-tab.LABELS;
    tab.LABELS = [];
    features = tab.Properties.VariableNames;
    
    T = str2double(tab.Properties.RowNames);
    
    figure('Name', 'Open Each value all in time (LOG OPEN AND CLOSE)', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
    hold on; plot(T, log(table2array(tab)));
    legend(tab.Properties.VariableNames);
    
    figure('Name', 'Open Each value all in time (LOG OPEN AND CLOSE)', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
    hold on; boxplot(log(table2array(tab)), 'Notch', 'on', 'Labels', tab.Properties.VariableNames);
    legend();
  
    data = table2array(tab);
    
    mappaOutlier = isoutlier(data);

    dataMedian = data - repmat(median(data, 'omitnan'), numPts, 1);
    dataMedian(dataMedian ~=0) = dataMedian(dataMedian ~=0) ./ abs(dataMedian(dataMedian ~=0));
    data(mappaOutlier) = NaN;
    
    mappaOutlier = double(mappaOutlier) .* dataMedian;
    dataMedian = repmat(max(data,[], 'omitnan')+(max(data,[], 'omitnan')-min(data,[], 'omitnan'))*0.05, numPts,1);
    mappaOutlier(mappaOutlier>0) = dataMedian(mappaOutlier>0);
    dataMedian = repmat(min(data,[], 'omitnan')-(max(data,[], 'omitnan')-min(data,[], 'omitnan'))*0.05, numPts,1);
    mappaOutlier(mappaOutlier<0) = dataMedian(mappaOutlier<0);
    
    data(isnan(data))= mappaOutlier(isnan(data));
    
    %translate to zero
    data = data - repmat(min(data), numPts ,1); 
    
        
    figure('Name', 'Open Each value all in time (LOG OPEN AND CLOSE - removing outliers)', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
    hold on; plot(T(labels==0), log(data(labels==0, :)), 'r.');
    hold on; plot(T(labels==1), log(data(labels==1, :)), 'b.');
    legend(tab.Properties.VariableNames);
    
    
    featClose = features; for nv = 1: numel(featClose); featClose{nv} = [featClose{nv} '-close']; end
    featOpen = features; for nv = 1: numel(featOpen); featOpen{nv} = [featOpen{nv} '-open']; end
    step = 6; 
    figure('Name', 'Open Each value all in time (LOG OPEN AND CLOSE - removing outliers)', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
    hold on; boxplot(log(data(labels==0, :)),  'Notch', 'on','Widths',1, 'Positions', 1:step: numel(features)*step, 'Labels', featClose);
    hold on; boxplot(log(data(labels==1, :)), 'Notch', 'on', 'Widths', 1, 'Positions', 1+floor(step/3):step: numel(features)*step+floor(step/3), 'Labels', featOpen);

    
    
    
    transizioni01 = [find(diff(labels)>0)]';
    transizioni10 = [find(diff(labels)<0)]';
    
    if labels(1) == 1; transizioni01 = [0 transizioni01];
    else;  transizioni10 = [0 transizioni10]; end
    if labels(end) == 1; transizioni10 = [transizioni10 T(end)];
    else;   transizioni01 = [transizioni01 T(end)]; end

    ext1 = []; ext0 = [];
    while(numel(transizioni01)>0 && numel(transizioni10)>0)
        if (transizioni01(1)<transizioni10(1))
            ext1 = [ ext1; transizioni01(1)+1  transizioni10(1)];
             ext0 = [ ext0; transizioni10(1)+1  transizioni01(2)];
             transizioni01(1) = [];  transizioni10(1) = []; 
        else; ext0 = [ ext0; transizioni10(1)+1  transizioni01(1)];
             ext1 = [ ext1; transizioni01(1)+1  transizioni10(2)];
             transizioni01(1) = [];  transizioni10(1) = []; 
        end
    end
    ext1 = [ext1(:,1)  floor(sum(ext1,2)/2) ceil(sum(ext1,2)/2) ext1(:,end)];
    ext0 = [ext0(:,1)  floor(sum(ext0,2)/2) ceil(sum(ext0,2)/2) ext0(:,end)];
    
    data = data - repmat(min(data), numPts ,1); 
    figure('Name',  ['All Feats no log'] , 'units', 'Normalized', 'Position', [ 0.1 0.1 0.9 0.5]);
    hold on; plot(data, '.'); 
    colorCLa = [0.7350 0.2780 0.2840];
    colorCLb = [0.9500 0.5250 0.2980];
    colorOPa = [0.2 0.6470 0.9410];
    colorOPb = [0.5010 0.8450 0.98];
    nItSmooth = 21;
    for nv = 1:numel(features)
        figure('Name',  ['Open/close line plot of ' features{nv}] , 'units', 'Normalized', 'Position', [ 0.1 0.1 0.9 0.5]);
        feat = data(:,nv)';
        openACyc = zeros(1, size(ext1,1));  openBCyc = zeros(1, size(ext1,1));
        closeACyc = zeros(1, size(ext1,1));  closeBCyc = zeros(1, size(ext1,1));
        
        for next = 1:size(ext1,1)    
            TOPa = [ext1(next,1) ext1(next,1):ext1(next,2)]; 
            TOPb = [ext1(next,3):ext1(next,4) ext1(next,4) ];
            openA = [0 feat(TOPa(2:end))];
            openB = [feat(TOPb(1:end-1)) 0];
            
            openAA = openA(2:end);
            openBB = openB(1:end-1);
            if numel(openAA)<nItSmooth*3
               openAA(:) =  mean(openAA); openAA = openAA';
            else; for i = 1:nItSmooth; openAA =  smooth(openAA); end; end
            openAA = [0 openAA'];
            if numel(openBB)<nItSmooth*3
               openBB(:) =  mean(openBB); openBB = openBB';
            else; for i = 1:nItSmooth; openBB =  smooth(openBB); end; end
            openBB = [openBB' 0];
           
            TCLa = [ext0(next,1) ext0(next,1):ext0(next,2)]; 
            TCLb = [ext0(next,3):ext0(next,4) ext0(next,4) ]; 
            closeA = [0 feat(TCLa(2:end))];
            closeB = [feat(TCLb(1:end-1)) 0];           
           
            closeAA = closeA(2:end);
            closeBB = closeB(1:end-1);
            if numel(closeAA)<nItSmooth*3
               closeAA(:) =  mean(closeAA); closeAA = closeAA';
            else; for i = 1:nItSmooth; closeAA =  smooth(closeAA); end; end
            closeAA = [0 closeAA'];
            if numel(closeBB)<nItSmooth*3
               closeBB(:) =  mean(closeBB); closeBB = closeBB';
            else; for i = 1:nItSmooth; closeBB =  smooth(closeBB); end; end
            closeBB = [closeBB' 0];
           
   
            hold on; plot( TOPa, log(openA), 'Color', colorOPa);
            hold on; plot( TOPa, log(openAA), 'b-.', 'LineWidth', 1);
            hold on; plot( TOPb, log(openB), 'Color', colorOPb);
            hold on; plot( TOPb, log(openBB), 'b-.', 'LineWidth', 1);
            hold on; plot( TCLa, log(closeA), 'Color', colorCLa);
            hold on; plot( TCLa, log(closeAA), 'r-.', 'LineWidth', 1);
            hold on; plot( TCLb, log(closeB),  'Color', colorCLb);
            hold on; plot( TCLb, log(closeBB),  'r-.', 'LineWidth', 1);
            
            openACyc(next) =  mean(openA);
            openBCyc(next) = mean(openB);
            closeACyc(next) = mean(closeA);
            closeBCyc(next) = mean(closeB);
        end
        
        figure('Name', ['CyclePlot ' features{nv}], 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
        numTrans = size(ext1,1);
        plot(1:numTrans, openACyc, 'Color', colorOPa);
        hold on; plot(1:numTrans, repmat(mean(openACyc),1, numTrans), 'b');
        hold on; plot(numTrans+1:numTrans*2, openBCyc, 'Color', colorOPb);
        hold on; plot(numTrans+1:numTrans*2, repmat(mean(openBCyc),1, numTrans), 'b');
        hold on; plot(numTrans*2+1:numTrans*3, closeACyc, 'Color', colorCLa);
        hold on; plot(numTrans*2+1:numTrans*3, repmat(mean(closeACyc),1, numTrans), 'r');
        hold on; plot(numTrans*3+1:numTrans*4, closeBCyc, 'Color', colorCLb);
        hold on; plot(numTrans*3+1:numTrans*4, repmat(mean(closeBCyc),1, numTrans), 'r');
    end

    
    
    nLevels =10; nEls =15;
    for nv = 1:numel(features)
        figure('Name', ['Open/close ' features{nv}], 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.5]);
            dOOP = []; dCCL = [];
            dOP = []; dCL = [];
            feat = data(:,nv);  
            feat = feat-min(feat(:));
            Tradar ={};
            
            for idxExt = 1: size(ext1,1)
                disp(idxExt);
                extOP = ext1(idxExt,:); extCL = ext0(idxExt,:);            
                dOP = [dOP mean(feat(extOP(1):extOP(2))) mean(feat(extOP(3):extOP(4)))];
                dCL = [dCL mean(feat(extCL(1):extCL(2))) mean(feat(extCL(3):extCL(4)))];
                featOpen = feat(extOP(1):extOP(4)); featClose = feat(extCL(1):extCL(4));
                nopen = floor( numel(featOpen)/nEls );  nclose = floor( numel(featClose)/nEls ); 
                if mod(nopen,2) ==0; nopen = nopen -1; end
                if mod(nclose,2) ==0; nclose = nclose -1; end
                featOpen = medfilt1(featOpen,nopen); featClose = medfilt1(featClose,nclose);
                
                nopen = floor( numel(featOpen)/nEls );  nclose = floor( numel(featClose)/nEls ); 
                dOOP = [dOOP; featOpen(1:+nopen:nopen*nEls)']; dCCL = [dCCL; featClose(1:+nclose:nclose*nEls)'];
%                dOOP = [dOOP; medfilt1(featOpen, )]
                 Tradar = [Tradar, ['T_{' num2str(idxExt) 'a}'], ['T_{' num2str(idxExt) 'b}'] ];
            end
            P = round([dOP; dCL]);
            AxesLimits = P-P; 
            AxesLimits(1,:)= min(P(:)); 
            AxesLimits(2,:)= max(P(:)); 
            
            spider_plot(P, 'AxesLabels', Tradar,...
                            'AxesLimits', AxesLimits, ...
                            'FillOption', 'on',...
                            'AxesInterval', nLevels,...
                            'AxesDisplay', 'one', ...
                            'FillTransparency', 0.1);
            legend('open', 'close');
            
            AxesLimits = zeros(2, size(dOOP,2)); 
            AxesLimits(1,:)= min(min([dOOP; dCCL])); 
            AxesLimits(2,:)= max(max([dOOP; dCCL]));
            
            figure('Name', ['All Ranges Open split into ' num2str(nEls) ' blocks']);
            spider_plot(dOOP, ...
                            'AxesLimits', AxesLimits, ...
                            'FillOption', 'on',...
                            'AxesInterval', nLevels,...
                            'AxesDisplay', 'one', ...
                            'FillTransparency', 0.1);
            
            figure('Name', ['All Ranges Close split into ' num2str(nEls) ' blocks']);
            spider_plot(dCCL, ...
                            'AxesLimits', AxesLimits, ...
                            'FillOption', 'on',...
                            'AxesInterval', nLevels,...
                            'AxesDisplay', 'one', ...
                            'FillTransparency', 0.1);
            
            
            
            figure('Name', ['Open/close ' features{nv}], 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
            dOP = []; dCL = [];
            feat = data(:,nv);  
           
            feat = feat-min(feat(:));
            Tradar ={};
            minv = min(feat)/2;
            for idxExt = 1: size(ext1,1)
                extOP = ext1(idxExt,:); extCL = ext0(idxExt,:);   
                
                dOP = [dOP mean(feat(extOP(1):extOP(2))) mean(feat(extOP(3):extOP(4))) minv minv];
                dCL = [dCL minv minv mean(feat(extCL(1):extCL(2))) mean(feat(extCL(3):extCL(4)))];
               Tradar = [Tradar, ['T_{' num2str(idxExt) 'a}^{op}'], ['T_{' num2str(idxExt) 'b}^{op}'] ...
                             ['T_{' num2str(idxExt) 'a}^{cl}'], ['T_{' num2str(idxExt) 'b}^{cl}'] ];
            end
           
            P = round([dOP; dCL]);
            AxesLimits = P-P; 
            AxesLimits(1,:)= min(P(:)); 
            AxesLimits(2,:)= max(P(:)); 
            
            spider_plot(P, 'AxesLabels', Tradar,...
                            'AxesLimits', AxesLimits, ...
                            'FillOption', 'on',...
                            'AxesInterval', nLevels,...
                            'AxesDisplay', 'one', ...
                            'FillTransparency', 0.1);
            legend('open', 'close');
            
            
            
            
            
    end
   
    
    hold on; plot(t, table2array(data0(:, 2:end)));
    ax = gca();
    
    figure('Name', 'Open Each value all in time', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
    hold on; boxplot(data0);
    ax = gca();
  
    
    
    
    
    
    
    
    data0(isoutlier(data0)) = NaN;
    
    figure('Name', 'Open Each value all in time', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
    hold on; plot(Topen, log(data0));
    ax = gca();
    
    figure('Name', 'Open Each value all in time', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
    hold on; boxplot(data0, 'Notch', 'on');
    ax = gca();
    
        
  
    
    
    
    figure('Name', 'Open vs close', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
    hold on; plot(data0', 'r-');
    hold on; plot(close', 'k-');
    

    figure('Name', 'Open vs close', 'units', 'Normalized', 'Position', [ 0.1 0.1 0.8 0.8]);
    
    hold on; plot(log(data0'), 'r-');
    hold on; plot(log(close'), 'k-');
    

    
    
end