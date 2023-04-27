[X, Y] = meshgrid(-2:.2:2);
Z = exp(-X.^2 - Y.^2);
[DX, DY] = gradient(Z);
figure;
contour(X, Y, Z)
hold on
quiver(X, Y, DX, DY);
hold off