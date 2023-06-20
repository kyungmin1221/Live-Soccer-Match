
import UIKit
import FSCalendar

class PlanGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var planGroupTableView: UITableView!
    var planGroup: PlanGroup!
    var selectedDate: Date? = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planGroupTableView.dataSource = self
        planGroupTableView.delegate = self

        //planGroupTableView.isEditing = true
        
        fsCalendar.dataSource = self                // 칼렌다의 데이터소스로 등록
        fsCalendar.delegate = self                  // 칼렌다의 딜리게이트로 등록

        // 단순히 planGroup객체만 생성한다
        planGroup = PlanGroup(parentNotification: receivingNotification)
        planGroup.queryData(date: Date())       // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
        
        let leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:#selector(editingPlans1))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "Plan Group"

    }
    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let planGroup = planGroup{
            return planGroup.getPlans().count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell")!
  
        let plan = planGroup.getPlans()[indexPath.row]

        // 적절히 cell에 데이터를 채움
        //cell.textLabel!.text = plan.date.toStringDateTime()
        //cell.detailTextLabel?.text = plan.content
        
        (cell.contentView.subviews[2] as! UILabel).text = plan.date.toStringDateTime()
        //(cell.contentView.subviews[1] as! UILabel).text = plan.owner
        (cell.contentView.subviews[1] as! UILabel).text = plan.content
        
        (cell.contentView.subviews[0] as! UIImageView).image = UIImage(named: "cat.jpeg")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let plan = self.planGroup.getPlans(date: selectedDate)[indexPath.row]
            let title = "Delete \(plan.content)"
            let message = "Are you sure you want to delete this item?"

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                
                let plan = self.planGroup.getPlans()[indexPath.row]
                self.planGroup.saveChange(plan: plan, action: .Delete)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil) //여기서 waiting 하지 않는다
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let from = planGroup.getPlans()[sourceIndexPath.row]
        let to = planGroup.getPlans()[destinationIndexPath.row]
        planGroup.changePlan(from: from, to: to)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func saveChange(plan: Plan){

        if planGroupTableView.indexPathForSelectedRow != nil{
            planGroup.saveChange(plan: plan, action: .Modify)
        }else{
            planGroup.saveChange(plan: plan, action: .Add)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPlan"{
            let planDetailViewController = segue.destination as! PlanDetailViewController
            // plan이 수정되면 이 saveChangeDelegate를 호출한다
            planDetailViewController.saveChangeDelegate = saveChange
            
            // 선택된 row가 있어야 한다
            if let row = planGroupTableView.indexPathForSelectedRow?.row{
                // plan을 복제하여 전달한다. 왜냐하면 수정후 취소를 할 수 있으므로
                planDetailViewController.plan = planGroup.getPlans(date: selectedDate)[row].clone()
            }
        }

        if segue.identifier == "AddPlan"{
            let planDetailViewController = segue.destination as! PlanDetailViewController
            planDetailViewController.saveChangeDelegate = saveChange
                        
            // 빈 plan을 생성하여 전달한다
            planDetailViewController.plan = Plan(date:nil, withData: false)
            planGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            print("AddPlan")
        }
    }
    func receivingNotification(plan: Plan?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.planGroupTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
        fsCalendar.reloadData()     // 뱃지의 내용을 업데이트 한다
    }

}

extension PlanGroupViewController{
    @IBAction func editingPlans1(_ sender: UIBarButtonItem) {
        if planGroupTableView.isEditing == true{
            planGroupTableView.isEditing = false
            //sender.setTitle("Edit", for: .normal)
            sender.title = "Edit"
        }else{
            planGroupTableView.isEditing = true
            //sender.setTitle("Done", for: .normal)
            sender.title = "Done"
        }
    }
}
extension PlanGroupViewController{
    @IBAction func addingPlan1(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddPlan", sender: self)
    }
}


extension PlanGroupViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜가 선택되면 호출된다
        selectedDate = date.setCurrentTime()
        planGroup.queryData(date: date)
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 스와이프로 월이 변경되면 호출된다
        selectedDate = calendar.currentPage
        planGroup.queryData(date: calendar.currentPage)
    }

    // 이함수를 fsCalendar.reloadData()에 의하여 모든 날짜에 대하여 호출된다.
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let plans = planGroup.getPlans(date: date)
        if plans.count > 0 {
            return "[\(plans.count)]"    // date에 해당한 plans의 갯수를 뱃지로 출력한다
        }
        return nil
    }
}
