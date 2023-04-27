function curveFittingExample
    curveFittingExampleSin   
end

function curveFittingExampleSin
    %N, number of observations
     Max = 1;
     N = 20;
     x = 0.01:Max/N:Max;     
     %t_bold, set of target values
     snr = 6;
     [t, yReal] = getObservation(x, snr);     
     
     
     %M, degree of polynomial to fit
     M = 2;     
     lambda = 0;
     %Model training
     wReg = getOptimumW_Reg(x, t, M, lambda);
     %Model evaluation
     y_approxReg = evaluateModel(x, wReg);     
     figure;     
     scatter(x, t);
     hold on;     
     plot(x, y_approxReg);
     hold on;
     plot(x, yReal);
     
     [E, Erms] = getError(yReal, y_approxReg);
     disp('Error respecto a la verdad absoluta')
     Erms
     
     [E, Erms] = getError(t, y_approxReg);
     disp('Error respecto a las etiquetas')
     Erms
     disp('Arreglo de pesos o parametros')
    
end

function y_approxReg = evaluateModel(x, w)
    for i = 1:length(x)        
        y_approxReg(i) = yF(x(i), w);
    end
    
end

%polynomial approx
function y = yF(x_val, w)
    y = 0;
    for i = 1:length(w)
        y = y + w(i) * (x_val.^(i - 1));
    end
end

%E(w)
function [E, Erms] = getError(y, t)
    E = 0.5 * sum((y - t).^2);
    Erms = sqrt((2 * E)/length(t));
end

%Least squares with first derivative equals zero
function W = getOptimumW_Reg(x, t, M, lambda)
    M = M + 1;
    t = t';
    N = length(x);
    X = zeros(length(x), M);         
    %Matrix X with x repeated in every column
    %to express the derivative in matrix therms
    for i = 1:M
        X(:, i) = x;
    end
    for i = 1:N
        for j = 1:M
            X(i, j) = X(i,j) ^ (j-1);
        end
    end
    
    therm1 =   X' * X;
    lambdaI = lambda * eye(size(therm1));
    fac1 = therm1 + lambdaI;
    fac2 = X' * t;
    W = pinv(fac1) * fac2;
    
end

function [t, yReal] = getObservation(x, snr)
    
    yReal = sin(2*pi*x);
    t = awgn(yReal, snr);
end


