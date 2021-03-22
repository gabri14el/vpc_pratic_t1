clear all;

tresh = [2 4 6 8 10 16 20];
 
diretoria = '/home/gabriel/pCloudDrive/UTAD/2020-2021-2/VPC/Prática/images_tp01';
arquivos = dir(fullfile(diretoria,'*.jpg'));

m = 4;
n = ceil((length(tresh) + 1)/4);

for i = 1: length(arquivos)
    
    %captura nome do arquivo
    filename = fullfile(diretoria, arquivos(i).name);
    %le imagem
    I = imread(filename);
    
    %converte pra tons de cinza
    gray = rgb2gray(I);
    
    figure(1);
    
    %imprime imagem original
    hold on;
    sgtitle('Otsu');
    subplot(n, m, 1); imshow(gray); title('original')
    hold off;
    
    figure(2);
    
    hold on;
    sgtitle('K-means');
    subplot(n, m, 1); imshow(gray); title('original')
    hold off;
    
    %itera sobre os threshs
    for x = 1:length(tresh)
        
        fprintf('calculando para thresh %s \n', int2str(tresh(x)));
        
        %calcula os métodos
        kmeans = multi_kmeans(gray, tresh(x));
        otsu = multi_otsu(gray, tresh(x));
        
        %converte a matriz de 0 a 255
        kmeans = uint8(mat2gray(kmeans) * 255);
        otsu = uint8(mat2gray(otsu) * 255);
        
        %calcula métricas
        ssim_kmeans = ssim(kmeans,gray);
        ssim_otsu = ssim(otsu,gray);

        mean_sq_err_kemans = immse(kmeans,gray);
        mean_sq_err_otsu = immse(otsu,gray);


        multi_sim_kmeans = multissim(kmeans,gray);
        multi_sim_otsu = multissim(otsu,gray);
        
        
        %plota resultado
        figure(1);
        hold on;
        str_title = strcat(int2str(tresh(x)), ';', 'ssim: ',num2str(ssim_otsu), ' ;', 'mse: ', num2str(mean_sq_err_otsu), '; msim:', num2str(multi_sim_otsu));
        subplot(n, m, x+1); imshow(otsu); title(str_title); 
        
        hold off;
        
        figure(2);
        hold on;
        str_title = strcat(int2str(tresh(x)), ';', 'ssim: ',num2str(ssim_kmeans), ' ;', 'mse: ', num2str(mean_sq_err_kemans), '; msim:', num2str(multi_sim_kmeans));
        subplot(n, m, x+1); imshow(kmeans); title(str_title);
        
        hold off;
    end
    
        
    pause();
    %limpa as figuras casos elas estejam abertas
    if ishandle(1)
        clf(1);
    end
    if ishandle(2)
        clf(2);
    end
end



