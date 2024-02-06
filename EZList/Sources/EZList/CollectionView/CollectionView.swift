//
//  CollectionView.swift
//
//
//  Created by Vahid Ghanbarpour on 10/20/23.
//

#if canImport(UIKit)
import UIKit
import Combine

public typealias ListFeedItem = Identifiable & Equatable

public struct ListFeed<Item: ListFeedItem>: Equatable {
	public let items: [Item]
	public let strategy: ListNewDataStrategy
	
	public init(items: [Item], strategy: ListNewDataStrategy) {
		self.items = items
		self.strategy = strategy
	}
}

open class EZCollectionView<T: AnyCell>: UICollectionView, AnyList where T: UICollectionViewCell {
	public typealias Cell = T
	public typealias EZDataSource = DataSource<EZCollectionView>
	
	internal var cancellables: Set<AnyCancellable> = .init()
	private(set) var feed: PassthroughSubject<ListFeed<Model>, Never> = .init()
	public var items: [Model] { ez.feed.value }
	
	internal let ez: EZDataSource
	
	public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		self.ez = .init(.init([]))
		super.init(frame: frame, collectionViewLayout: layout)
	}
	
	required public init?(coder: NSCoder) {
		self.ez = .init(.init([]))
		super.init(coder: coder)
	}
	
	public func register<S: Scheduler>(cellClass: Cell.Type = Cell.self, on scheduler: S) -> Self {
		register(
			cellClass.self,
			forCellWithReuseIdentifier: cellClass.identifier
		)
		subscribeUpdates(on: scheduler)
		return self
	}
	
	
	open func send(_ items: [Model], strategy: ListNewDataStrategy) {
		DispatchQueue.main.async { [unowned self] in
			feed.send(.init(items: items, strategy: strategy))
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
											self.deleteItems(at: [IndexPath(item: offset, section: 0)])
										case let .insert(offset, _, _):
											self.insertItems(at: [IndexPath(item: offset, section: 0)])
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

#endif
