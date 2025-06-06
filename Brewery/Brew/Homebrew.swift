//
//  Homebrew.swift
//  Brewery
//
//  Created by Pongt Chia on 5/6/25.
//

import Foundation

struct Homebrew {

    static func run(_ command: String = "list") throws -> String? {
        let process = Process()
        let pipe = Pipe()

        // 配置 Process
        process.executableURL = URL(filePath: "/opt/homebrew/bin/brew")
        // 分割命令字符串为参数数组，支持多词命令
        process.arguments = command.split(separator: " ").map { String($0) }
        process.standardOutput = pipe
        process.standardError = pipe

        // 设置 PATH，确保 Homebrew 能找到其二进制文件
        var environment = ProcessInfo.processInfo.environment
        environment["PATH"] =
            "/opt/homebrew/bin:/opt/homebrew/sbin:\(environment["PATH"] ?? "")"
        process.environment = environment

        do {
            try process.run()
            process.waitUntilExit()

            // 读取输出
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let result = String(data: data, encoding: .utf8) {
                return result
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}
