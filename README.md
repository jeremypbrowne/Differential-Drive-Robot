# Differential-Drive-Robot
Independant Study Spring 2018
Purpose: Explore and implement Zeigler-Nichols auto tuning method for PID control on a line following robot

This repo contains a MATLAB simulation of a two-wheeled Differential Drive Robot (DDR) that utilizes feedback control to follow a given path. Path detection is accomplised by simulating a line sensor that detects the intersection of the path and line sesnor using the InterX function. The control objective is to drive the DDR along the given path, placing the path in the middle of the line sensor.

Path options: Straight line, Circle, and Sine Wave

Controller options: P, PD, PID using Zigler-Nichols to select appropriate gains
