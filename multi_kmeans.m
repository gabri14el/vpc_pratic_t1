
clear all;

n_th = 10;

diretoria = 'imagens_segmentacao';
arquivos = dir(fullfile(diretoria,'*.jpg'));

num_fig = 25;
num_img = 1;
num_fig_seg = 1;

for i = 1: length(arquivos)
    filename = fullfile(diretoria, arquivos(i).name);
    im = imread(filename);
    
    figure(num_fig); imshow(im); title('Original');
    im = double(rgb2gray(im));
    
    for j = 1 : n_th
     
        seg = multi_kmeans(im, j, num_fig_seg, num_img);
 
        
%         metricas do professor
        intensity  = max(max(seg));
        sim = ssim(seg* (255/intensity), im);
        mean_sq_err = immse(seg*(255/intensity), im);
        multi_sim = multissim(seg*(255/intensity), im);
        
        if(num_img < 10)
            num_img = num_img + 1;
        else
            num_img = 1;
        end 
        
    end
    
    num_fig = num_fig + 1;
    num_fig_seg = num_fig_seg + 1;
end


function seg = multi_kmeans(I, qtdTresh, num_fig_seg, num_img)
   
    %[L,Centers] = imsegkmeans(I,qtdTresh);
    %B = labeloverlay(I,L);
    %B = label2rgb(L);
    
    image = I;
    k = qtdTresh;
    % Cluster.
    clustered = reshape(kmeans(image(:), k), size(image));
    % Sort clusters.
    clustermeans = zeros(k, 1);
    for j = 1:k
        [row, col] = find(clustered == j);
        pixelsKvalued = zeros(length(row), 1);
        for l = 1:length(row)
            pixelsKvalued(l) = image(row(l), col(l));
        end
        clustermeans(j) = mean(pixelsKvalued);
    end 
    sortidx = zeros(k, 1);
    for j = 1:k
        sortidx(find(clustermeans == min(clustermeans))) = j;    
        clustermeans(clustermeans == min(clustermeans)) = NaN;
    end
    clustered = sortidx(clustered);
    
    figure(num_fig_seg); subplot (2, 5, num_img);  imshow(clustered, []);

    title('Labeled Image');
    seg = clustered;
    
end
