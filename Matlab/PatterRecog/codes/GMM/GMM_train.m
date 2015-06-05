function model = GMM_train(x,k,show_anim)

global exportDir;


model = GMMEM(x, k);
medias = model.medias;

if(show_anim)
    h1 = figure;
    
    
    nSamples = 100;
    range = linspace(-0.2,1.2,nSamples);
    xy = generatePairs(range,range);

end



for i=1:100000
    model = GMMEM(x, k,model);
    
    if(show_anim)

        figure(h1);
        hold off;
        scatter(x(:,1),x(:,2));
        hold on;


        [Px4]= GMM(model,xy);

        for j=1:k
            Px = Px4(j,:);
            Px = reshape(Px,[nSamples nSamples]);
            contour(range,range,Px,20)

        end
        drawnow;      
        

    end
    
    est = sum(abs(model.medias(:)-medias(:)));
    sprintf('estabilizacao: %f\n',est );
    if( est < 10E-4 )
        break;
    end
        
    medias = model.medias(:);
    

    
end

if(show_anim)
    
    path = sprintf('%sFunctions.eps',exportDir);
    set(gcf,'renderer','zbuffer') 
    saveas(gcf, path,'epsc');
    
    
    Px= Px4(4,:);
    Px = reshape(Px,[nSamples nSamples]);

    figure;
    contour(range,range,Px,20)
    path = sprintf('%sresultPDF.eps',exportDir);
    set(gcf,'renderer','zbuffer') 
    saveas(gcf, path,'epsc');    
    
    figure;
    surf(Px);
    view( [ mod(i,90) 30] );
    
    path = sprintf('%sresultPDF3D.eps',exportDir);
    set(gcf,'renderer','zbuffer') 
    saveas(gcf, path,'epsc');        
    
end


end