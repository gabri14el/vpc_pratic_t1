function seg = multi_otsu(I, qtdTresh)
   
    thresh = multithresh(I,qtdTresh);
    seg_I = imquantize(I,thresh);
    seg = seg_I;
    
end