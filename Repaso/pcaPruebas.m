function pcaPruebas
    close all;
    pcaPruebas1
end



function pcaPruebas1
    close all;
    %Generar puntos sobre superficie de un plano
    X = generarPuntos;
    %Calcular matriz de covarianza
    C = cov(X'); 
    %Calcular autovectores y auto valores
    [V, D] = eig(C);
    %Tomar los autovectores mas importantes, segun autovectores
    N = tomarEjesPrincipales(V, D)
    %Proyectar los datos
    Xn = proyectarDatos(X, N);
end



function N = tomarEjesPrincipales(V, D)
    D
    N(:, 1) = V(:, 3);
    N(:, 2) = V(:, 2);
end

function Xn = proyectarDatos(X, V)
    meanX = mean(X');
    %sustraer la media de los datos
    repMeanX = repmat(meanX, size(X, 2), 1);     
    Xnorm = X - repMeanX';
    
    %Xn = V * V' * Xnorm;
    %Xna = V * inv(V' * V) * V' * Xnorm;
    figure; scatter3(X(1, :), X(2, :), X(3, :));
    %Graficar los autovectores
    hold on;
    quiver3(meanX(1), meanX(2), meanX(3), V(1, 1), V(2, 1), V(3, 1) );
    hold on;
    quiver3(meanX(1), meanX(2), meanX(3), V(1, 2), V(2, 2), V(3, 2) );
    %Proyeccion por elemento, EJERCICIO: cambiar a una sola operacion matricial
    for i = 1:size(X, 2)
        Xp(1,i) = dot(Xnorm(:, i), V(:, 1));
        Xp(2,i) = dot(Xnorm(:, i), V(:, 2));

    end
    %Graficar en una nueva figura los datos proyectados
    figure; scatter(Xp(1, :), Xp(2, :));
    Xn = Xp;
end

function Xn = generarPuntos
    n = 50;
    x=-10:.1:10; 
    mu = 0;
    std1 = 2.5;
    zRand = randn(n, 1) * sqrt(std1) + mu;
    xPuntosRand = floor(20 .* rand(n, 1)) - 10;
    yPuntosRand = floor(20 .* rand(n, 1)) - 10;
    zPuntosRand = 0.2* xPuntosRand + yPuntosRand + zRand; 
    
    Xn = [xPuntosRand  yPuntosRand  zPuntosRand];
    Xn = Xn';
    figure; scatter3(xPuntosRand, yPuntosRand, zPuntosRand);
    
    [X,Y] = meshgrid(x);
    Z = 0.2*X + Y ; 
    Z1 = Z.*0; 
    figure; surf(X,Y,Z); 
    shading flat 
    xlabel('x'); 
    ylabel('y'); 
    zlabel('z') 
    hold on; 
    surf(X,Y,Z1); 
    hold on; 
    M = [1  2.1 ;
    -2.1  1]; 
    plotv(M,'-');
end