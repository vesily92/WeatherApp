//
//  BaseSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

// MARK: - BaseSectionConfigurator
/// Abstract class for section configurator.
class BaseSectionConfigurator {
    
    /// Creates supplementary item for collection view.
    /// - Returns: Configured section header item.
    func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Size.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: SectionHeader.reuseIdentifier,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        
        return sectionHeader
    }
    
    /// Creates decoration item for collection view.
    /// - Returns: Configured background decoration view.
    func decorationView() -> NSCollectionLayoutDecorationItem {
        let backgroundItem = NSCollectionLayoutDecorationItem.background(
            elementKind: BackgroundDecorationView.reuseIdentifier
        )
        return backgroundItem
    }
    
    /// Sets mask to the cell.
    /// - Parameters:
    ///   - item: Item that’s currently visible within the bounds of a section.
    ///   - offset: Scroll offset of a section.
    ///   - collectionView: Collection view object.
    ///   - cell: Cell that needs to be masked.
    func maskCells(
        item: NSCollectionLayoutVisibleItem,
        offset: CGPoint,
        collectionView: UICollectionView,
        cell: IMaskable
    ) {
        let headerHeight = CGFloat(Size.headerHeight)
        let hiddenFrameHeight = offset.y + headerHeight - cell.frame.origin.y
        
        if hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height {
            cell.makeMask(for: hiddenFrameHeight)
        }
    }
    
    /// Provides header fading out animation.
    /// - Parameters:
    ///   - item: Item that’s currently visible within the bounds of a section.
    ///   - offset: Scroll offset of a section.
    ///   - collectionView: Collection view object.
    ///   - cell: Cell of the section that contains header.
    func animateHeader(
        item: NSCollectionLayoutVisibleItem,
        offset: CGPoint,
        collectionView: UICollectionView,
        cell: IMaskable
    ) {
        let headerHeight = CGFloat(Size.headerHeight)
        let offsetDelta = offset.y - (cell.frame.maxY - headerHeight)
        let sectionIsDisappearing = offset.y >= cell.frame.maxY - headerHeight
        
        if item.representedElementCategory == .supplementaryView {
            guard let header = collectionView.supplementaryView(
                forElementKind: SectionHeader.reuseIdentifier,
                at: item.indexPath
            ) as? SectionHeader else { return }
            
            animate(
                header: header,
                offsetDelta: offsetDelta,
                sectionIsDisappearing: sectionIsDisappearing
            )
        }
        
        if item.representedElementCategory == .decorationView {
            animate(
                decorationView: item,
                offsetDelta: offsetDelta,
                sectionIsDisappearing: sectionIsDisappearing
            )
        }
    }
}

// MARK: - BaseSectionConfigurator + Extension
extension BaseSectionConfigurator {
    
    /// Animates section's header.
    /// - Parameters:
    ///   - header: Reusable view object.
    ///   - offsetDelta: Scroll offset delta.
    ///   - sectionIsDisappearing: A Boolean value indicating whether the section is disappearing.
    private func animate(
        header: UICollectionReusableView,
        offsetDelta: CGFloat,
        sectionIsDisappearing: Bool
    ) {
        guard let header = header as? SectionHeader else { return }
        
        if sectionIsDisappearing {
            let alpha = 1 - (offsetDelta / 30)
            header.setAlphaForHeader(with: alpha)
        } else {
            header.setAlphaForHeader(with: 1)
        }
        
        if sectionIsDisappearing {
            header.offset = offsetDelta
            header.layer.zPosition = -1
        } else {
            header.offset = 0
            header.layer.zPosition = 1
        }
    }
    
    /// Animates section's background decoration view.
    /// - Parameters:
    ///   - decorationView: Item that’s currently visible within the bounds of a section.
    ///   - offsetDelta: Scroll offset delta.
    ///   - sectionIsDisappearing: A Boolean value indicating whether the section is disappearing.
    private func animate(
        decorationView: NSCollectionLayoutVisibleItem,
        offsetDelta: CGFloat,
        sectionIsDisappearing: Bool
    ) {
        if sectionIsDisappearing {
            let alpha = 1 - (offsetDelta / 30)
            decorationView.alpha = alpha
        } else {
            decorationView.alpha = 1
        }
        
        if sectionIsDisappearing {
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, 0, offsetDelta, -2)
            decorationView.transform3D = transform
        } else {
            decorationView.transform3D = CATransform3DIdentity
        }
    }
}
