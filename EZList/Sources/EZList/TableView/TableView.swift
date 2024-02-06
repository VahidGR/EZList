//
//  TableView.swift
//
//
//  Created by Vahid Ghanbarpour on 10/20/23.
//

#if canImport(UIKit)
import UIKit
import Combine

public struct AnimatedListFeed<Item: ListFeedItem>: Equatable {
	public let animation: UITableView.RowAnimation
	public let items: [Item]
	public let strategy: ListNewDataStrategy
}

open class EZTableView<T: AnyCell>: UITableView, AnyList where T: UITableViewCell {
	public typealias Cell = T
	public typealias EZDataSource = DataSource<EZTableView<Cell>>
	
	internal var cancellables: Set<AnyCancellable> = .init()
	private(set) var feed: PassthroughSubject<AnimatedListFeed<Model>, Never> = .init()
	public var items: [Model] { ez.feed.value }
	
	private(set) var ez: EZDataSource
	
	public override init(frame: CGRect, style: UITableView.Style) {
		let dataSource: EZDataSource = .init(.init([]))
		self.ez = dataSource
		super.init(frame: frame, style: style)
	}
	
	public required init?(coder: NSCoder) {
		let dataSource: EZDataSource = .init(.init([]))
		self.ez = dataSource
		super.init(coder: coder)
	}
	
	public func register<S: Scheduler>(cellClass: Cell.Type = Cell.self, on scheduler: S) -> Self {
		register(
			cellClass.self,
			forCellReuseIdentifier: cellClass.identifier
		)
		subscribeUpdates(on: scheduler)
		return self
	}
	
	
	open func send(_ items: [Model], strategy: ListNewDataStrategy, animation: UITableView.RowAnimation) {
		DispatchQueue.main.async { [unowned self] in
			feed.send(.init(animation: animation, items: items, strategy: strategy))
		}
	}
	
	
	private func subscribeUpdates<S: Scheduler>(on scheduler: S) {
		self.delegate = ez
		self.dataSource = ez
		self.prefetchDataSource = ez
		feed
			.subscribe(on: scheduler)
			.receive(on: scheduler)
			.sink(receiveValue: { [weak self] feed in
				guard let self = self else { return }
				
				// Update data source first
				var newList: [Model] = []
				switch feed.strategy {
					case .reload:
						newList = feed.items
					case .paginate:
						newList = self.ez.feed.value + feed.items
					case .update:
						newList = feed.items
				}
				// this updates `self.ez.feed.value`
				
				// Then update UI in the main thread
				DispatchQueue.main.async { [weak self] in
					guard let self else { return }
					switch feed.strategy {
						case .reload:
							self.reloadData()
						case .paginate, .update:
							self.performBatchUpdates {
								let diff = newList.difference(from: self.ez.feed.value)
								for change in diff {
									switch change {
										case let .remove(offset, _, _):
											self.deleteRows(at: [IndexPath(item: offset, section: 0)], with: feed.animation)
										case let .insert(offset, _, _):
											self.insertRows(at: [IndexPath(item: offset, section: 0)], with: feed.animation)
									}
								}
								self.ez.feed.send(newList)
							}
					}
				}
			})
			.store(in: &cancellables)
	}
}

//extension AnyList where Self: UITableView {
//	/**    	 Entangles the list with a data source.
//	 
//	 The `entangle(_:)` method is responsible for entangling the list with a data source. It allows the data source to provide the necessary data for populating the list.
//	 
//	 - Parameter dataSource: The data source to be entangled with the list.
//	 */
//	@MainActor public static func build(
//		cellClass: Cell.Type = Cell.self,
//		feed: inout PassthroughSubject<[Cell.Model], Never>,
//		storeIn cancellables: inout Set<AnyCancellable>,
//		frame: CGRect = .zero,
//		style: UITableView.Style,
//		newDataStategy: ListNewDataStrategy,
//		newDataAnimation: UITableView.RowAnimation
//	) -> Self {
//		let tableView: Self = .init(frame: frame, style: style)
//		tableView.register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
//		let dataSource: DataSource<Self> = .init(.init([]))
//		tableView.delegate = dataSource
//		tableView.dataSource = dataSource
//		
//		feed
//			.receive(on: DispatchQueue.main)
//			.sink(receiveValue: { [dataSource] list in
//				switch newDataStategy {
//					case .reload:
//						dataSource.feed.send(list)
//						tableView.reloadData()
//					case .append:
//						let currentList = dataSource.feed.value
//						let newList = currentList + list
//						dataSource.feed.send(newList)
//						
//						// Calculate the indexes of the newly added items
//						let startIndex = currentList.count
//						var indexPaths: [IndexPath] = []
//						for (index, _) in list.enumerated() {
//							indexPaths.append(IndexPath(item: startIndex + index, section: 0))
//						}
//						
//						// Insert the new items into the collection view
//						tableView.performBatchUpdates({
//							tableView.insertRows(at: indexPaths, with: newDataAnimation)
//						}, completion: nil)
//						
//					case .update:
//						let currentList = dataSource.feed.value
//						var updatedIndexes: [IndexPath] = []
//						
//						// Find the indexes of items with different data
//						for (index, newItem) in list.enumerated() {
//							if index < currentList.count, newItem != currentList[index] {
//								updatedIndexes.append(IndexPath(item: index, section: 0))
//							}
//						}
//						
//						if !updatedIndexes.isEmpty {
//							tableView.performBatchUpdates({
//								// Update the data source
//								dataSource.feed.send(list)
//								
//								// Reload only the cells that have different data
//								tableView.reloadRows(at: updatedIndexes, with: newDataAnimation)
//							}, completion: nil)
//						}
//				}
//			})
//			.store(in: &cancellables)
//		
//		return tableView
//	}
//	
//}
#endif
