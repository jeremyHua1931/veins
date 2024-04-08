//
// Copyright (C) 2008 Christoph Sommer <christoph.sommer@informatik.uni-erlangen.de>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// SPDX-License-Identifier: GPL-2.0-or-later
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package org.car2x.veins.nodes;

import org.car2x.veins.base.connectionManager.ConnectionManager; // 导入连接管理器
import org.car2x.veins.base.modules.BaseWorldUtility; // 导入基础世界工具模块
import org.car2x.veins.modules.mobility.traci.TraCIScenarioManager*; // 导入TraCI场景管理器
import org.car2x.veins.modules.obstacle.ObstacleControl; // 导入障碍控制模块
import org.car2x.veins.modules.world.annotations.AnnotationManager; // 导入注解管理器
import org.car2x.veins.nodes.Car; // 导入Car节点
import org.car2x.veins.visualizer.roads.RoadsCanvasVisualizer; // 导入道路画布可视化器

network Scenario // 场景网络定义
{
    parameters: // 参数定义
        double playgroundSizeX @unit(m); // 播放区域的X尺寸（单位：米）
        double playgroundSizeY @unit(m); // 播放区域的Y尺寸（单位：米）
        double playgroundSizeZ @unit(m); // 播放区域的Z尺寸（单位：米）
        @display("bgb=$playgroundSizeX,$playgroundSizeY"); // 在仿真界面中显示播放区域的大小
    submodules: // 子模块定义
        obstacles: ObstacleControl { // 障碍物控制器
            @display("p=240,50"); // 在仿真界面中显示位置
        }
        annotations: AnnotationManager { // 注解管理器
            @display("p=260,50"); // 在仿真界面中显示位置
        }
        connectionManager: ConnectionManager { // 连接管理器
            parameters: // 参数定义
                @display("p=150,0;i=abstract/multicast"); // 在仿真界面中显示位置和图标
        }
        world: BaseWorldUtility { // 基础世界工具模块
            parameters: // 参数定义
                playgroundSizeX = veins_eval_by_version(veins_omnetpp_buildnum(), "playgroundSizeX", 1525, "parent.playgroundSizeX"); // 设置播放区域的X尺寸
                playgroundSizeY = veins_eval_by_version(veins_omnetpp_buildnum(), "playgroundSizeY", 1525, "parent.playgroundSizeY"); // 设置播放区域的Y尺寸
                playgroundSizeZ = veins_eval_by_version(veins_omnetpp_buildnum(), "playgroundSizeZ", 1525, "parent.playgroundSizeZ"); // 设置播放区域的Z尺寸
                @display("p=30,0;i=misc/globe"); // 在仿真界面中显示位置和图标
        }
        manager: TraCIScenarioManagerLaunchd { // TraCI场景管理器
            parameters: // 参数定义
                @display("p=512,128"); // 在仿真界面中显示位置
        }
        roadsCanvasVisualizer: RoadsCanvasVisualizer { // 道路画布可视化器
            @display("p=300,0"); // 在仿真界面中显示位置
        }
        node[0]: Car { // Car节点
        }

    connections allowunconnected: // 允许未连接的连接
}
