function seg = multi_kmeans(I, qtdTresh)
   
    
    image = I;
    k = qtdTresh;
    % Cluster.
    clustered = reshape(imsegkmeans(image(:), k), size(image));
    
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
    seg = clustered;
    
end