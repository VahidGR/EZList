//
//  TableViewCell.swift
//
//
//  Created by Vahid Ghanbarpour on 10/20/23.
//

#if canImport(UIKit)
import UIKit

open class EZTableViewCell<T: ListFeedItem>: UITableViewCell, AnyCell {
	public typealias Model = T
	open func update(_ model: Model) { }
}
#endif
