import UIKit
import RxSwift
import RxCocoa

// MARK: - protocols
protocol CityListViewControllerDelegate: AnyObject {
    func cellPressed(city: City)
}

class CityListViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - let/var
    weak var delegate: CityListViewControllerDelegate?
    private let viewModel = CityListViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        selectCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGradient(color: .day)
        textField.becomeFirstResponder()
    }
    
    // MARK: - @IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - flow funcs
    private func bind() {
        viewModel.cityArray
            .bind(to: tableView.rx.items(cellIdentifier: CityTableViewCell.identifier, cellType: CityTableViewCell.self)) {
                row, element, cell in
                cell.backgroundColor = UIColor.clear
                cell.configure(city: element)
            }
            .disposed(by: disposeBag)
    }
    private  func selectCity() {
        tableView
            .rx
            .modelSelected(City.self)
            .subscribe { model in
                guard let city = model.element else { return }
                self.delegate?.cellPressed(city: city)
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - extensions
extension CityListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.getCityArray(cityPrefix: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func hideKeyboard() {
        textField.resignFirstResponder()
    }
}
