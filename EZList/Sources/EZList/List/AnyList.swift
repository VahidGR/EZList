//
//  AnyList.swift
//  SharedUI
//
//  Created by Vahid Ghanbarpour on 6/7/23.
//

#if canImport(UIKit)
import UIKit
import Combine

public enum ListNewDataStrategy {
	case reload
	case paginate
	case update
}

/**
 A type alias representing a list protocol.

 The `ListProtocol` type alias represents a protocol that combines `UIScrollView`, `UIDataSourceTranslating`, and `AnyView`. It is used as a requirement for the `U` generic type parameter in the `DataSource` class.

 - SeeAlso: `UIScrollView`, `UIDataSourceTranslating`, `AnyView`
 */
public typealias ListProtocol = (UIScrollView & UIDataSourceTranslating)

/// A protocol that represents a list view.
public protocol AnyList: ListProtocol {
    /// The associated type for `Cell`.
	associatedtype Cell: AnyCell
	typealias Model = Cell.Model
	//var feedPublisher: PassthroughSubject<ListFeed<Model>, Never> { get }
}
#endif
