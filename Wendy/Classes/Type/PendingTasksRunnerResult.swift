import Foundation

public struct PendingTasksRunnerResult {
    let numberTasksRun: Int
    let numberSuccessfulTasks: Int
    let numberCancelledTasks: Int
    let numberFailedTasks: Int
    let numberSkippedTasks: Int
    let runResults: [TaskRunResult]

    static func new(results: [TaskRunResult]? = nil) -> PendingTasksRunnerResult {
        var runnerResult = PendingTasksRunnerResult(numberTasksRun: 0, numberSuccessfulTasks: 0, numberCancelledTasks: 0, numberFailedTasks: 0, numberSkippedTasks: 0, runResults: [])

        results?.forEach { result in
            runnerResult = runnerResult.addResult(result)
        }

        return runnerResult
    }

    func addResult(_ runResult: TaskRunResult) -> PendingTasksRunnerResult {
        var numberSuccessfulTasks = self.numberSuccessfulTasks
        var numberCancelledTasks = self.numberCancelledTasks
        var numberFailedTasks = self.numberFailedTasks
        var numberSkippedTasks = self.numberSkippedTasks
        var runResults = self.runResults

        switch runResult {
        case .successful:
            numberSuccessfulTasks += 1
        case .cancelled:
            numberCancelledTasks += 1
        case .failure:
            numberFailedTasks += 1
        case .skipped:
            numberSkippedTasks += 1
        }

        runResults.append(runResult)

        return PendingTasksRunnerResult(numberTasksRun: runResults.count, numberSuccessfulTasks: numberSuccessfulTasks, numberCancelledTasks: numberCancelledTasks, numberFailedTasks: numberFailedTasks, numberSkippedTasks: numberSkippedTasks, runResults: runResults)
    }
}

public extension PendingTasksRunnerResult {
    /**
     Get first [TaskRunResult] that was a failed attempt. Note: This failed attempt could have been a task that failed or one that skipped.
     */
    var firstFailedResult: TaskRunResult? {
        return runResults.first(where: { runResult in
            switch runResult {
            case .failure, .skipped:
                return true
            case .cancelled, .successful:
                return false
            }
        })
    }

    /**
     cancelled are OK. They count as successful. Skipped means that they need to be run again so, that's not successful.
     */
    var successful: Bool {
        return firstFailedResult == nil
    }
}