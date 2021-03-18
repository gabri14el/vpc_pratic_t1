function seg = multi_otsu(I, qtdTresh)
   
    thresh = multithresh(I,qtdTresh);
    seg_I = imquantize(I,thresh);
    RGB = label2rgb(seg_I); 	 
    figure(1);
    imshow(RGB);
    axis off
    title('RGB Segmented Image');
    seg = seg_I;
    
    
end