import math

class Drone():

    def __init__(self, x, y=0, radius=0, length=0, base_speed=0, theta=0, phi=0, dt=0):

        self.x = x              # x-coordinate of center axel
        self.y = y              # y-coordinate center of axel
        self.lastX = x
        self.lastY = y

        self.listX = []
        self.listY = []

        self.phi = phi          # rotational velocity about center of drone (coordinates x and y)
        self.lastPhi = []

        self.r = radius           # wheel radius
        self.L = length           # axel length

        self.theta = theta*math.pi/180       # Direction of travel relative to positive x-axis
        self.lastTheta = theta*math.pi/180

        self.baseSpeed = base_speed
        self.velR = base_speed           # DDR right wheel velocity
        self. velRs = []

        self.velL = base_speed           # DDR left wheel vel
        self.velLs = []
        self.velX = 0           # DDR velocity x - component
        self.velY = 0           # DDR velocity y - component

        self.velTot = 0         # total Velocity
        self.velTots = []       # record velocity
        self.dt = dt

    def drone_kinematics(self):
        self.phi = self.r * (self.velR-self.velL)/(2*self.L)

        self.lastTheta = self.theta
        self.theta = self.lastTheta + self.phi
        self.velX = (self.r / 2) * (self.velR + self.velL) * math.cos(self.theta)
        self.velY = (self.r / 2) * (self.velR + self.velL) * math.sin(self.theta)

        self.listX.append(self.x)
        self.listY.append(self.y)

        self.lastX = int(self.x)
        self.lastY = int(self.y)

        self.x = self.lastX + self.velX * self.dt
        self.y = self.lastY + self.velY * self.dt

        self.velTot = math.sqrt(pow(self.velX, 2) + pow(self.velY, 2))

    def kinematic_command(self, ileader_x, ileader_y, setpoint_x, setpoint_y):

        errorX = setpoint_x - ileader_x
        errorY = setpoint_y - ileader_y

        self.phi = self.r * (self.velR-self.velL)/(2*self.L)

        self.lastTheta = self.theta
        self.theta = self.lastTheta + self.phi
        self.velX = (self.r / 2) * (self.velR + self.velL) * math.cos(self.theta)
        self.velY = (self.r / 2) * (self.velR + self.velL) * math.sin(self.theta)

        self.listX.append(self.x + errorX)
        self.listY.append(self.y + errorY)

        self.lastX = int(self.x)
        self.lastY = int(self.y)

        self.x = self.lastX + self.velX * self.dt
        self.y = self.lastY + self.velY * self.dt

        self.velTot = math.sqrt(pow(self.velX, 2) + pow(self.velY, 2))