classdef SevenState_13Param_QET < ExactTensorIonModel
    %TwoStateExactIonModel with uniform priors and 
    %overridden metric tensor
       
    methods(Access=public,Static)
        
        function obj = SevenState_13Param_QET(dcp_options)
            obj.kA=3; % 3 open states
            obj.h=0.01;
            obj.k = 13; %13 params
            if nargin == 1
                obj.options = dcp_options;
            else
                obj.options{1}=2;
                obj.options{2}=1e-12;
                obj.options{3}=1e-12;
                obj.options{4}=100;
                obj.options{5}=-1e6;
                obj.options{6}=0;
            end            
        end
               
        function Q = generateQ(params,conc)
            Q=zeros(5,5);
            
            %param array defined as follows
            
            %1  alpha2
            %2  beta2
            %3  alpha1a
            %4  beta1a
            %5  alpha1b
            %6  beta1b
            %7  k_{-2}a
            %8  k_{+2}a
            %9  k_{-2}b
            %10 k_{+2}b
            %11 k_{-1}a
            %12 k_{-1}b
            %13 k_{+1}b
            
            % k_{+1}a is set by mr (8*9*11*13)/(12*9*7)
            
            Q(1,1) = -params(1);
            Q(1,2) = 0;
            Q(1,3) = 0;
            Q(1,4) = params(1);
            Q(1,5) = 0;
            Q(1,6) = 0;
            Q(1,7) = 0;
            
            Q(2,1) = 0;
            Q(2,2) = -params(3);
            Q(2,3) = 0;
            Q(2,4) = 0;
            Q(2,5) = params(3);
            Q(2,6) = 0;
            Q(2,7) = 0;
            
            Q(3,1) = 0;
            Q(3,2) = 0;
            Q(3,3) = -params(5);
            Q(3,4) = 0;
            Q(3,5) = 0;
            Q(3,6) = params(5);
            Q(3,7) = 0;

            Q(4,1) = params(2);
            Q(4,2) = 0;
            Q(4,3) = 0;
            Q(4,5) = params(9);
            Q(4,6) = params(7);
            Q(4,7) = 0;
            Q(4,4) = -sum(Q(4,:));
            
            Q(5,1) = 0;
            Q(5,2) = params(4); 
            Q(5,3) = 0;
            Q(5,4) = params(10) * conc;
            Q(5,6) = 0;
            Q(5,7) = params(11);
            Q(5,5) = -sum(Q(5,:));
            
            Q(6,1) = 0;
            Q(6,2) = 0;
            Q(6,3) = params(6);
            Q(6,4) = params(8) * conc;
            Q(6,5) = 0;
            Q(6,7) = params(12);
            Q(6,6) = -sum(Q(6,:));
            
            Q(7,1) = 0;
            Q(7,2) = 0;
            Q(7,3) = 0;
            Q(7,4) = 0;
            Q(7,5) = conc*((params(8))*params(9)*(params(11))*(params(13)))/(params(12)*(params(10))*params(7)); %mr
            Q(7,6) = params(13) * conc;
            Q(7,7) = -sum(Q(7,:));
            
            
        end
        
        function sample = samplePrior()
            sample = [unifrnd(1e-2,1e6,[7 1]); unifrnd(1e-2,1e10);unifrnd(1e-2,1e6);unifrnd(1e-2,1e10);unifrnd(1e-2,1e6,[2 1]);unifrnd(1e-2,1e10)];         
        end
        
        function logPrior = calcLogPrior(params)
            if size(params,1) < size(params,2)
                params=params';
            end
            pdf = [unifpdf(params(1:7),1e-2,1e6); unifpdf(params(8),1e-2,1e10);unifpdf(params(9),1e-2,1e6) ;unifpdf(params(10),1e-2,1e10) ;unifpdf(params(11:12),1e-2,1e6);unifpdf(params(13),1e-2,1e10);];
            logPrior = sum(log(pdf));   
        end
        
        function derivLogPrior = calcDerivLogPrior(params)
            if isinf(SevenState_13Param_QET.calcLogPrior(params))
                derivLogPrior = -Inf;
            else
                derivLogPrior = 0;
            end   
        end        
    end
end
