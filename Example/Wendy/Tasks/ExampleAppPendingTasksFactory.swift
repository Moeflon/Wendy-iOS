import Foundation
import Wendy

class ExampleAppPendingTasksFactory: PendingTasksFactory {
    func getTask(tag: PendingTask.Tag) -> PendingTask? {
        switch tag {
        case AddGroceryListItemPendingTask.tag:
            return AddGroceryListItemPendingTask()
        default: return nil
        }
    }
}
