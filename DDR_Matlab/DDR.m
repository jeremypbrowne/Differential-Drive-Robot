classdef DDR
    %DDR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        r       % DDR wheel radius (in)
        L        % DDR axle lenght  (in)
        
        x             % x-coordinate of center axel of DDR
        y             % y-coordinate of center axel of DDR
        LastX = []
        LastY = []
        
        phi         % Rotation about the center of the DDR's axel
        LastPhi = []

        theta       % Direction of travel for the DDR
        LastTheta = []
        
        baseSpd
        vr      % DDR right wheel vel
        vrs = []
        vL      % DDR left wheel vel
        vLs = []
        vx      % DDR axel velocity x-component
        vy      % DDR axel velocity y-component
        
        Vtot   % total Velocity
        vs = [] % record velocity 
        
        dt     % time step               
        
    end
    
    methods % DDR Kinematics
       
        function obj = DDR_Kinematics(obj)
            % Update Inertial coordinates
            obj.phi = obj.r *(obj.vr-obj.vL)/(2*obj.L);
%             if obj.phi > 2*pi
%                 obj.phi = 2*pi;
%             end
            obj.LastTheta = obj.theta;
            obj.theta = obj.LastTheta + obj.phi;
            obj.vx = (obj.r/2)*(obj.vr+obj.vL)*cos(obj.theta);
            obj.vy = (obj.r/2)*(obj.vr+obj.vL)*sin(obj.theta);

            % Update position of robot in Inertial frame
            obj.LastX = obj.x;
            obj.LastY = obj.y;
        
            obj.x = obj.LastX + obj.vx*obj.dt;
            obj.y = obj.LastY + obj.vy*obj.dt;
        
            obj.Vtot = sqrt(obj.vx^2 + obj.vy^2);
            obj.vs = [obj.vs, obj.Vtot];
        end 
        
        function obj = searchPATalpha(obj)
            
            obj.vr = obj.baseSpd;
            obj.vrs = [obj.vrs, obj.vr];
            obj.vL = obj.baseSpd;
            obj.vLs = [obj.vLs, obj.vL];

            obj = obj.DDR_Kinematics();
            
            
%             if i == 50
%                 obj.vr = 0;
%                 obj.vL = 0;
%                 obj.theta = obj.theta + 20;
%                 i=0;
%             end       
                                                       
        end
        
        
        function obj = plots(obj)
            figure
            plot(1:1:length(obj.vs),obj.vs, 1:1:length(obj.vrs),obj.vrs, 1:1:length(obj.vLs),obj.vLs); grid on;
            ylabel('Velocity');
            xlabel('Time (sec)');
        
        end   
        
            
    end
    
end

