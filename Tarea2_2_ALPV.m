%Tarea 2.2 Ana Laura Pinedo Vargas
clear 
load('Control_5_rafagas.mat', 'control')
figure(1), clf

Fs=25e3; %frecuencia de muestreo
tiempoGrafica=1; %segundos que quiero plotear
umbrales = [3e-4 3e-4 2e-4 2e-4 0.5e-3 2e-4 5.5e-4 7.5e-4 6.5e-4];
%tiempo_ms=control(1,1:Fs*tiempoGrafica); %tiempo del canal 0
for i=1:
    correlacion=[]; % Reseteas la matriz de correlacion
    figure(1), clf
    trazo=-control(1:Fs*tiempoGrafica,i); % trazo del canal
    %plot(tiempo_ms,trazo)
    
    [picos,locs]=findpeaks(trazo,'MinPeakHeight', 40);
    
    subplot(211)
    plot(trazo), hold on
    plot(locs,picos, 'ro')
      
    
    vectorPicos= zeros(size(trazo)); % %Hacer un filtro de la señal, para separar los indices donde se encuentran las rafagas
    vectorPicos(locs) = 1;
    
    kernel= ones(Fs/2,1)/Fs/2; % filtro para la señal
    rafagas= conv(vectorPicos,kernel,'same'); %Señal filtrada para contar rafagas
    
    subplot(212), hold on
    plot(rafagas) %graficar la señal filtrada con kernel
    
    indiceRafagas = [find(rafagas>umbrales(i-1)) length(trazo)]; % encontrar la posicion de las rafagas mayores a 3e-4
    ejeX = 1:length(rafagas);
    plot(ejeX(indiceRafagas),rafagas(indiceRafagas),'ro')
    
    distanciaEntrePuntos = indiceRafagas(2:end)-indiceRafagas(1:end-1);
    localizaRafaga = find(distanciaEntrePuntos>5000);
    
    plot(ejeX(indiceRafagas(localizaRafaga)),rafagas(indiceRafagas(localizaRafaga)),'g+')
    
    puntoRafagaTermina=ejeX(indiceRafagas(localizaRafaga)); %Posiciones de cada rafaga
    puntoRafagaInicia=ejeX(indiceRafagas(localizaRafaga)-12500); %Ventana de 500ms para la Rafaga
    
    ventanas25ms = [] ; %vector vacío para indexar las ventanas pequeñas
    
    % For para dar una vuelta por cada rafaga
    
    for k = 1:length(puntoRafagaInicia)
        rafaga=puntoRafagaInicia(k):625:puntoRafagaTermina(k);% 625 elementos son 0.025 segundos osea 25 ms
        
        % Una vuelta por cada 25 ms
        for j = 1:length(rafaga)-1
            ventanas25ms = [ventanas25ms; trazo(rafaga(j):rafaga(j+1))]; %guardar los recortes en esta
            figure(22) %%figura para ver que si este sacando las ventanas el for
            plot(ventanas25ms(j,:))
            pause
        end
    end
    
    %Ahora vamos ventana por ventana para comparar todas contra todas
    %correlacion = zeros(size(ventanas25ms,1)); % Tamaño de la correlacion
    for k = 1:size(ventanas25ms,1)
        disp([num2str(k) '/' num2str(size(ventanas25ms,1))]); %contador para ver si esta avanzando
        for j = 1:size(ventanas25ms,1)
            [R P]= corrcoef(ventanas25ms(k,:),ventanas25ms(j,:));
            if P(1,2)<0.05 % Guarda los estadisticamente significativos
                correlacion(k,j) = R(1,2);
            end
        end
    end
    matricesCorrelacion{i-1} = correlacion;

    figure(2)
    subplot(2,5,i-1)
    imagesc(correlacion)
    axis('square')
    title(['Correlación: ' num2str(i-1) ])
    axis('square')
    colormap pink
    c = colorbar;
    c.Label.String = 'Coeficiente';
    xlabel('25ms'), ylabel('25ms')
end

save('matricesCorrelacionRafagas','matricesCorrelacion')
