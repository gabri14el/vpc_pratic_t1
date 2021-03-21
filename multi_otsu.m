
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
     
        seg = multi_otsu(im, j, num_fig_seg, num_img);
 
        
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

function seg = multi_otsu(I, qtdTresh, num_fig_seg, num_img)
    
    thresh = multithresh(I,qtdTresh);
    seg_I = imquantize(I,thresh);
    RGB = label2rgb(seg_I); 	 
    figure(num_fig_seg); subplot (2, 5, num_img); imshow(RGB);
    
    axis off
    title('RGB Segmented Image');
    seg = seg_I;
    
    
end
