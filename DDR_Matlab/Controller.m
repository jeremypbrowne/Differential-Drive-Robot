classdef Controller
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        target = 0.5;
        targets = []
        error = 0;
        lastError = 0;
        recordError = [];
        sumError = 0; 
        diffError = 0; 
        
        kp = 0;
        Ti =0;
        Td = 0;
        
        ki =0;
        kd =0;
        
        P =0;
        I =0;
        D =0;
        
        Ps = [];
        Is = [];
        Ds = [];
                
        ku = 20;
        kus = [];
        Tu =0;
        
        PID = 0;
        ULT = 0;
        ULTs = [];
        period = 1;
        j = 0;
        
        useTuner = false
        type
        
        
    end
    
    methods
        
        function obj = calcError(obj, cross, t)          
            obj.lastError = obj.error; 
            obj.error = obj.target - cross;
            obj.recordError = [obj.recordError, obj.error];  
            
                if obj.error<0 && obj.lastError>0 || obj.lastError<0 && obj.error>0 || obj.error == 0
                    
                   %obj.period = obj.error - obj.lastError;
                    obj.period = t - obj.j;
                    obj.j = t;
                    
                end
            
            
            obj.sumError = obj.error + obj.lastError;
            obj.diffError = obj.error - obj.lastError;
            obj.lastError = obj.error;
            
        end
                          
        function obj = findKUandTU(obj, cross)
            
            if obj.kp > abs(obj.ku) && obj.ku ~= inf && obj.useTuner == false
                
                obj.ULT = abs(obj.ku);
                obj.useTuner = true;
                obj = obj.autoTune(); 
                
            elseif obj.useTuner == false   
                AR = obj.PID/cross;     % amplitude ratio
                obj.ku = 1/AR;   
                
                obj.kp = obj.kp + 0.1;
                
            else 

                obj = obj.autoTune();                      
                
            end                
            
       end
                           
        function obj = correction(obj)            
          
            obj.P = obj.kp*obj.error;
            obj.I = obj.ki*obj.sumError;
            obj.D = obj.kd*(obj.diffError);
            
            obj.Ps = [obj.Ps, obj.P];
            obj.Is = [obj.Is, obj.I];
            obj.Ds = [obj.Ds, obj.D];
            
            obj.PID = obj.P + obj.I + obj.D;

        end
        
        function obj = simplePID(obj)
            obj.kp = 3;
            obj.ki = 0;
            obj.kd = 0;
            
            obj.P = obj.kp*obj.error;
            obj.I = obj.ki*obj.sumError;
            obj.D = obj.kd*(obj.error-obj.lastError);
                           
        end
        
        function obj = plots(obj)
            figure
            plot(1:1:length(obj.recordError),obj.recordError); grid on;
            xlabel('Time (sec)');
            ylabel('Error');
            
            figure
            subplot(3,1,1)
            plot(1:1:length(obj.Ps),obj.Ps); grid on;
            ylabel('P');
            subplot(3,1,2)
            plot(1:1:length(obj.Is),obj.Is); grid on;
            ylabel('I');
            subplot(3,1,3)
            plot(1:1:length(obj.Ds),obj.Ds); grid on;     
            ylabel('D');
            xlabel('Time (sec)');
            
        end  
        
        function obj = autoTune(obj)
        
        % P
        if obj.type == 1
            obj.kp = 0.5*obj.ULT;
                       
        % PI
        elseif obj.type == 2
            obj.kp = 0.45*obj.ULT;
            obj.Ti = obj.period/1.2;
            obj.ki = obj.kp*obj.Ti;
        
        % PD
        elseif obj.type == 3
            obj.kp = 0.8*obj.ULT;
            obj.Td = obj.period/8;
            obj.kd = obj.kp*obj.Td;
        
        % Classic
        elseif obj.type == 4
            obj.kp = 0.6*obj.ULT;
            obj.Ti = obj.period/2;
            obj.Td = obj.period/8;
        
            obj.ki = obj.kp*obj.Ti;
            obj.kd = obj.kp*obj.Td;
        
        % Pessen
        elseif obj.type == 5
            obj.kp = 0.7*obj.ULT;
            obj.Ti = obj.period/2.5;
            obj.Td = 3*obj.period/20;
        
            obj.ki = obj.kp*obj.Ti;
            obj.kd = obj.kp*obj.Td;
        
        elseif obj.type == 6
            
            obj.kp = 0.6*obj.ULT;
            obj.Ti = 1.2*obj.ULT/obj.period;
            obj.Td = 3*obj.ULT*obj.period/40;
            
            obj.ki = obj.kp*1/obj.Ti;
            obj.kd = obj.kp*obj.Td;
          
        
        % Some over shoot 
        elseif obj.type == 7
           
            obj.kp = 0.33*obj.ULT;
            obj.Ti = obj.period/2;
            obj.Td = obj.period/3;
        
            obj.ki = obj.kp*obj.Ti;
            obj.kd = obj.kp*obj.Td;
         
        % No overshoot
        elseif obj.type == 8
            
            obj.kp = 0.2*obj.ULT;
            obj.Ti = obj.period/2;
            obj.Td = obj.period/3;
        
            obj.ki = obj.kp*obj.Ti;
            obj.kd = obj.kp*obj.Td;
        end
           
        
        
        
        
        
        end
        
    
    end


end
