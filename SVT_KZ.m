function [x] = SVT_KZ(filename, users)

    clc;
    
    big_M = load(filename);
    sample = randsample(1:length(big_M), users);
    M = big_M(sample,:);
    [r,c] = size(M);

    % generate the projection matrix Omega
    Omega = zeros(r,c);
    num = 0; % number of existing entries
    for i=1:r
        for j=1:c
            if M(i,j) > 0
                Omega(i,j) = 1;
                num = num + 1;
            end
        end
    end
    disp(num);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                               %
    %         SVT algorithm         %
    %                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    maxiter = 1000; %maximum iterations
    tau = 1000;

    y{1} = ones(r,c);
    
    % the singular vector thresholding algorithms
    for k=2:maxiter
        [U, S, V] = svd(y{k-1});
        D = S - tau;
        [d1,d2] = size(S);
        for i=1:d1
            for j=1:d2
                if D(i,j) < 0
                    D(i,j) = 0;
                end
            end
        end
        x{k} = U*D*V';
        y{k} = y{k-1} + (M-x{k}).*Omega;
    end
    
end