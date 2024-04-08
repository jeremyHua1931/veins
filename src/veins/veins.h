//
// Copyright (C) 2006-2018 Christoph Sommer <sommer@ccs-labs.org>
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

/**
 * @mainpage %Veins - The open source vehicular network simulation framework.
 *
 * See the %Veins website <a href="http://veins.car2x.org/"> for a tutorial, documentation, and publications </a>.
 */

#pragma once // 使用预处理指令#pragma once，确保头文件只被编译一次

#include <memory> // 导入内存管理相关头文件
#include <utility> // 导入实用工具头文件

#include <omnetpp.h> // 导入OMNeT++核心头文件

// 定义Veins的版本号，包括主版本号、次版本号、补丁版本号和测试版本号
#define VEINS_VERSION_MAJOR 5
#define VEINS_VERSION_MINOR 2
#define VEINS_VERSION_PATCH 0
#define VEINS_VERSION_ALPHA 0

// 显式检查OMNeT++版本号，确保至少需要5.0.0版本
#if OMNETPP_VERSION < 0x500
#error 至少需要OMNeT++/OMNEST 5.0.0版本
#endif

// 导入整个omnetpp命名空间
namespace omnetpp {
}
using namespace omnetpp; // 使用omnetpp命名空间

// 定义VEINS_API宏，用于动态链接库的导出和导入
#if defined(VEINS_EXPORT)
#define VEINS_API OPP_DLLEXPORT // 导出符号
#elif defined(VEINS_IMPORT)
#define VEINS_API OPP_DLLIMPORT // 导入符号
#else
#define VEINS_API // 不导出或导入符号
#endif

// 宏用于标记已弃用的代码
#define VEINS_DEPRECATED _OPPDEPRECATED

// 方便使用的宏
#define RNGCONTEXT (cSimulation::getActiveSimulation()->getContext())-> // 获取随机数生成器上下文

/**
 * %Veins - 开源车载网络仿真框架。
 */
namespace veins {
#if (__cplusplus >= 201402L) || (defined __cpp_lib_make_unique)
using std::make_unique; // 使用C++14标准中的make_unique
#else
/**
 * 自定义的std::make_unique实现。
 *
 * 在Veins构建于C++14之前，提供了相同的功能。
 */
template <typename T, typename... Args>
std::unique_ptr<T> make_unique(Args&&... args)
{
    return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
}
#endif

// 查找模块的实现，根据模块路径查找模块对象
template <typename T>
cModule* findModuleByPath(T modulePath)
{
#if OMNETPP_BUILDNUM < 1506
    try {
        return cSimulation::getActiveSimulation()->getModuleByPath(modulePath);
    }
    catch (cRuntimeError) {
        return nullptr;
    }
#else
    return cSimulation::getActiveSimulation()->findModuleByPath(modulePath);
#endif
}

// 如果OMNeT++版本低于6.0，定义一些类型别名
#if OMNETPP_VERSION < 0x600
typedef long intval_t; // 整型值类型别名
typedef unsigned long uintval_t; // 无符号整型值类型别名
#endif

} // namespace veins
