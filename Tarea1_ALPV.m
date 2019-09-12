clear all, clc, clf
load('Rasterbin.mat') % cargar matriz de 0 y 1, 

figure(1)
matrizSimI=zeros(998,998);

for i=1:size(Rasterbin,2);
       
    for j=1:size(Rasterbin,2);
        N1=Rasterbin(:,i);    
        N2=Rasterbin(:,j);
        
        D=dot(N1,N2); % Producto punto de las columnas
        
        
        MV1=N1.^2;     % calculo de magnitud de cada vector
        MV1Suma=sum(MV1);
        MV1Magnitud=sqrt(MV1Suma);
        
        MV2=N2.^2;
        MV2Suma=sum(MV2);
        MV2Magnitud=sqrt(MV2Suma);
        
       matrizSimI(i,j)=(D /(MV1Magnitud * MV2Magnitud));
        
   end
end

imagesc(matrizSimI);
title('Matriz de Similitud')
xlabel('#Frame'), ylabel('#Frame')
axis('square')
colormap pink
c = colorbar;
c.Label.String = 'Indice de Similitud'; 