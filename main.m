I = imread('/home/gabriel/pCloudDrive/UTAD/2020-2021-2/VPC/Prática/images_tp01/3096.jpg');

gray = rgb2gray(I);
qtdTresh = 8;

kmeans = multi_kmeans(gray, qtdTresh);
otsu = multi_otsu(gray, qtdTresh);

kmeans = uint8(mat2gray(kmeans) * 255);
otsu = uint8(mat2gray(otsu) * 255);

ssim_kmeans = ssim(kmeans,gray);
ssim_otsu = ssim(otsu,gray);

figure(4);
imshow(otsu);
figure(3);
imshow(kmeans);



