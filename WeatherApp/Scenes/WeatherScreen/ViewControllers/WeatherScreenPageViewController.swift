//
//  WeatherScreenPageViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 05.04.2023.
//

import UIKit

protocol IWeatherScreenPageViewController: AnyObject {
    
    func setupPageViewController(
        with viewModels: [WeatherModel.ViewModel],
        pageIndex: Int
    )
    
    func updateViewControllers(
        with viewModels: [WeatherModel.ViewModel]
    )
}

final class WeatherScreenPageViewController: UIPageViewController {
    
    // MARK: Constants
    
    private var currentPageIndex = 0
    
    private var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    // MARK: - Internal Properties
    
    var coordinator: ICoordinator?
    var presenter: IWeatherScreenPresenter!
    
    // MARK: - Private Properties
    
    private var pageControl: UIPageControl!
    
    private lazy var pages: [UIViewController] = []
    private lazy var backgroundGradient = BackgroundGradientLayer()
    
    private var viewModels: [WeatherModel.ViewModel] = []
    
    // MARK: - Initialisers
    
    init() {
        super.init(
            transitionStyle: UIPageViewController
                .TransitionStyle
                .scroll,
            navigationOrientation: UIPageViewController
                .NavigationOrientation
                .horizontal
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden Methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundGradient.configure(
            with: presenter
                .getViewModel(by: currentIndex)
                .current
                .backgroundColor
        )
        
        backgroundGradient.frame = view.bounds
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        setupPageControl()
        setupNavigationBar()
        
        presenter.render()
    }
    
    // MARK: - Private Methods
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = presenter.numberOfPages()
        pageControl.currentPage = currentPageIndex
        pageControl.setIndicatorImage(
            UIImage(systemName: "location.fill"),
            forPage: 0
        )
    }
    
    private func setupNavigationBar() {
        guard let navigationController = navigationController else { return }
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "map",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: nil
        )
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "magnifyingglass",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: #selector(search)
        )
        let pageControlItem = UIBarButtonItem(customView: pageControl)
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        
        let items = [
            leftBarButtonItem,
            spacer,
            pageControlItem,
            spacer,
            rightBarButtonItem
        ]
        
        if !navigationController
            .toolbar
            .subviews
            .contains(
                where: { $0 is UIVisualEffectView }
            ) {
            let blurEffect = UIBlurEffect(style: .light)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            let height = view.bounds.maxY - navigationController.toolbar.bounds.minY
            visualEffectView.frame = CGRect(
                x: navigationController.toolbar.bounds.minX,
                y: navigationController.toolbar.bounds.minY,
                width: navigationController.toolbar.bounds.width,
                height: height
            )
            
            navigationController.toolbar.tintColor = .white
            navigationController.toolbar.setBackgroundImage(
                UIImage(),
                forToolbarPosition: .any,
                barMetrics: .default
            )
            navigationController.toolbar.addSubview(visualEffectView)
        }
        setToolbarItems(items, animated: true)
    }
    
    @objc private func search() {
        presenter.didTapSearchButton(on: currentIndex)
    }
}

// MARK: - WeatherScreenPageViewController + UIPageViewControllerDataSource

extension WeatherScreenPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        currentPageIndex = index - 1
        return pages[currentPageIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index < pages.count - 1 else {
            return nil
        }
        currentPageIndex = index + 1
        return pages[currentPageIndex]
    }
}

// MARK: - WeatherScreenPageViewController + UIPageViewControllerDelegate

extension WeatherScreenPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentViewController = pageViewController
            .viewControllers?
            .first as? WeatherScreenViewController else {
            return
        }
        
        
        if let pageIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = pageIndex
            backgroundGradient.configure(
                with: viewModels[pageIndex].current.backgroundColor
            )
        }
    }
}

// MARK: - WeatherScreenPageViewController + IWeatherScreenPageViewController

extension WeatherScreenPageViewController: IWeatherScreenPageViewController {
    
    func setupPageViewController(
        with viewModels: [WeatherModel.ViewModel],
        pageIndex: Int
    ) {
        self.viewModels = viewModels
        viewModels.forEach { viewModel in
            let viewController = WeatherScreenViewController(
                viewModel: viewModel
            )
            pages.append(viewController)
        }
        
        pageControl.currentPage = pageIndex
        
        dataSource = self
        delegate = self
        
        var initialPage = pages[0]
        
        if pageIndex < pages.count && pageIndex >= 0 {
            initialPage = pages[pageIndex]
        }
        
        setViewControllers(
            [initialPage],
            direction: .forward,
            animated: true
        )
    }
    
    func updateViewControllers(
        with viewModels: [WeatherModel.ViewModel]
    ) {
        viewModels.enumerated().forEach { index, viewModel in
            guard let page = pages[index] as? WeatherScreenViewController else {
                return
            }
            page.update(with: viewModel)
        }
    }
}

// MARK: - WeatherScreenPageViewController + IUpdatableWithData

extension WeatherScreenPageViewController: IUpdatableWithData {
    
    func updateWith(viewModels: [WeatherModel.ViewModel]) {
        presenter.updateWith(viewModels: viewModels)
    }
}

// MARK: - WeatherScreenPageViewController + IZoomingTransitionViewController

extension WeatherScreenPageViewController: IZoomingTransitionViewController {
    
    func animatedView(by index: Int?, onMain: Bool?) -> UIView? {
        let forecastView = ForecastView()
        let viewModel = presenter.getViewModel(by: index)
        
        if let onMain = onMain, onMain {
            DispatchQueue.main.async {
                forecastView.configure(with: viewModel, animated: false)
            }
        } else {
            forecastView.configure(with: viewModel, animated: false)
        }
        
        return forecastView
    }
}
