classdef followMe
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        Linex
        Liney
        
        start = 0;
        lineEnd = 100;
        step = 10000;
       
        
    end
    
    methods
        
        function obj = buildSine(obj)

            pathTheta = linspace(obj.start,obj.lineEnd,obj.step);
            obj.Liney = pathTheta;
            obj.Linex = 2*sin(pathTheta);
            
        end
    
        function obj = buildCircle(obj)
            pathTheta = linspace(0*pi/180, 360*pi/180, 360);
            obj.Linex = 10*sin(pathTheta);
            obj.Liney = 10*cos(pathTheta);        
        end
        
        function obj = buildLine(obj)
            pathTheta = linspace(obj.start,obj.lineEnd,obj.step);   % theta values - realy for the cos and sin fuctions
            obj.Linex = -pathTheta;
            obj.Liney = pathTheta;
        end
        
        
    end
    
end

