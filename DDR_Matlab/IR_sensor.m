classdef IR_sensor
    %IR_SENSOR Summary of this class goes here
    %   Detailed explanation goes here
    
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
        
        function obj = buildSensor(obj, x, y, theta)
           
            RendX = x + 0.5*cos(theta - pi/3);  
            RendY = y + 0.5*sin(theta - pi/3); 
        
            LendX = x + 0.5*cos(theta + pi/3);
            LendY = y + 0.5*sin(theta + pi/3);
            
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

