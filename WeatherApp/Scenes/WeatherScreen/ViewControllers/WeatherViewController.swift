//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 05.04.2023.
//

import UIKit

protocol IWeatherViewController: AnyObject {
    func preparePages(with viewModels: [WeatherModel.ViewModel.WeatherScreen])
    func updatePage(
        by index: Int,
        with viewModel: WeatherModel.ViewModel.WeatherScreen
    )

    func addPage(with viewModel: WeatherModel.ViewModel.WeatherScreen)
    func removePage(by index: Int)
    func scrollTo(page index: Int)
    
    func send(data: [WeatherModel.Data])
}

final class WeatherViewController: UIViewController {
    
    var onWeatherDataChange: (([WeatherModel.Data]) -> Void)?
    
    var coordinator: ICoordinator?
    var presenter: IWeatherScreenPresenter!
    
    private var pageControl: UIPageControl!
    private var scrollView: UIScrollView!

    private lazy var pages: [ForecastView] = []
    
    private var currentPageIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        setupPageControl()
        setupNavigationBar()
        setupScrollView()
        setupConstraints()
        
        presenter.setupPages()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFrames() {
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(presenter.numberOfPages()),
            height: view.frame.height
        )
        
        for index in 0 ..< pages.count {
            pages[index].frame = CGRect(
                x: view.frame.width * CGFloat(index),
                y: 0,
                width: view.frame.width,
                height: view.frame.height
            )
        }
        pageControl.numberOfPages = presenter.numberOfPages()
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
        setToolbarItems(items, animated: true)
    }
    
    private func calculatePageIndex() -> Int {
        let width = scrollView.frame.width - (scrollView.contentInset.left * 2)
        let index = scrollView.contentOffset.x / width
        let roundedIndex = round(index)
        
        return Int(roundedIndex)
    }
    
    @objc private func search() {
        presenter.didTapSearchButton()
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPageIndex = calculatePageIndex()
        pageControl.currentPage = currentPageIndex
    }
}

extension WeatherViewController: IWeatherViewController {
    func preparePages(
        with viewModels: [WeatherModel.ViewModel.WeatherScreen]
    ) {
        viewModels.forEach { viewModel in
            let page = ForecastView()
            page.configure(with: viewModel)
            pages.append(page)
            scrollView.addSubview(page)
        }
        setupFrames()
    }

    func updatePage(
        by index: Int,
        with viewModel: WeatherModel.ViewModel.WeatherScreen
    ) {
        let page = ForecastView()
        page.configure(with: viewModel)
        
        pages[index] = page
        pages[index].frame = CGRect(
            x: view.frame.width * CGFloat(index),
            y: 0,
            width: view.frame.width,
            height: view.frame.height
        )
        scrollView.subviews[index].removeFromSuperview()
        scrollView.insertSubview(page, at: index)
    }
    
    func addPage(with viewModel: WeatherModel.ViewModel.WeatherScreen) {
        let page = ForecastView()
        page.configure(with: viewModel)
        
        pages.append(page)
        scrollView.addSubview(page)
        setupFrames()
    }
    
    func removePage(by index: Int) {
        pages.remove(at: index)
        scrollView.subviews[index].removeFromSuperview()
        setupFrames()
    }
    
    func send(data: [WeatherModel.Data]) {
        onWeatherDataChange?(data)
    }
    
    func scrollTo(page index: Int) {
        let offset = CGPoint(x: view.frame.width * CGFloat(index), y: 0)
        scrollView.setContentOffset(offset, animated: false)
    }
}

extension WeatherViewController: IUpdatableWithData {
    func updateWith(_ data: [WeatherModel.Data]) {
        presenter.updateWith(data)
    }
}
