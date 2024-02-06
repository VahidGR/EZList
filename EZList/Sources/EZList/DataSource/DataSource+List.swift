//
//  DataSource+List.swift
//  SharedUI
//
//  Created by Vahid Ghanbarpour on 6/7/23.
//

#if canImport(UIKit)
import UIKit
//import Nuke

func devlog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print("[\(Date())] dev-log:", items, separator: separator, terminator: terminator)
}

internal extension DataSource {
    /**
     Returns the number of items in the data source.
     
     - Parameters:
       - list: The list object conforming to `ListProtocol` (either `UITableView` or `UICollectionView`).
       - section: The section index.
     
     - Returns: The number of items in the section.
     */
    func numberOfItems(_ list: List, numberOfRowsInSection section: Int) -> Int {
		return feed.value.count
    }
    
    /**
     Returns the configured cell for the item at the specified index path.
     
     - Parameters:
       - list: The list object conforming to `ListProtocol` (either `UITableView` or `UICollectionView`).
       - indexPath: The index path of the item.
     
     - Returns: The configured cell.
     
     - Precondition: The cell must be registered with the list view before calling this method.
     */
    func item(_ list: List, cellForItemAt indexPath: IndexPath) -> List.Cell {
        var cell: List.Cell?
        
        // Dequeue cell from the list view
        if let collectionView = list as? UICollectionView {
            cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: List.Cell.identifier,
				for: indexPath) as? T.Cell
        }
        if let tableView = list as? UITableView {
			cell = tableView.dequeueReusableCell(withIdentifier: T.Cell.identifier) as? T.Cell
        }
        
        // Verify that cell is not nil
        guard let cell = cell else {
            fatalError("Unknown List type: \(List.self)")
        }
        
		let model = feed.value[indexPath.row]
		cell.update(model)
		
		return cell
    }
    
    /**
     Prefetches the items at the specified index paths.
     
     - Parameters:
       - list: The list object conforming to `ListProtocol` (either `UITableView` or `UICollectionView`).
       - indexPaths: The index paths of the items to prefetch.
     
     - Note: The method fetches the data for the items asynchronously and binds it to the cells.
     */
	func prefetch(_ list: List, prefetchItemsAt indexPaths: [IndexPath]) {
//		let feed = urlForImages(at: indexPaths)
//		prefetcher.startPrefetching(with: feed)
    }
	
    /**
     Cancels prefetching for the items at the specified index paths.
     
     - Parameters:
       - list: The list object conforming to `ListProtocol` (either `UITableView` or `UICollectionView`).
       - indexPaths: The index paths of the items to cancel prefetching for.
     */
    func cancelPrefetch(_ list: List, prefetchItemsAt indexPaths: [IndexPath]) {
//		let feed = urlForImages(at: indexPaths)
//		prefetcher.stopPrefetching(with: feed)
    }
    
    /**
     Handles the selection of an item at the specified index path.
     
     - Parameters:
       - list: The list object conforming to `ListProtocol` (either `UITableView` or `UICollectionView`).
       - indexPath: The index path of the selected item.
     */
    func didSelectItem(_ list: List, at indexPath: IndexPath) {
		// TODO: - pass view model
		//let viewModel = feed.value[indexPath.row]
		//list.next?.segue(viewModel: viewModel)
    }
}

//fileprivate extension DataSource {
//	
//	private func urlForImages(at indexPaths: [IndexPath]) -> [URL] {
//		guard let lowerEnd = indexPaths.min(by: { $0.row < $1.row }).map({ $0.row }),
//			  let higherEnd = indexPaths.max(by: { $0.row < $1.row }).map({ $0.row })
//		else { return [] }
//		let array: [List.Cell.Model] = feed.value
//		let requestingValues = array[lowerEnd..<higherEnd]
//			.compactMap {
//				Mirror(reflecting: $0).children.compactMap
//				{
//					$0.value as? AnyCellValue
//				} .first
//			}
//		return requestingValues
//			.filter {
//				$0.value == nil
//			}
//			.compactMap { $0.request }
//	}
//	
//}
#endif
