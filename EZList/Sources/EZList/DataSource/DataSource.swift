//
//  DataSource.swift
//  SharedUI
//
//  Created by Vahid Ghanbarpour on 6/7/23.
//

#if canImport(UIKit)
import UIKit
import Combine
//import Nuke

/**
 A data source class that conforms to `UITableViewDataSource`, `UITableViewDelegate`, `UITableViewDataSourcePrefetching`, `UICollectionViewDelegate`, `UICollectionViewDelegate` and `UICollectionViewDataSourcePrefetching` protocols.

 The `DataSource` class is responsible for acting as a data source for a `UITableView` or `UICollectionView`. It conforms to the necessary protocols and provides implementations for the required methods. It manages an `interactor` object that conforms to the `AnyDataSource` protocol. The class retrieves data from the interactor and configures the table view cells accordingly.

 - Note: This class is designed to be used with a `UITableView` or `UICollectionView` and relies on the provided interactor conforming to the `AnyDataSource` protocol.

 - SeeAlso: `AnyDataSource`, `UITableViewDataSource`, `UITableViewDelegate`, `UITableViewDataSourcePrefetching`, `UICollectionViewDelegate`, `UICollectionViewDelegate`, `UICollectionViewDataSourcePrefetching`

 - Parameters:
   - T: The type of the interactor conforming to `AnyDataSource`.

 - Returns: An instance of the `DataSource` class.
 */

public protocol ListDataSource: 
	UITableViewDataSource,
	UITableViewDelegate,
	UITableViewDataSourcePrefetching,
	UICollectionViewDelegate,
	UICollectionViewDataSource,
	UICollectionViewDataSourcePrefetching,
	UICollectionViewDelegateFlowLayout
{
	associatedtype List: AnyList
	typealias Cell = List.Cell
	typealias Feed = CurrentValueSubject<[List.Cell.Model], Never>
	var feed: Feed { get set }
    init(_ feed: Feed)
}

public final class DataSource<T: AnyList>: UIResponder, ListDataSource {
    internal typealias TaskType = Task<(), Error>
	public typealias List = T
	public var feed: Feed
	//internal let prefetcher = ImagePrefetcher()
	private var cancellables: Set<AnyCancellable> = .init()
    
    /**
     Initializes the data source with the provided interactor.

     The `init(_:)` method initializes the data source with the provided interactor object. The interactor must conform to the `AnyDataSource` protocol.

     - Parameter interactor: An instance of the interactor object conforming to `AnyDataSource`.

     - Note: The interactor object is assigned to the `interactor` property of the data source.

     - SeeAlso: `AnyDataSource`
     */
	public init(_ feed: Feed) {
		self.feed = feed
	}
	
    deinit {
        devlog("deinit \(Self.self)")
    }
    
    // UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableView = tableView as? List else {
            fatalError("UITableView should conform to \(List.self)")
        }
        return numberOfItems(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? List else {
            fatalError("UITableView should conform to \(List.self)")
        }
        return item(tableView, cellForItemAt: indexPath) as! UITableViewCell
    }
    
    // UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let tableView = tableView as? List else {
            fatalError("UITableView should conform to \(List.self)")
        }
        prefetch(tableView, prefetchItemsAt: indexPaths)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        guard let tableView = tableView as? List else {
            fatalError("UITableView should conform to \(List.self)")
        }
        cancelPrefetch(tableView, prefetchItemsAt: indexPaths)
    }
    
    // UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? List else {
            fatalError("UITableView should conform to \(List.self)")
        }
        didSelectItem(tableView, at: indexPath)
    }
    
    // UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? List else {
            fatalError("UICollectionView should conform to \(List.self)")
        }
        return numberOfItems(collectionView, numberOfRowsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? List else {
            fatalError("UICollectionView should conform to \(List.self)")
        }
        return item(collectionView, cellForItemAt: indexPath) as! UICollectionViewCell
    }
    
    // UICollectionViewDataSourcePrefetching
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let collectionView = collectionView as? List else {
            fatalError("UICollectionView should conform to \(List.self)")
        }
        prefetch(collectionView, prefetchItemsAt: indexPaths)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        guard let collectionView = collectionView as? List else {
            fatalError("UICollectionView should conform to \(List.self)")
        }
        cancelPrefetch(collectionView, prefetchItemsAt: indexPaths)
    }
    
    // UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionView = collectionView as? List else {
            fatalError("UICollectionView should conform to \(List.self)")
        }
        didSelectItem(collectionView, at: indexPath)
    }
}
#endif
