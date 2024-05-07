//
//  SHTimeUtils.swift
//  SihooSmart
//
//  Created by 西昊 on 2023/10/7.
//  Copyright © 2023 Shenzhen Sihoo Smart Furniture Co., Ltd. All rights reserved.
//

import UIKit

class SHTimeUtils: NSObject {
    /// 获取当前时间的毫秒数
        static var currentTimeStamp: String{
            return String(Int64(Date().timeIntervalSince1970 * 1000))
        }
        
        /// GCD定时器倒计时
        ///
        /// - Parameters:
        ///   - timeInterval: 间隔时间
        ///   - repeatCount: 重复次数
        ///   - handler: 循环事件,闭包参数: 1.timer 2.剩余执行次数
        static func dispatchCountDownTimer(timeInterval: TimeInterval, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
            
            if repeatCount <= 0 {
                return nil
            }
            let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            var count = 0
            timer.schedule(deadline: .now(), repeating: timeInterval)
            timer.setEventHandler {
                count += 1
                if count >= repeatCount {
                    timer.cancel()
                } else {
                    DispatchQueue.main.async {
                        handler(timer, count)
                    }
                }
                
            }
            timer.resume()
            return timer
        }
        
        static func dispatchCountDownTimer(timeInterval: TimeInterval, handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer? {
            let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            var callBack = false
            timer.schedule(deadline: .now(), repeating: timeInterval)
            timer.setEventHandler {
                if callBack {
                    DispatchQueue.main.async {
                        handler(timer)
                    }
                    timer.cancel()
                }
                callBack = true
            }
            timer.resume()
            return timer
        }
        
        /// GCD实现定时器
        ///
        /// - Parameters:
        ///   - timeInterval: 间隔时间
        ///   - handler: 事件
        ///   - needRepeat: 是否重复
        func dispatchTimer(timeInterval: TimeInterval, handler: @escaping (DispatchSourceTimer?) -> Void, needRepeat: Bool) {
            
            let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer.schedule(deadline: .now(), repeating: timeInterval)
            timer.setEventHandler {
                DispatchQueue.main.async {
                    if needRepeat {
                        handler(timer)
                    } else {
                        timer.cancel()
                        handler(nil)
                    }
                }
            }
            timer.resume()
            
        }
}
