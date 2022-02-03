/*
 * Copyright 1996-2022 Cyberbotics Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <webots/motor.h>
#include <webots/position_sensor.h>
#include <webots/robot.h>

#define TIME_STEP 32
#define OPEN_HAND 0
#define CLOSE_HAND 1

enum Joint { JOINT1, JOINT2, JOINT3, JOINT4, JOINT5, JOINT6, JOINT7, FINGER1, FINGER2 };

static WbDeviceTag motors[9];
static WbDeviceTag sensors[9];

void hand_control(int state) {
  if (state == OPEN_HAND) {
    wb_motor_set_position(motors[FINGER1], 0.02);
    wb_motor_set_position(motors[FINGER2], 0.02);
  } else {
    wb_motor_set_position(motors[FINGER1], 0);
    wb_motor_set_position(motors[FINGER2], 0);
  }
}

int main(int argc, char **argv) {
  wb_robot_init();

  char device_name[30];

  for (int i = 0; i < 9; ++i) {
    const char *prefix = i < 7 ? "panda_joint" : "panda_finger_joint";
    int offset = i < 7 ? 0 : 7;
    sprintf(device_name, "%s%d", prefix, i + 1 - offset);
    motors[i] = wb_robot_get_device(device_name);
    sprintf(device_name, "%s%d_sensor", prefix, i + 1 - offset);
    sensors[i] = wb_robot_get_device(device_name);
    wb_position_sensor_enable(sensors[i], TIME_STEP);
  }

  while (wb_robot_step(TIME_STEP) != -1) {
    // grasp
    // hand_control(OPEN_HAND);
  };

  wb_robot_cleanup();

  return 0;
}
