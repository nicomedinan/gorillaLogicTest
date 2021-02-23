//
//  HomeViewController.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.then {
                $0.delegate = presenter
                $0.dataSource = presenter
                $0.rowHeight = 75.0
            }
        }
    }
    
    @IBOutlet private weak var dataZeroLabel: UILabel! {
        didSet {
            dataZeroLabel.then {
                $0.textColor = .orange
                $0.text = "No data available"
                presenter.dataZeroObservable.subscribe(onNext: { [weak self] (isEmpty) in
                    self?.dataZeroLabel.isHidden = !isEmpty
                    self?.tableView.isHidden = isEmpty
                }).disposed(by: disposeBag)
            }
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.sizeToFit()
        searchBar.tintColor = .white
        searchBar.delegate = presenter
        return searchBar
    }()
    
    // MARK: - Rx
    private var disposeBag = DisposeBag()
    
    // MARK: - Logic
    private var presenter: HomePresentable
    
    init(presenter: HomePresentable) {
        self.presenter = presenter
        let nibName = String(describing: HomeViewController.self)
        let bundle = Bundle.main
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        registerCells()
        bindPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Private methods
private extension HomeViewController {
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        
        searchBar.placeholder = "Search"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.titleView = searchBar
        searchBar.searchTextField.leftView?.tintColor = .white
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            
            let textFieldInsideSearchBarLabel = searchTextField.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = .white

            let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton
            if let img = clearButton?.image(for: .highlighted) {
                clearButton?.isHidden = false
                let tintedClearImage = img.imageWithColor(color1: UIColor.white)
                clearButton?.setImage(tintedClearImage, for: .normal)
                clearButton?.setImage(tintedClearImage, for: .highlighted)
            }else{
                clearButton?.isHidden = true
            }
        }
    }
    
    @objc func reload() {
        presenter.handle(action: .reload)
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    func bindPresenter() {
        presenter.reloadDataObservable.subscribe(onNext: { [weak self] () in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}
