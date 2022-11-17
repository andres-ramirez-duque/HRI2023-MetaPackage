# HRI2023-MetaPackage
Anonymous repository submitted to HRI2023 conference

### Prerequisites

- Ubuntu 18.04
- [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu)

### Build the repository

The MetaPackage contain four catkin package.

On Jetson Nano, open a terminal, clone the tobo_perception repository on catkin workspace, update the dependencies and build the packages:

    $ catkin_make -DCMAKE_BUILD_TYPE=Release
    $ source ./devel/setup.bash
    
On Raspberry, open a terminal, clone the tobo_planner/uk_core/uk_web_gui repositories on catkin workspace, update the dependencies and build the packages:
