---
title: Humanoid Robot Learning
position: Humanoid Team
group:
    name: ETH Robotics Club
from: Fall 2026
to: present
highlights:
    - Trained a whole-body teleoperation and walking policy for the club's V1 humanoid (22 DoF) with InstantTrack in about one hour on a single GPU.
    - Made the policy robust to the real robot's IMU error and command latency, and validated it sim-to-sim against the robot's own drive and sensing models.
    - "[Online demo](https://ethroboticsclub.github.io/v1-walk-demo/): the trained policy walks the humanoid in MuJoCo in the browser, controlled with the keyboard or touch."
tags: [Python, PyTorch, Reinforcement Learning, MuJoCo, ONNX]
---

Robot learning for the ETH Robotics Club's humanoid robot: motion retargeting and learned whole-body control,
from training in simulation to deployment on the robot.
