//
//  ListCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 04.04.2023.
//

import UIKit

final class ListCell: UICollectionViewListCell {    
    
    private lazy var cardView: ListCardView = {
        let cardView = ListCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        let heightConstraint = cardView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            heightConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WeatherModel.ViewModel.Current) {
        cardView.configure(with: model)
    }
    
    func getView() -> ListCardView {
        return cardView
    }
}

