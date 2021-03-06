classdef IR_sensor
    % IR_SENSOR Class
    % Defines the size and shape of the simulated IR sensor
    % Note: The sensor is treated as a continous sensor bar
    % Uses the InterX function to determine if the sensor bar overlaps 
    % with the target path and returns the position of the intersection 
    % from the bar center 
    
    properties          
        bar     % revisit this to match the number of sensor on the bar
        cross
        Crosses = []
        lastCross
        sensorLength  
        sensor_xarr
        sensor_yarr
        Q
    end
    
    methods 
        
        function obj = buildSensor(obj, x, y, theta, a, b)
            RendX = x + a*cos(theta - pi/b);    % Right end x
            RendY = y + a*sin(theta - pi/b);    % Right end y
        
            LendX = x + a*cos(theta + pi/b);    % Left end x 
            LendY = y + a*sin(theta + pi/b);    % Left end x
            
            obj.sensor_xarr = [LendX RendX];
            obj.sensor_yarr = [LendY RendY];
            
            obj.bar = [obj.sensor_xarr; obj.sensor_yarr];
            obj.sensorLength = sqrt(((obj.sensor_xarr(1)-obj.sensor_xarr(2)).^2 + (obj.sensor_yarr(1)-obj.sensor_yarr(2)).^2));            
        end   
    
        function obj = readBar(obj, Linex, Liney)
            line = [Linex; Liney];
            obj.Q = InterX(obj.bar, line);
            
            if isempty(obj.Q) == false
                obj.lastCross = obj.cross;
                obj.cross =  -1*((sqrt((obj.Q(1)-obj.sensor_xarr(2))^2 + (obj.Q(2)-obj.sensor_yarr(2))^2)-obj.sensorLength)/obj.sensorLength);
                obj.Crosses = [obj.Crosses, obj.cross];
                
                if obj.lastCross == obj.cross
                    obj.cross = 0; 
                end
            end
        end
          
        
    end    
end

