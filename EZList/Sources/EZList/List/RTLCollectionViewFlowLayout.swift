//
//  RTLCollectionViewFlowLayout.swift
//  SharedUI
//
//  Created by Vahid Ghanbarpour on 8/27/23.
//

#if canImport(UIKit)
import UIKit

open class RTLCollectionViewFlowLayout: UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

    open override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIUserInterfaceLayoutDirection.rightToLeft
    }
}
#endif
