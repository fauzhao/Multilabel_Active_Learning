function [W,phi,opts] = train_mod(X,y, K, opts, phi, rand_initialize, W, G)

L = size(y,2); %#(true labels)

%noise parameters
chi = opts.chi;
small_sigma = opts.small_sigma;
%number of update iterations
maxiter = opts.train_maxiter;

d = size(X,2); %#(num features)
N = size(X,1); %#(num examples)

%initialization
Z(1:N) = struct('mu',zeros(K,1),'sigma',eye(K));
if rand_initialize == 1
	W(1:K) = struct('mu',zeros(d,1),'sigma',eye(d));
end
for i = 1:N
    Z(i).sigma = ((small_sigma^2 * chi^2) / (small_sigma^2 + chi^2)) * eye(K,K);
end


temp = (concat_struct_attr(Z,'mu'));

for t = 1:maxiter
    
    if mod(t,100) == 0
        if norm(temp_old - temp(:)) / norm(temp) < 1e-6
            %break;
        end
    end
    
    for i = 1:N
        x_i = X(i,:);
        y_i = (y(i,:))';
        
        %update Z(i)
        Z(i).mu = Z(i).sigma * ( (small_sigma^-2 * (concat_struct_attr(W,'mu') * x_i')) + ( chi^(-2) * phi * y_i)  );
        
    end
    
    temp_old = temp(:);
    temp = (concat_struct_attr(Z,'mu'));
    
    %update W(i)     
    for k = 1:K
        W(k).mu = G * temp(:,k);
    end
    
end

end
