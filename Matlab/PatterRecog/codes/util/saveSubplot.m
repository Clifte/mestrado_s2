function saveSubplot(h,path,zbuffer)
hfig = figure;
hax_new = copyobj(h, hfig);
set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));   

if(exist('zbuffer'))
    set(gcf,'renderer','zbuffer')
else
    set(gcf,'renderer','painters')
end

%saveas(gcf, path,'epsc');
print(gcf,path,'-depsc','-r150');
close(hfig);
end