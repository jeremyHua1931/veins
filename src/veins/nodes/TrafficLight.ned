//
// Copyright (C) 2015-2018 Dominik Buse <dbuse@mail.uni-paderborn.de>
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

import org.car2x.veins.base.modules.*; // 导入Veins基础模块
import org.car2x.veins.modules.nic.Nic80211p; // 导入802.11p网络接口模块
import org.car2x.veins.modules.world.traci.trafficLight.TraCITrafficLightInterface; // 导入TraCITrafficLightInterface模块

// TrafficLight（交通灯）模块定义
module TrafficLight
{
    parameters: // 参数定义
        string logicType; // 逻辑类型参数
        string applType; // 应用层类型参数，指定应用层模块的类型
        string nicType = default("Nic80211p"); // 网络接口卡类型参数，默认为802.11p
        string externalId; // 交通灯管理的TraCI服务器id
    gates: // 门定义
        input veinsradioIn; // 用于sendDirect的输入门
    submodules: // 子模块定义
        appl: <applType> like org.car2x.veins.base.modules.ITrafficLightApplLayer { // 应用层模块定义
            parameters: // 参数定义
                @display("p=60,50"); // 在仿真界面中显示位置
        }
        
        nic: <nicType> like org.car2x.veins.modules.nic.INic80211p { // 网络接口卡模块定义
            parameters: // 参数定义
                @display("p=60,166"); // 在仿真界面中显示位置
        }

        mobility: BaseMobility { // 移动性模块定义
            parameters: // 参数定义
                @display("p=130,172;i=block/cogwheel"); // 在仿真界面中显示位置和图标
        }
        tlInterface: TraCITrafficLightInterface { // 交通灯TraCI接口模块定义
            @display("p=200,50"); // 在仿真界面中显示位置
        }

        logic: <logicType> like org.car2x.veins.base.modules.ITrafficLightLogic { // 交通灯逻辑模块定义
            @display("p=130,50"); // 在仿真界面中显示位置
        }

    connections: // 连接定义
        tlInterface.logic <--> logic.interface; // 连接交通灯TraCI接口到逻辑模块的接口
        appl.logic <--> logic.applLayer; // 连接应用层到逻辑模块的接口

        nic.upperLayerOut --> appl.lowerLayerIn; // 连接网络接口卡的上层输出到应用层的下层输入
        nic.upperLayerIn <-- appl.lowerLayerOut; // 连接网络接口卡的上层输入到应用层的下层输出
        nic.upperControlOut --> appl.lowerControlIn; // 连接网络接口卡的上层控制输出到应用层的下层控制输入
        nic.upperControlIn <-- appl.lowerControlOut; // 连接网络接口卡的上层控制输入到应用层的下层控制输出

        veinsradioIn --> nic.radioIn; // 连接输入门到网络接口卡的radioIn输入门，用于sendDirect操作
}
