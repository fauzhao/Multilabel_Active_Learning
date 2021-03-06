function [best_small_sigma, best_chi, best_kernel_length_scale] = cross_validation(percent_compression, X, y, phi, opts, n, small_sigma_values, chi_values, kernel_length_scale_values)


if ~opts.kernelize 
    kernel_length_scale_values = 1;
end

N_train = size(X,1);
X = X(1:floor(opts.train_fraction * N_train),:);
y = y(1:floor(opts.train_fraction * N_train),:);
N_train = size(X,1);


chunk_size = floor(N_train/n);
N_train = chunk_size*n;
min_param_err = 100;

for chi = chi_values
    for small_sigma = small_sigma_values
        for kernel_length_scale = kernel_length_scale_values
            
            err = zeros(n,1);
            
            for test_num = 1:n
                test_indices = ((test_num-1)*chunk_size + 1): test_num*chunk_size;
                train_indices = setdiff(1:N_train, test_indices);
                Xtest = X(test_indices, :);
                X_train = X(train_indices,:);
                ytest = y(test_indices,:);
                y_train = y(train_indices,:);
                
                opt.chi = chi;
                ops.small_sigma = small_sigma;
                opts.kernel_length_scale = kernel_length_scale;
                
                opts.train_fraction = 1;
                
                [precision, ~, test_time] = run(percent_compression, X_train, y_train,phi,opts, Xtest, ytest);
                
                err(test_num) = 1 - precision;
                
            end
            
            param_err = mean(err);
            
            if param_err < min_param_err
                best_small_sigma = small_sigma;
                best_chi = chi;
                best_kernel_length_scale = kernel_length_scale;
                min_param_err = param_err;
            end
        end
        
    end
end


if ~opts.kernelize
    best_kernel_length_scale = [];
end


end