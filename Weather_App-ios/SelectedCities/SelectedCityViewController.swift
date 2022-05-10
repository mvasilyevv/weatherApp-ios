import Foundation
import RxSwift
import RxCocoa

// MARK: - protocols
protocol SelectedCityViewControllerDelegate: AnyObject {
    func fetchWeather(cityWeather: CityWeather)
}

class SelectedCityViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!

    // MARK: - let/var
    private let viewModel = SelectedCitiesViewModel()
    private let disposeBag = DisposeBag()
    weak var delegate: SelectedCityViewControllerDelegate?
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        bind()
        setupRowHeight()
        deleteItem()
        selectItem()
        view.addGradient(color: .day)
    }
    
    // MARK: - @IBAction
    @IBAction func selectCityButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as? CityListViewController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - flow funcs
    private func bind() {
        viewModel.selectedCityArray.subscribe { [weak self] event in
            self?.viewModel.updateWeatherInfo()
        }
        .disposed(by: disposeBag)
        
        viewModel.cityWeatherArray
            .bind(to: tableView.rx.items(cellIdentifier: SelectedCitiesTableViewCell.identifier, cellType: SelectedCitiesTableViewCell.self)) {
                row, element, cell in
                cell.backgroundColor = UIColor.clear
                cell.configure(weather: element)
            }
            .disposed(by: disposeBag)
    }
    private func selectItem() {
        tableView
            .rx
            .modelSelected(CityWeather.self)
            .subscribe { [weak self] model in
                guard let selectedCity = model.element else { return }
                self?.delegate?.fetchWeather(cityWeather: selectedCity)
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func setupRowHeight() {
        tableView.rowHeight = 60
    }
    private func deleteItem() {
        tableView
            .rx
            .itemDeleted
            .subscribe { [weak self] indexPath in
                guard var cityArray = self?.viewModel.selectedCityArray.value else { return }
                guard let indexPathRow = indexPath.element?.row else { return }
                cityArray.remove(at: indexPathRow)
                self?.viewModel.selectedCityArray.accept(cityArray)
                self?.viewModel.save()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - extensions
extension SelectedCityViewController: CityListViewControllerDelegate {
    func cellPressed(city: City) {
        self.viewModel.addCityInArray(city: city)
    }
}
