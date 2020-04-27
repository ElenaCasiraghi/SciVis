function AnalizeAnscombe
close all
clc
 disp('data:')
 data = readtable('Anscombe.xls')
 variables = data.Properties.VariableNames;
 dataNum = table2array(data);
 disp(variables)  
 disp(['means: ', num2str(mean(dataNum))]);
 disp(['stds: ', num2str(std(dataNum))]);
 corMat = diag(corr(dataNum),1);
 corMat = corMat(1:4);
 sets = ['A','B','C','D'];
 for s= 1:numel(sets) 
     disp(['corr ' sets(s) 'x-' sets(s) 'y = ' num2str(round(corMat(s),2))])
 end
 figure('Name', 'All Plots', 'units','normalized','outerposition',[0 0 0.75 1]);
 XLim = [min(min(dataNum(:,1+2:end)))-1 max(max(dataNum(:,1+2:end)))+1];
 YLim = [min(min(dataNum(:,2+2:end))) max(max(dataNum(:,2+2:end)))];
 
 disp('Linear Fits')
 
 for s = 1: 4
     
     disp([sets(s) 'x vs ' sets(s) 'y'])
     hold on; subplot(2,2,s); 
     resFit = fitlm(dataNum(:,(s-1)*2+1),dataNum(:,(s-1)*2+2));
     disp(resFit.Coefficients)
     cefs = resFit.Coefficients(:,1).Variables;
     hold on; resFit.plot; 
     ax = gca; 
     scatter(dataNum(:,(s-1)*2+1),dataNum(:,(s-1)*2+2));
     ax.XLim = XLim;
     ax.XLabel.String = [sets(s) 'x'];
     ax.YLim = YLim;
     ax.YLabel.String = [sets(s) 'y'];
     ax.YLabel.Rotation = 0;
     ax.YLabel.Position = [0 11 -1]
     ax.Legend.Location = 'northwest';
     ax.Legend.String{1} = [sets(s)];
     ax.Legend.String{2} = ['Fit: ' sets(s) 'y = ' num2str(round(cefs(2),2)) sets(s) 'x + ' num2str(round(cefs(1),1))];
     ax.Legend.String{4} = [sets(s) 'x vs ' sets(s) 'y'];
     title([sets(s) 'x vs ' sets(s) 'y'])
 end
 
end