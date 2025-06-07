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

enum BrewTerminology: String, CaseIterable {
    case formulae, casks
}

/**
 Usage: brew list, ls [options] [installed_formula|installed_cask ...]

 List all installed formulae and casks. If formula is provided, summarise the
 paths within its current keg. If cask is provided, list its artifacts.

       --formula, --formulae        List only formulae, or treat all named
                                    arguments as formulae.
       --cask, --casks              List only casks, or treat all named arguments
                                    as casks.
       --full-name                  Print formulae with fully-qualified names.
                                    Unless --full-name, --versions or
                                    --pinned are passed, other options (i.e.
                                    -1, -l, -r and -t) are passed to
                                    ls(1) which produces the actual output.
       --versions                   Show the version number for installed
                                    formulae, or only the specified formulae if
                                    formula are provided.
       --multiple                   Only show formulae with multiple versions
                                    installed.
       --pinned                     List only pinned formulae, or only the
                                    specified (pinned) formulae if formula are
                                    provided. See also pin, unpin.
       --installed-on-request       List the formulae installed on request.
       --installed-as-dependency    List the formulae installed as dependencies.
       --poured-from-bottle         List the formulae installed from a bottle.
       --built-from-source          List the formulae compiled from source.
   -1                               Force output to be one entry per line. This
                                    is the default when output is not to a
                                    terminal.
   -l                               List formulae and/or casks in long format.
                                    Has no effect when a formula or cask name is
                                    passed as an argument.
   -r                               Reverse the order of the formulae and/or
                                    casks sort to list the oldest entries first.
                                    Has no effect when a formula or cask name is
                                    passed as an argument.
   -t                               Sort formulae and/or casks by time modified,
                                    listing most recently modified first. Has no
                                    effect when a formula or cask name is passed
                                    as an argument.
   -d, --debug                      Display any debugging information.
   -q, --quiet                      Make some output more quiet.
   -v, --verbose                    Make some output more verbose.
   -h, --help                       Show this message.
 */
