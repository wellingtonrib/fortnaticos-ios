//
//  ProfileViewController.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 31/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit
import SnapKit

struct StatisticSection {
    var title: String!
    var image: UIImage!
    var statistics = [Statistic]()
}

struct Statistic {
    var title: String!
    var value: String!
}

class HomeViewController: BaseViewController {
    
    let userViewModel: UserViewModel = UserViewModel()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var kdLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    
    var statisticsTabViewController: StatisticsTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if self.userViewModel.getNickname() == nil {
            self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
        }
        
        self.registerObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userViewModel.refreshStats()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statisticsViewController = segue.destination as? StatisticsTabViewController {
            self.statisticsTabViewController = statisticsViewController
        }
    }

    @IBAction func changeUserAction(_ sender: Any) {
        self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
    }
    
    func registerObservers() {
        self.userViewModel.refreshedStats.observe { (userStats) in
            switch(userStats.status){
            case .LOADING:
                self.bindUserStats(userStats: userStats.data)
            case .SUCCESS:
                self.bindUserStats(userStats: userStats.data)
            case .ERROR:
                _ = self.alert(title: "Falha ao atualizar status", message: "")
            }
        }
    }
    
    func bindUserStats(userStats: StatsDTO?) {
        self.nicknameLabel.text = userStats?.data.account.name
        self.levelLabel.text = String(userStats?.data.battlePass.level ?? 0)
        self.winsLabel.text = String(userStats?.data.stats.all.overall.wins ?? 0)
        self.killsLabel.text = String(userStats?.data.stats.all.overall.kills ?? 0)
        self.kdLabel.text = String(userStats?.data.stats.all.overall.kd ?? 0.0)
        
        self.statisticsTabViewController?.clear()
        self.statisticsTabViewController?.addItem(item: self.buildStatisticController(stats: userStats?.data.stats.all.solo), title: "Solo")
        self.statisticsTabViewController?.addItem(item: self.buildStatisticController(stats: userStats?.data.stats.all.duo), title: "Duo")
        self.statisticsTabViewController?.addItem(item: self.buildStatisticController(stats: userStats?.data.stats.all.trio), title: "Trio")
        self.statisticsTabViewController?.addItem(item: self.buildStatisticController(stats: userStats?.data.stats.all.squad), title: "Squad")
        self.statisticsTabViewController?.build()
    }
    
    func buildStatisticController(stats: StatsValues?) -> StatisticsViewController {
        return StatisticsViewController(statisticsSections: [
                StatisticSection(title: "Royale", statistics: [
                    Statistic(title: "Score", value: String(stats?.score ?? 0)),
                    Statistic(title: "Wins", value: String(stats?.wins ?? 0)),
                    Statistic(title: "Kills", value: String(stats?.kills ?? 0)),
                    Statistic(title: "Deaths", value: String(stats?.deaths ?? 0)),
                    Statistic(title: "Matches", value: String(stats?.matches ?? 0)),
                    Statistic(title: "KD", value: String(stats?.kd ?? 0))
                ]),
                StatisticSection(title: "Colocação", statistics: [
                    Statistic(title: "Top1", value: String(stats?.wins ?? 0)),
                    Statistic(title: "Top10", value: String(stats?.top10 ?? 0)),
                    Statistic(title: "Top25", value: String(stats?.top25 ?? 0))
                ])
        ])
    }
    
}

class StatisticsTabViewController: UISimpleSlidingTabController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setHeaderActiveColor(color: .systemOrange)
        self.setHeaderInActiveColor(color: .white)
        self.setHeaderBackgroundColor(color: .systemPurple)
    }
}

class StatisticsViewController: UITableViewController {
    
    var statisticsSections = [StatisticSection]()
    
    convenience init() {
        self.init(statisticsSections: [])
    }

    init(statisticsSections: [StatisticSection]) {
        self.statisticsSections = statisticsSections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.statisticsSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statisticsSections[section].statistics.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.statisticsSections[section].title
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        titleLabel.font = UIFont(name: AppFonts.boldFont, size: 20)
        titleLabel.text = self.statisticsSections[section].title
        titleLabel.textColor = .systemPurple
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = #imageLiteral(resourceName: "crown")

        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.addSubview(imageView)
        headerView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (constraint) in
            constraint.width.height.equalTo(40)
            constraint.leading.top.bottom.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { (constraint) in
            constraint.left.equalTo(imageView.snp.right).offset(10)
            constraint.top.bottom.trailing.equalToSuperview().inset(10)
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "StatisticTableCell")
        let statistic = self.statisticsSections[indexPath.section].statistics[indexPath.row]
        cell.textLabel?.text = statistic.title
        cell.textLabel?.textColor = .darkGray
        cell.detailTextLabel?.text = statistic.value
        cell.detailTextLabel?.textColor = .darkGray
        return cell
    }
}

class SelectUserViewController: UIViewController {
    
    let userViewModel: UserViewModel = UserViewModel()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userViewModel.refreshedStats.observe { (userStats) in
            switch(userStats.status) {
            case .LOADING:
                self.showBlockingWaitOverlayWithText(text: "Carregando...")
            case .SUCCESS:
                self.removeAllBlockingOverlays()
                self.dismiss(animated: true, completion: nil)
            case .ERROR:
                self.removeAllBlockingOverlays()
            }
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        guard let nickname = self.nicknameTextField.text, !nickname.isEmpty else {
            _ = self.alert(title: "Informe o nickname", message: "")
            return
        }
        self.userViewModel.setNickname(nickname: nickname)
        self.userViewModel.refreshStats()
    }
    
}
