//
//  CollectionViewCell.swift
//
//
//  Created by Vahid Ghanbarpour on 10/20/23.
//

#if canImport(UIKit)
import UIKit

open class EZCollectionViewCell<T: ListFeedItem>: UICollectionViewCell, AnyCell {
	public typealias Model = T
	
	open func update(_ model: Model) { }
}
#endif
