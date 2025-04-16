//
//  BrewChecker.swift
//  Brewery
//
//  Created by Pongt Chia on 12/4/25.
//

import Foundation

struct BrewChecker {
    func isHomebrewInstalled() -> Bool {
        let process = Process()
        process.launchPath = "/usr/bin/which"
        process.arguments = ["brew"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        do {
            try process.run()
        } catch {
            debugPrint("Failed to run which command: \(error)")
            return false
        }
        
        process.waitUntilExit()
        
        let fileHandle = pipe.fileHandleForReading
        let data: Data
        do {
            if let outputData = try fileHandle.readToEnd() {
                data = outputData
            } else {
                return false // 无数据
            }
        } catch {
            print("Failed to read output: \(error)")
            return false
        }
        
        if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            // 如果输出不为空且路径存在，说明 Homebrew 已安装
            return !output.isEmpty && FileManager.default.fileExists(atPath: output)
        }
        
        return false
    }
    
    func checkHomebrewPath() -> Bool {
        // Homebrew 默认安装路径
        let possiblePaths = [
            "/opt/homebrew/bin/brew", // Apple Silicon
            "/usr/local/bin/brew"     // Intel
        ]
        
        // 检查任一路径是否存在可执行文件
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) && FileManager.default.isExecutableFile(atPath: path) {
                return true
            }
        }
        
        return false
    }
    
    func hasHomebrew() -> Bool {
        // 优先使用 which 命令检查，失败则检查路径
        return isHomebrewInstalled() || checkHomebrewPath()
    }
}
