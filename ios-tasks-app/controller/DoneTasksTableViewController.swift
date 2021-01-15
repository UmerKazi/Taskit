

import UIKit

class DoneTasksTableViewController: UITableViewController, Animatable {
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTasksListener()
    }
    
    
    private func addTasksListener() {
        
        guard let uid = authManager.getUserId() else {
            print("no user found")
            return }
        
        databaseManager.addTasksListener(forDoneTasks: true, uid: uid) { [weak self] (result) in
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
        databaseManager.updateTaskStatus(id: id, isDone: false) { [weak self] (result) in
            switch result {
            case .success:
                self?.showToast(state: .info, message: "Moved to Ongoing", duration: 2.0)
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription)
            }
        }
    }
    
}

extension DoneTasksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DoneTaskTableViewCell
        let task = tasks[indexPath.item]
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        return cell
    }
    
    
    
}
