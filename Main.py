from Drone import Drone
import matplotlib.pyplot as plotter


leader = Drone(x=0, y=0, radius=5, length=5, base_speed=1, theta=0, phi=0, dt=1)
robot = Drone(x=0, y=0, radius=5, length=5, base_speed=1, theta=0, phi=0, dt=1)

# move robot
i = 1
while i < 20:
    print("Leadx: ", int(leader.x), " Leady: ", int(leader.y), "   robox: ", int(robot.x), " roboy: ", int(robot.y))

    leader.drone_kinematics()
    robot.kinematic_command(leader.x, leader.y, -5, 0)
    # robot.drone_kinematics()

    i = i+1

# plotter.figure()
# plotter.axes().set_aspect('equal')
plotter.scatter([leader.listX], [leader.listY])
plotter.scatter([robot.listX], [robot.listY])

plotter.show()


