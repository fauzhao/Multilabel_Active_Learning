 n = 5;
    chunk_size = floor(N/n);
    min_param_err = 100;
    for chi=[1e-4, 1e-3, 1e-2]
        for small_sigma = [1e-2, 1e-3, 1e-4]
            err = zeros(n,1);
            for test_num = 1:n
                Xtest = X((test_num-1)*chunk_size+1, :);
                Xtrain = X(setdiff(1:N,(test_num-1)*chunk_size+1),:);
                Ytest = y((test_num-1)*chunk_size+1,:);
                Ytrain = y(setdiff(1:N,(test_num-1)*chunk_size+1),:);
                
                opt.chi = chi;
                ops.small_sigma = small_sigma;
                
                [W,phi,opts] = train_mod(Xtrain,Ytrain,K,opts);
                
                Ytemp = test(Xtest,W,L,phi,opts);
                Yhat = concat_struct_attr(Ytemp,'mu');
                
                err(test_num) = compute_hamming_distance(Yhat, Ytest);
            end
            param_err = mean(err);
            if param_err < min_param_err
                best_small_sigma = small_sigma;
                best_chi = chi;
                min_param_err = param_err;
            end
            
        end
    end