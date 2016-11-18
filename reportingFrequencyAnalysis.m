function [] = reportingFrequencyAnalysis(dat,path);
%H1 Line -- plotting function
%Hepl Text -- plot of the time series, observed return period and fitted
%probability density model and plotting of the regional model
%input requirements:
%                   dat: is the structure array output from mainFrequency
%                   analysis
%                   path: is the full path directory where we store the
%                   figures
%**************************************************************************

nbFiles = size(dat,1);
regional = zeros(nbFiles,8);        %table to store area and discharges

%creates figures
%time series and frequency plot for each station + 
%frequency distribution of data
for n = 1:nbFiles
    %TIME SERIES PLOT AND FREQUENCY PLOT WITH FITTED FUNCTION
    fign(n) = figure;
    set(fign(n),'units','centimeters','position',[0 -3 15 16]);    
    %data variables
    year = dat(n,1).year;
    Q    = dat(n,1).discharges;
    Qr   = dat(n,1).freqDataPearson(:,2);
    ret  = dat(n,1).freqDataPearson(:,4);
    Qpredicted = dat(n,1).logPearsonIII(:,3);
    period = dat(n,1).logPearsonIII(:,1);
    regional(n,1) = dat(n,1).drainageArea;
    regional(n,2:8) = dat(n,1).logPearsonIII(:,3)';
    %time series plot
    ax1 = axes;
    set(ax1,'units','centimeters','position',[2 9 12 5]);
    plot(year,Q,'o-k');
    text(0.1,0.90,['N= ',num2str(size(Q,1))],'units','normalized','FontWeight','bold');
    title(dat(n,1).HYDAT_station_ID);
    set(ax1,'color','none');
    xlabel('year')
    ylabel('discharge (m^{3}.s^{-1})')
    %frequency plot
    ax2 = axes;
    set(ax2,'units','centimeters','position',[2 3 12 5]);
    plot(ret,Qr,'or');
    hold on
    line(period,Qpredicted,'Color','g','LineWidth',1.5)
    set(ax2,'Xscale','log','YScale','log','color','none','XGrid','on','YGrid','on');
    xlabel('return period (years)')
    ylabel('discharge (m^{3}.s^{-1})')
    hl = legend('observed','log-PearsonIII','location',[.15 .05 .7 .05],...
        'orientation','horizontal');
    legend('boxoff')
    %exporting the figure
    set(gcf,'PaperPositionMode','auto','invertHardCopy','on')
    figname = [path,'\','plot',dat(n,1).HYDAT_station_ID(1:22)];
    %saveas(gcf,figname,'eps')
    saveas(gcf,figname,'emf')
    %logging figure filename
    figLOG(n).filename = ['plot',dat(n,1).HYDAT_station_ID(1:22)];
    %print(fign(n), '-append', '-dpsc2', [path,'\','myReport.ps']);
    
    %FREQUENCY DISTRIBUTION OF DATA
     figdist(n) = figure;
     set(figdist,'units','centimeters','position',[0 0 15 8]);
     ax4 = axes;
     set(ax4,'units','centimeters','position',[2 1.5 12 5.5]);
     maxQ = max(Q);
     normQ = Q./maxQ;
     [nb,xout] = hist(normQ,[0:0.1:1]);
     nbPercent = nb./length(normQ);
     hbar = bar(xout,nbPercent,1);
     %set(hbar,'width',1);
     xlabel('Q/Q_{max}')
     ylabel('relative frequency')
     title(dat(n,1).HYDAT_station_ID);
     set(ax4,'Color','none','XLim',[0 1.1],'YLim',[0 1]);
     text(0.6,0.8,['med=',num2str(median(Q),3)]);
     [sk] = mySkew(Q);
     text(0.6,0.6,['sk =',num2str(sk,3)]);
     text(0.6,0.4,['N=',num2str(length(Q),3)]);
     set(gcf,'PaperPositionMode','auto','invertHardCopy','on')
     figname2 = [path,'\','hist',dat(n,1).HYDAT_station_ID(1:22)];
    % saveas(gcf,figname2,'eps')
     saveas(gcf,figname2,'emf')
     clear sk maxQ nomrQ nb xout nbPercent hbar Q Qr year ret
     
     %BAR CHART OF MONTH
     mt = dat(n,1).percentMonth(:,2);
     fig5 = figure;
     set(fig5,'units','centimeters','position',[0 0 7 7]);
     ax5 = axes;
     set(ax5,'units','centimeters','position',[1.5 1.5 5 4]);
     hbmonth = bar(mt,1);
     %set(hbmonth,'width',1);
     xlabel('month')
     ylabel('percent')
     title(dat(n,1).HYDAT_station_ID);
     set(ax5,'YLim',[0 1],'Color','none');
     figname3 = [path,'\','month',dat(n,1).HYDAT_station_ID(1:22)];
    % saveas(gcf,figname3,'eps')
     saveas(gcf,figname3,'emf')
     clear mt
end%end of FIRST n loop

clear n

%regional analysis
nbPeriod = size(dat(1,1).logPearsonIII,1);
regionalFig = figure;
set(regionalFig,'units','centimeters','position',[0 -3 22 13]);
ax3 = axes;
set(ax3,'units','centimeters','position',[2 2 15 10]);
yr = {'2','5','10','25','50','100','200'};
%color scale
col = [0 0 0;
        .5 .5 .5;
        .2 .2 .2;
        0 0 0;
        0.95 0 0;
        0.5 0 0;
        0.15 0 0];
x = log10(regional(:,1));
for n = 1:nbPeriod;
    y = log10(regional(:,n+1));
    p = polyfit(x,y,1);
    ypre = polyval(p,x);
    plot(10.^x,10.^y,'o','MarkerFaceColor',col(n,:),...
        'MarkerEdgeColor',col(n,:));
    hold on
    line(10.^sort(x),10.^sort(ypre),'Color',col(n,:));
    exponent = num2str(p(1),3);
    text(1.05,0.1+(n-1)*.1,[yr{n},'-yr =',num2str(10^p(2),3),'A','\^',exponent],...
        'units','normalized','FontWeight','bold',...
        'color',col(n,:));
    
end%end of second n loop
%set-up of axes
ymax = max(regional(:,8));
xmax = max(regional(:,1));
set(ax3,'XScale','log','YScale','log','color','none',...
    'XGrid','on','YGrid','on','XLim',[0 xmax+.1*xmax],'YLim',[0 ymax+.1*ymax]);
xlabel('catchment area (km^2)')
ylabel('discharge (m^3.s^{-1})')
%exporting the figure
%saveas(gcf,[path,'\','regionalFigure'],'eps')
saveas(gcf,[path,'\','regionalFigure'],'emf')
%print -depsc2 [path,'\','regionalFigureTEST'] -loose 
%print(gcf,'-depsc2',[path,'\','regionalFigureTEST'])
%**************************************************************************
end%end of function reportingFrequencyAnalysis

