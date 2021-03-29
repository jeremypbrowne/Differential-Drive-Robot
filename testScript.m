% DDR simulation
clear;clc;close all;

line = followMe;
% line = line.buildSine();
line = line.buildCircle();
% line = line.buildLine();

% Set up Robot 
robot = DDR; 
robot.baseSpd = 0.75;
robot.r = 5;
robot.L = 5;
robot.x = 0;
robot.y = -5;
robot.phi = 0;
robot.theta = 100*pi/180;
robot.dt = 0.02;

%Set up Sensor
a = 0.5;
b = 3; % controls how for out the sensor is
sensor = IR_sensor;
sensor = sensor.buildSensor(robot.x, robot.y, robot.theta, a, b);

% Set up Controller
control = Controller;
control.type = 8;

figure;
 plot(line.Linex, line.Liney,'g','Linewidth',3);
 axis('equal'); hold; grid on;

while isempty(sensor.Q) == true
  
    robot = robot.searchPATalpha()
    sensor = sensor.buildSensor(robot.x, robot.y, robot.theta, a, b);
    sensor = sensor.readBar( line.Linex, line.Liney)
    
    n = scatter(robot.x,robot.y, 300,'m');
    q = plot(sensor.bar(1,:) , sensor.bar(2,:));
    xlim([(robot.x)-5, (robot.x)+5]);
    ylim([(robot.y)-5, (robot.y)+5]);
    pause(2/1000000000);
    delete(n);
    delete(q);  
   
end

i = 1;

while i > 0
     control = control.calcError(sensor.cross, i*robot.dt) ;
     control = control.findKUandTU(sensor.cross);
     control = control.correction()
  %  control = control.simplePID()
     
%     if control.ULT ~=0
%         robot.baseSpd = robot.baseSpd + 0.001;
%     end
  
    robot.vr = robot.baseSpd + control.PID;
    robot.vrs = [robot.vrs, robot.vr];
    robot.vL = robot.baseSpd - control.PID;
    robot.vLs = [robot.vLs, robot.vL];
    robot = robot.DDR_Kinematics();
     
    sensor = sensor.buildSensor(robot.x, robot.y, robot.theta, a, b);
    sensor = sensor.readBar( line.Linex, line.Liney);
    
    n = scatter(robot.x, robot.y, 250,'m');
    q = plot(sensor.bar(1,:) , sensor.bar(2,:));
    
    xlim([(robot.x)-3, (robot.x)+3]);
    ylim([(robot.y)-3, (robot.y)+3]);
    pause(1/100);
     delete(n);
     delete(q);
   i = i+1; 
%    if isempty(sensor.Q) == true
%        break;
%    end

     if mod(i,300) == 0
         control.target = control.target + 0.1;
         control.targets = [control.targets, control.target];
     end
     
     if i==900
        break;
     end
end


figure
plot(1:1:length(control.targets),control.targets,1:1:length(sensor.Crosses),sensor.Crosses); 
grid on;

control = control.plots;
robot = robot.plots;

