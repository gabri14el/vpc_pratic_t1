function seg = multi_kmeans(I, qtdTresh)
   
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
    
    figure(2);
    imshow(clustered, []);
    title('Labeled Image');
    seg = clustered
    
end