import math


class Drone:

    def __init(self, x, y, r, L, baseSpeed, theta, phi, dt):
        self.x = x              # x-coordinate of center axel
        self.y = y              # y-coordinate center of axel
        self.lastX = []
        self.lastY = []

        self.phi = phi            # rotational velocity about center of axel (coordinates x and y)
        self.lastPhi = []

        self.r = r              # wheel radius
        self.L = L              # axel length

        self.theta = theta*math.pi/180          # Direction of travel relative to positive x-axis
        self.lastTheta = []

        self.baseSpeed = baseSpeed
        self.velR = 0           # DDR right wheel velocity
        self. velRs = []

        self.velL = 0           # DDR left wheel vel
        self.velLs = []
        self.velX = 0           # DDR velocity x - component
        self.velY = 0           # DDR velocity y - component

        self.velTot = 0         # total Velocity
        self.velTots = []       # record velocity

        self.dt = dt             # time step

    def drone_kinematics(self):
        self.phi = self.r * (self.velR-self.velL)/(2*self.L)

        self.lastTheta = self.theta
        self.theta = self.lastTheta + self.phi
        self.vx = (self.r / 2) * (self.velR + self.velL) * math.cos(self.theta)
        self.vy = (self.r / 2) * (self.velR + self.velL) * math.sin(self.theta)

        self.lastX = self.x
        self.lastY = self.y

        self.velTot = math.sqrt(pow(self.velX, 2) + pow(self.velY, 2))
