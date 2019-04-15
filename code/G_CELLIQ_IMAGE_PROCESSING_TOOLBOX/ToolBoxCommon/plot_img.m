function plot_img( img, seeds)

[X,Y] = find( seeds == true);
[rows, cols] = size( seeds);
%X = rows - X;
figure, imshow( img,[]); hold on;
%plot(Y(:), X(:), 'r.', 'MarkerSize', 1);
plot( Y(:), X(:), 'r.', 'MarkerSize', 7);
plot( Y(:), X(:), 'ro', 'MarkerSize',3);
% plot( Y(:), X(:), 'ro', 'MarkerSize',5);

