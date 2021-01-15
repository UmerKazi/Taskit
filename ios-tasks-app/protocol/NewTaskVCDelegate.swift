

import Foundation

protocol NewTaskVCDelegate: class {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}
