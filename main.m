clear all;
format short g;

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
    ssim_ = zeros(2, length(tresh));
    mse_ = zeros(2, length(tresh));
    multi_sim_ = zeros(2, length(tresh));
    psnr_ = zeros(2, length(tresh));
    
    for x = 1:length(tresh)
        
        fprintf('calculando para thresh %s \n', int2str(tresh(x)));
        
        %calcula os métodos
        kmeans = multi_kmeans(gray, tresh(x)+1);
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
        
        psnr_kmeans = psnr(kmeans,gray);
        psnr_otsu = psnr(otsu,gray);
        
        ssim_(1, x) = ssim_otsu;  ssim_(2, x) = ssim_kmeans; 
        multi_sim_(1, x) = multi_sim_otsu; multi_sim_(2, x) = multi_sim_kmeans;
        mse_(1, x) = mean_sq_err_otsu; mse_(2, x) = mean_sq_err_kemans; 
        psnr_(1, x) = psnr_otsu; psnr_(2, x) = psnr_kmeans;
        
        
        
        
        %plota resultado
        figure(1);
        hold on;
        str_title = strcat(int2str(tresh(x)), ';', 'ssim: ',num2str(ssim_otsu,'%.2f'), ' ;', 'mse: ', num2str(mean_sq_err_otsu,'%.2f'), '; msim:', num2str(multi_sim_otsu,'%.2f'), '; psnr: ', num2str(psnr_otsu,'%.2f'));
        subplot(n, m, x+1); imshow(otsu); title(str_title); 
        
        hold off;
        
        figure(2);
        hold on;
        str_title = strcat(int2str(tresh(x)), ';', 'ssim: ',num2str(ssim_kmeans,'%.2f'), ' ;', 'mse: ', num2str(mean_sq_err_kemans,'%.2f'), '; msim:', num2str(multi_sim_kmeans,'%.2f'),'; psnr: ', num2str(psnr_kmeans,'%.2f'));
        subplot(n, m, x+1); imshow(kmeans); title(str_title);
        
        hold off;
        
        
        
    end
    
    %saveas(1,strcat('results/otsu_', arquivos(i).name));
    %saveas(2,strcat('results/kmeans_', arquivos(i).name));
    figure(3);
    hold on;
    subplot(2, 2, 1); xticks(tresh); ylim([0 1]); plot(tresh, ssim_(1,:), tresh, ssim_(2, :)); legend('otsu', 'kmeans'); title('Structural similarity'); xlabel('threshold'); ylabel('valor da métrica');
    subplot(2, 2, 2); xticks(tresh); ylim([0 1]); plot(tresh, multi_sim_(1,:), tresh, multi_sim_(2, :)); legend('otsu', 'kmeans'); title('Multi-scale structural similarity'); xlabel('threshold'); ylabel('valor da métrica');
    subplot(2, 2, 3); xticks(tresh); ylim([0 1]); plot(tresh, mse_(1,:), tresh, mse_(2, :)); legend('otsu', 'kmeans'); title('Mean-squared error'); xlabel('threshold'); ylabel('valor da métrica');
    subplot(2, 2, 4); xticks(tresh); ylim([0 1]); plot(tresh, psnr_(1,:), tresh, psnr_(2, :)); legend('otsu', 'kmeans'); title('Peak signal-to-noise ratio'); xlabel('threshold'); ylabel('valor da métrica');
    hold off;
    print(1, '-dpng', strcat('results/otsu_', arquivos(i).name), '-r300');
    print(2, '-dpng', strcat('results/kmeans_', arquivos(i).name), '-r300');
    print(3, '-dpng', strcat('results/metrics_', arquivos(i).name), '-r300');
    %pause();
    
    %limpa as figuras casos elas estejam abertas
    if ishandle(1)
        clf(1);
    end
    
    if ishandle(2)
        clf(2);
    end
    
    if ishandle(3)
        clf(3);
    end
end



