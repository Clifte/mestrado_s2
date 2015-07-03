classdef MyLSSVM < handle
    
   properties
      train_features % features of training dataset
      train_labels % labels of training dataset
      gamma % trade-off between hit and error costs
      bias % bias of LSSVM classifier
      alphas % Lagrange multipliers of LSSVM classifier
      kernel % Kernel type
      sigma % variance for RBF Kernel
   end
   
   methods
      function obj = MyLSSVM(train_features, train_labels, params)
         obj.train_features = train_features;
         obj.train_labels = train_labels;
         obj.gamma = params.gamma;
         obj.bias = [];
         obj.alphas = [];
         obj.kernel = params.kernelFNC;
         obj.sigma = params.sigma;
      end
      
      function train(obj)
        % getting A.x = b problem
        A = obj.kernelFnc(obj.train_features) .* (obj.train_labels * obj.train_labels');
        A = A + (1/obj.gamma) * eye(size(obj.train_features,1));
        A = [obj.train_labels'; A];
        A = [[0; obj.train_labels] A];
        aux = ones(size(obj.train_features,1),1);
        b = [0; aux];
        clear aux;

        % make lssvm classifier
        x = A\b;

        
        obj.bias = [x(1,1)];
        obj.alphas = [x(2:size(obj.train_features,1) + 1 ,1)];
      end
      
      function result = classify(obj,test_features)
        %make decision function
        result = sign(sum(  ...
            obj.kernelFnc(test_features)  .* ...
            repmat(obj.alphas' .* obj.train_labels',size(test_features,1),1),2) + ...
            obj.bias);
      end
      
      
      
      function X = kernelFnc(obj,x)
          if(strcmp(obj.kernel,'RBF')==1)
              X =   pdist2( x, obj.train_features ) .^ 2;
              X = X / obj.sigma;
              X = exp(-X);
          end
          
          if(strcmp(obj.kernel,'linear')==1)
              X = x * obj.train_features';
          end          
      end

   end % methods
end % classdef 