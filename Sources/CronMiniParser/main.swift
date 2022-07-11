import ArgumentParser

enum Command {}

enum Day: String {
    case today
    case tomorrow
}

extension Command {
    struct Main: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(
                commandName: "CronMiniParser",
                abstract: "A program to parse a cron file and give the next run time",
                version: "0.0.1",
                subcommands: []
            )
        }
        
        @Argument(help: "Simulated current time")
        var currentTime: String
        
        @Argument(help: "Minutes past the hour")
        var cronMins: String
        
        @Argument(help: "Hour of the day")
        var cronHours: String
        
        @Argument(help: "Command to run")
        var cronCommand: String
        
        func run() throws {
            let separatedCurrenTime = currentTime.split(separator: ":")
            let currentMin = Int(separatedCurrenTime.last!)!
            let currentHour = Int(separatedCurrenTime.first!)!
            
            var resultMin: Int?
            var resultHour: Int?
            var resultDay: Day?
            
            if (cronMins == "*") {
                if (cronHours == "*") {
                    resultMin = currentMin
                    resultHour = currentHour
                    resultDay = .today
                } else {
                    guard let cronHours = Int(cronHours) else { return }
                    
                    if (currentHour == cronHours) {
                        if (currentMin == 59) {
                            resultMin = currentMin
                            resultHour = cronHours
                            resultDay = .today
                        } else {
                            resultMin = currentMin + 1
                            resultHour = currentHour
                            resultDay = .today
                        }
                    } else {
                        resultMin = 0
                        resultHour = cronHours
                        resultDay = currentHour - cronHours > 0 ? .tomorrow : .today
                    }
                }
            } else {
                if (cronHours == "*") {
                    guard let cronMins = Int(cronMins) else { return }
                    
                    if (currentMin > cronMins) {
                        if (currentHour == 23) {
                            resultMin = cronMins
                            resultHour = 0
                            resultDay = .tomorrow
                        } else {
                            resultMin = cronMins
                            resultHour = currentHour + 1
                            resultDay = .today
                        }
                    } else if (currentMin < cronMins) {
                        resultMin = cronMins
                        resultHour = currentHour
                        resultDay = .today
                    } else {
                        resultMin = currentMin
                        resultHour = currentHour
                        resultDay = .today
                    }
                } else {
                    guard let cronHours = Int(cronHours) else { return }
                    guard let cronMins = Int(cronMins) else { return }
                    
                    if (currentHour > cronHours) {
                        resultMin = cronMins
                        resultHour = cronHours
                        resultDay = .tomorrow
                    } else if (currentHour < cronHours){
                        resultMin = cronMins
                        resultHour = cronHours
                        resultDay = .today
                    } else {
                        if (currentMin > cronMins) {
                            resultMin = cronMins
                            resultHour = cronHours
                            resultDay = .tomorrow
                        } else {
                            resultMin = cronMins
                            resultHour = cronHours
                            resultDay = .today
                        }
                    }
                }
            }
            
            guard let resultHour = resultHour else { return }
            guard let resultMin = resultMin else { return }
            
            var resultMinString = "\(resultMin)"
            var resultHourString = "\(resultHour)"
            
            if (resultMin < 10) {
                resultMinString += "0"
            }
            
            if (resultHour < 10) {
                resultHourString = "0" + resultHourString
            }
            
            print("\(resultHourString):\(resultMinString) \(resultDay!) - \(cronCommand)")
            
        }
    }
}

func readSTDIN () -> String? {
    var input: String?
    
    while let line = readLine() {
        if input == nil {
            input = line
        } else {
            input! += "\n" + line
        }
    }
    
    return input
}

var text: String?
if CommandLine.arguments.count == 1 || CommandLine.arguments.last == "-" {
    if CommandLine.arguments.last == "-" { CommandLine.arguments.removeLast() }
    text = readSTDIN()
} else {
    do {
        try Command.Main.parseOrExit(Array(CommandLine.arguments.dropFirst())).run()
    } catch {
        Command.Main.exit(withError: error)
    }
}

if let text = text {
    let parsedLines = text.split(separator: "\n")
        
    for line in parsedLines {
        let parsedArguments = line.split(separator: " ")
        var programArguments = Array(CommandLine.arguments.dropFirst())
        
        for (index, argument) in parsedArguments.enumerated() {
            programArguments.insert(String(argument), at: index)
        }
        
        do {
            try Command.Main.parseOrExit(programArguments).run()
        } catch {
            Command.Main.exit(withError: error)
        }
    }
}
