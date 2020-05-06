# Internal Communication
_This, together with the content, are duplicated from [HKU-RoboMaster](https://github.com/HKURoboMaster)_

_The repo aims at establishing a fast, simple, robust and secure
communication channels between components of the robots._ 

<img src="https://raw.githubusercontent.com/HKURoboMaster/HKURoboMaster.github.io/build/public/hku_square.png" width=10%><img src="https://rm-static.djicdn.com/robomasters/public/icons/icon_512.8MUsUIQNIAp.png" width=10%><img src="https://www.ucdavis.edu/sites/default/files/images/article/informal-seal-2col.jpg" width=10%>

## Briefing
### Background
The project is based on the [HKU-RoboMaster](https://hkurobomaster.github.io)
previous projects in constructing fighting robotics platforms to participate
in [RoboMaster Competition](https://www.robomaster.com/) and
[ICRA RoboMaster AI Challenge](https://www.robomaster.com/en-US/robo/icra). 

<img src="https://raw.githubusercontent.com/HKURoboMaster/HKURoboMaster.github.io/build/src/img/AI_infantry.png" width=40%>

_Robotics platform of the RoboMaster AI challenge_

As for the solution the **HKU-RoboMaster** provides for the competitions and
the AI Challenge, each robot is controlled by a upper computer (a. k. a. _PC_).
The computer communicates with and then instructs another two microcontrollers
via UART, using 
[a self designed protocol](https://github.com/HKURoboMaster/automation_2019/blob/infantry/doc/en/protocol.md). 
The two microcontroller are responsible
for the motors on the chassis or gimbal respectively. Each of them controls several
motors, such as the wheel motors, the yaw motors, the pitch motors, and the trigger
motors, etc. The upper computer runs a _Ubuntu_ operation system where the major CV
application and the AI application which direct the robot action are executed within.
The two micro controllers, however, runs a real time operation system based on
FreeRTOS, whose application level logic has been customized and tuned by HKU
RoboMaster Team for competition purpose. 

![System architecture](https://raw.githubusercontent.com/HKURoboMaster/automation_2019/infantry/doc/image/frame.png)

_This illustrates the system architecture of the code running on the micro
controller side. The "protocol", "infantry-cmd" and "communicate" modules are
where we are to expect our interfaces being invoked._

### Security issue

It is ought to note that when a robot is started in AI mode, it can be **aggressive**,
as it carries a gun which shoot plastic projectiles. The diameter of the projectiles
is either **17mm** or **40mm**, and their speed can be as fast as **60mph (27m/s)**. Although
it can never be compared with a military weapon, it can however, lead to certain
damage or hurt. We regard it as a thread that: 

1. if the upper computer is broken into, malicious controlling code can be send
to the microcontrollers which will faithfully execude the commands, or
1. if the hardware connection gets modified unauthorizedly, thus, another unknown
computer pretends itself as the upper computer and send commands out.
(i.e. man-in-middle attack). 

Both may lead to uncontrolled beharviors and may result in damages. The [protocol]((https://github.com/HKURoboMaster/automation_2019/blob/infantry/doc/en/protocol.md)),
however, doest not provide any protection or verification. The `pdata` field is
transmitted in plain text. Moreover, as the upper computer requires to receive debugging
data or manually instructions from the programmers, its `ssh` port is left open,
making it feasible for the hacker to remotely break in. 

### Solution to be implemented within this project

This project aims at solving the problem, by providing libraries to encrypt the
data carried within the UART packets, with out adding too much complexity nor
overhead. Detailed requirements as follows:

1. It cannot be **too mathematically hard** in encryption and descrytion, since the
microcontrollers are barely STM32 chips and cannot afford a complex algorithm.
1. It cannot contains **large overhead**, since the robotics system are highly real-time,
where minor delay can cause disastrous outcomes. 
1. Given unavoidable overhead, the **delay has to be constant**, making the result
being predictable
1. **Simple interfaces** ought to be offered to the programmer. 

Based on these requirements, we are considering using the following **mechanism**:
1. Upper computer contains a "certification" file for verification.
1. At the very begining of communication, i.e. both side just being booted,
two hosts conduct the verification and negotiate the secrete key under an
asymmetric encryption.
1. During the communication, data is encrypted under a symetric algorithm
with the secrete key just being negotiated.

## Declaration

The project is a part of the HKU RoboMaster teamwork, propoused by Mr. David Y.
H. Liu and being a part of his ECS153 project during his exchange in UC Davis.
