clear 
load('Control_5_rafagas.mat', 'control')
load('Post_5_rafagas.mat', 'post')
figure(1), clf

%%%%%%%%%%%%%%% CTL
for i=1:5

 Xcorrelacion=[]; 
      for k = 1:size(control,1)
     autocorr=xcorr(control(k,:));
     
            for j = 1:size(control,1)
                [r]= xcorr(control(k,:),control(j,:));
                Xcorrelacion(k,j) = max(r)/max(autocorr);
               
            end
      end
      
    figure(1)
    subplot(311)
    imagesc(Xcorrelacion)
    axis('square')
    title(['Correlación CTL'])
    axis('square')
    colormap pink
    c = colorbar;
    c.Label.String = 'Coeficiente';
    xlabel('Rafagas'), ylabel('Rafagas')
    

end


%%%%%%%%%%%%%%%%%% Post

for i=1:5

 Xcorrelacion=[]; 
      for k = 1:size(post,1)
     autocorr=xcorr(post(k,:));
     
            for j = 1:size(post,1)
                [r]= xcorr(post(k,:),post(j,:));
                Xcorrelacion(k,j) = max(r)/max(autocorr);
               
            end
      end
      
    figure(1)
    subplot(312)
    imagesc(Xcorrelacion)
    axis('square')
    title(['Correlación POST'])
    axis('square')
    colormap pink
    c = colorbar;
    c.Label.String = 'Coeficiente';
    xlabel('Rafagas'), ylabel('Rafagas')
    

end

%%%%%%%%%%% CTL vs POST
     

for i=1:5

 Xcorrelacion=[]; 
      for k = 1:size(post,1)
     autocorr=xcorr(control(k,:),post(k,:));
     
            for j = 1:size(post,1)
                [r]= xcorr(control(k,:),post(j,:));
                Xcorrelacion(k,j) = max(r)/max(autocorr);
               
            end
      end
      
    figure(1)
    subplot(313)
    imagesc(Xcorrelacion)
    axis('square')
    title(['Correlación CTL vs POST'])
    axis('square')
    colormap pink
    c = colorbar;
    c.Label.String = 'Coeficiente';
    xlabel('Rafagas CTL'), ylabel('Rafagas POST')
    
end

%%%%%%%%%%%%%%%%% Ventanas CTL   
figure(33)

Fs=25e3; %frecuencia de muestreo
tiempoGrafica=0.5 ; %segundos que quiero plotear
tiempo_ms=500;
%umbrales = [3e-4 3e-4 2e-4 2e-4 0.5e-3 ]
   
for i=1:5
  Xcorrelacion=[]; % Reseteas la matriz de correlacion cruzada
  trazo=control(i,:); % trazo del canal
    
  ventanas25ms = [] ; %vector vacío para indexar las ventanas pequeñas
    
    % For para dar una vuelta por cada rafaga
    
   for k = 1:length(trazo)
       rafaga=trazo(k:625:end) ;% 625 elementos son 0.025 segundos osea 25 ms
        
        % Una vuelta por cada 25 ms
        for j = 1:length(rafaga)
            ventanas25ms = [ventanas25ms; rafaga(rafaga(j):rafaga(j+1))]; %guardar los recortes en esta
                      
        end

    end
    
    %Ahora vamos ventana por ventana para comparar todas contra todas
  
    for k = 1:size(ventanas25ms,1)
        autocorr=xcorr(ventanas25ms(k,:));
        
        for j = 1:size(ventanas25ms,1) 
            [r]= xcorr(ventanas25ms(k,:),ventanas25ms(j,:));
            Xcorrelacion(k,j) = max(r)/max(autocorr);
        end
    end
    
    imagesc(Xcorrelacion)
    axis('square')
    title(['Correlación Cruzada'])
    colormap pink
    c = colorbar;
    c.Label.String = 'Coeficiente de similitud';
    xlabel('25ms'), ylabel('25ms')
 end      
