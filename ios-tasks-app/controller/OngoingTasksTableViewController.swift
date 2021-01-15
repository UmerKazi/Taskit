

import UIKit
import Loaf

protocol OngoingTasksTVCDelegate: class {
    func showOptions(for task: Task)
}

class OngoingTasksTableViewController: UITableViewController, Animatable {
    
    private let databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: OngoingTasksTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTasksListener()
    }
    
    private func addTasksListener() {
        
        guard let uid = authManager.getUserId() else {
            print("no user found")
            return }
        
        databaseManager.addTasksListener(forDoneTasks: false, uid: uid) { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
        
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTaskStatus(id: id, isDone: true) { [weak self] (result) in
            switch result {
            case .success:
                self?.showToast(state: .info, message: "Moved to Done", duration: 2.0)
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
}


extension OngoingTasksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! OngoingTaskTableViewCell
        let task = tasks[indexPath.row]
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        cell.configure(with: task)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.item]
        delegate?.showOptions(for: task)
    }
    
    
}
