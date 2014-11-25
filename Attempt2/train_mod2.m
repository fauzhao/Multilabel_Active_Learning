function [W,phi,opts] = train_mod2(X,y,K,opts)

L = size(y,2); %#(true labels)

%noise parameters
chi = opts.chi;
small_sigma = opts.small_sigma;
%number of update iterations
maxiter = opts.maxiter;

G = X' * X; %Gram matrix
d = size(X,2); %#(num features)
N = size(X,1); %#(num examples)

%random projection matrix
phi = rand(K,L);

%initialization
Z(1:N) = struct('mu',zeros(K,1),'sigma',eye(K));
W(1:K) = struct('mu',zeros(d,1),'sigma',eye(d));

for k = 1:K
    W(k).sigma = pinv(small_sigma^(-2) * G + eye(d));
end


for i = 1:N
    Z(i).sigma = ((small_sigma^2 * chi^2) / (small_sigma^2 + chi^2)) * eye(K,K);
end

%train examples


for t = 1:maxiter
    
    if mod(t,100) == 0
        fprintf('Training iteration: %d\n', t);
    end
    
    for i = 1:N     
        x_i = X(i,:);
        y_i = (y(i,:))';
        
        %update Z(i)
        Z(i).mu = Z(i).sigma * ( (small_sigma^-2 * (concat_struct_attr(W,'mu') * x_i')) + ( chi^(-2) * phi * y_i)  );
        
    end
    
    for k = 1:K
        %update W(i)
        temp = (concat_struct_attr(Z,'mu'));
        W(k).mu = (small_sigma)^(-2) * W(k).sigma * X' * temp(:,k);
    end
    
end

end
