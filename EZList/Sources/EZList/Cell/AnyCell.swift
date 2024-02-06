//
//  AnyCell.swift
//  SharedUI
//
//  Created by Vahid Ghanbarpour on 6/7/23.
//

#if canImport(UIKit)
import UIKit

/**
 A protocol representing a cell in a table view or collection view.

 The `AnyCell` protocol extends the `AnyView` protocol and adds additional functionality specific to cells in a table view or collection view.

 - Note: Cells conforming to this protocol are typically used to display data in a table view or collection view. They encapsulate the logic for configuring and updating the cell's content.

 - SeeAlso: `AnyView`
 
 - Returns: An instance conforming to `AnyCell`.
 */
public protocol AnyCell: AnyObject {
	associatedtype Model: ListFeedItem
	func update(_ model: Model)
}

extension AnyCell {
    
    /**
     The identifier for the cell.

     The `identifier` property returns a string that represents the identifier for the cell. The identifier is typically used when registering or dequeuing cells in a table view or collection view.

     - Note: The default implementation of this property uses the name of the adopting class as the identifier.

     - Returns: A string representing the cell's identifier.
     */
    public static var identifier: String {
        "\(Self.self)"
    }
        
}

/**
 A protocol representing a cell in a table view or collection view.
 
 The `AnyCell` protocol extends the `AnyView` protocol and adds additional functionality specific to cells in a table view or collection view. It introduces associated type `Value` to represent the cell's data and the requested data, respectively. The protocol requires a `value` property to hold the requested data, and a method `update(with:)` to update the cell's content with a given value.
 
 - Note: Cells conforming to this protocol are typically used to display data in a table view or collection view. They encapsulate the logic for configuring and updating the cell's content.
 
 - SeeAlso: `AnyCell`
 
 - Requires: The adopting class must implement the `update(with:)` method.
 
 - Parameter Value: The type of the cell's data.
 - Parameter RequestValue: The type of the requested data.
 
 - Returns: An instance conforming to `AnyUpdatingCell`.
 */

#endif
