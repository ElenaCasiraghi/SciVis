function CategoricalData()
close all
    tab = readtable("bank-elena.xlsx", "Sheet","bank-originale", 'ReadRowNames', true, "ReadVariableNames", true);
    job = categorical(tab.job);
    labels = categorical(tab.y);
    classes = categories(labels);
    jobs = categories(job);
    
    [hjobs, edges] = histcounts(job);
    [hjobs1] = histcounts(job(labels==classes{1},:), edges);
    [hjobs2] = histcounts(job(labels==classes{2},:), edges);
    
    [pjobs, idx] =  sort(hjobs, 'descend');
    hjobs1 = hjobs1(idx);
    hjobs2 = hjobs2(idx);
    jobs = jobs(idx);
    
    pjobs = pjobs/sum(pjobs);
    pjobs1 =  hjobs1/(sum(hjobs1)+sum(hjobs2));
    pjobs2 =  hjobs2/(sum(hjobs1)+sum(hjobs2));
    figure; b = bar([pjobs' pjobs1' pjobs2'], 'grouped', 'BarWidth', 0.3);
    cols = [[179,205,227]; ...
             [204,235,197]; ...
             [251,180,174]]/255;


    for bidx = 1:3; b(1,bidx).FaceColor =  cols(bidx,:); end
    ax = gca();
    ax.XTickLabel = jobs;
    ax.XTickLabelRotation = 45;
    
    
    hold on; plot(0.75:+1:numel(jobs), cumsum(pjobs), 'Color', cols(1,:), 'LineWidth', 2);
    hold on; plot(1:+1:numel(jobs), cumsum(pjobs1), 'Color', cols(2,:), 'LineWidth', 2);
    hold on; plot(1.25:+1:numel(jobs)+0.5, cumsum(pjobs2), 'Color', cols(3,:), 'LineWidth', 2);
    
    legend({'all', classes{1}, classes{2}, 'cumulative all', ['cumulative ' classes{1}], ['cumulative ' classes{2}]});
    
    idxG = pjobs<0.05 & ~strcmpi(jobs', 'unemployed');
    jobsG = [jobs(~idxG); 'other'];
    
    
    pjobs = [pjobs(~idxG) sum(pjobs(idxG))];
    pjobs1 = [pjobs1(~idxG) sum(pjobs1(idxG))];
    pjobs2 = [pjobs2(~idxG) sum(pjobs2(idxG))];
    jobs = jobsG;
    
    [pjobs, idx] =  sort(pjobs, 'descend');
    pjobs1 = pjobs1(idx);
    pjobs2 = pjobs2(idx);
    jobs = jobs(idx);
 
    figure; b = bar([pjobs' pjobs1' pjobs2'], 'grouped', 'BarWidth', 0.3);
    cols = [[179,205,227]; ...
             [204,235,197]; ...
             [251,180,174]]/255;
    cols = [cols [0.7; 0.7; 0.7]];

    for bidx = 1:3; b(1,bidx).FaceColor =  cols(bidx,1:3); end
    ax = gca();
    ax.XTickLabel = jobs;
    ax.XTickLabelRotation = 45;
    
    
    hold on; plot(0.75:+1:numel(jobs), cumsum(pjobs), 'Color', cols(1,:), 'LineWidth', 2);
    hold on; plot(1:+1:numel(jobs), cumsum(pjobs1), 'Color', cols(2,:), 'LineWidth', 2);
    hold on; plot(1.25:+1:numel(jobs)+0.5, cumsum(pjobs2), 'Color', cols(3,:), 'LineWidth', 2);
    
    legend({'all', classes{1}, classes{2}, 'cumulative all', ['cumulative ' classes{1}], ['cumulative ' classes{2}]});
    
    catVars = [categorical(tab.job) categorical(tab.marital) categorical(tab.housing) categorical(tab.education) categorical(tab.y)];
    catVarsN = [double(categorical(tab.job)) double(categorical(tab.marital)) double(categorical(tab.housing)) ...
        double(categorical(tab.education)) double(categorical(tab.y))];
    
    numVars = size(catVarsN,2); numPts = size(catVarsN,1);
    for idxCol = 1:numVars
        h1 = histcounts(catVars(labels==classes{1},idxCol)); h2 = histcounts(catVars(labels==classes{2},idxCol));
        factor = max(h1)+max(h2)+max(max([h2;h1]))*2;
     %   catVarsN(:,idxCol) = catVarsN(:,idxCol)*factor;
        cats(idxCol).names = unique(catVars(:, idxCol));
        els1 = catVarsN(labels==classes{1},idxCol);
        els2 = catVarsN(labels==classes{2},idxCol);
    %     idxH = els1/factor;
    %     for i = 1: size(els1,1)
    %         els1(i) = els1(i)-h1(idxH(i));
    %         h1(idxH(i))=h1(idxH(i))-1;
    %     end

      %  els1
         cats(idxCol).start1 = [];
         cats(idxCol).start2 = [];
        elsR1 = els1-els1; elsR2= els2-els2;
        for i = min(catVarsN(:,idxCol)): max(catVarsN(:,idxCol))
            num1 = sum(els1==i); num2 = sum(els2==i);
            if num1>0; elsR1(els1==i) = repmat((i-1)*factor,num1,1) + [1:num1]'; 
                cats(idxCol).start1(i,:) = [min(elsR1(els1==i))   max(elsR1(els1==i))]; 
            else; cats(idxCol).start1(i,:) = NaN(1,2); end 
            if num2>0; elsR2(els2==i) = repmat((i-1)*factor,num2,1)+num1+max(max([h2;h1])) + [1:num2]'; 
                cats(idxCol).start2(i,:) = [min(elsR2(els2==i)) max(elsR2(els2==i))];
            else; cats(idxCol).start2(i,:) = NaN(1,2); end
        end
        catVarsN(labels==classes{1}, idxCol) =elsR1; 
        catVarsN(labels==classes{2}, idxCol) = elsR2;
        
    end
   % cats(numVars).names = classes;
    catVarsN(labels==classes{1}, end) = max(max(catVarsN(:,1:end-1)));
    
    catVarsN(labels==classes{1}, end) = max(max(catVarsN(:,1:end-1)))/3;
%     
%     idxH = els2/factor;
%     for i = 1: size(els2,1)
%         els2(i) = els2(i)-factor+h2(idxH(i));
%         h2(idxH(i))=h2(idxH(i))-1;
%     end
%     
    
%     cats(2).names = categories(categorical(tab.marital));
%     cats(3).names  = categories(categorical(tab.housing));
%     cats(4).names  = categories(categorical(tab.education));
%     cats(5).names = categories(categorical(tab.y));
    
    
    figure('Name', 'Slope graphs', 'units', 'normalized', 'Position', [0.05 0.05 0.8 0.6]); 
    hold on; plot1 = plot(0:5:numVars*5-1, catVarsN(labels==classes{1},:), 'Color', cols(2,:),'LineWidth', 1);
  %  plot1.Color(4) = 0.5;
    hold on; plot2 = plot(0:5:numVars*5-1, catVarsN(labels==classes{2},:), 'Color', cols(3,:), 'LineWidth', 1);
  %  plot2.Color(4) = 0.2;
    for i = 0:5:numVars*5-1; hold on; plot([i i], [0 max(catVarsN(:))], 'k'); end
   

    ax = gca;
    X =  0:5:numVars*5-1;
    ax.XTick = X;
    ax.XTickLabel = {'job', 'marital', 'housing', 'education', 'pay accepted'};
    ax.YTick = mean([cats(1).start1 cats(1).start2],2);   
    ax.YTickLabel = cats(1).names; 
    
    for axis = 2: numel(X)-1
        if any(any(isnan([cats(axis).start1 cats(axis).start2])))
            posY = max([cats(axis).start1 cats(axis).start2],[], 2,'omitnan');
        else; posY = mean([cats(axis).start1 cats(axis).start2],2, 'omitnan'); end  
        text(repmat(X(axis)+0.05, size(posY)), posY, cats(axis).names);
    end
    text(repmat(X(end)+0.05, numel(classes),1), [mean(catVarsN(labels== classes{1},end)); mean(catVarsN(labels== classes{2},end))], ...
        cats(numVars).names);
    
   
    
end