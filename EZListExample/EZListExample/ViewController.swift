//
//  ViewController.swift
//  EZListExample
//
//  Created by Vahid Ghanbarpour on 1/27/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
	typealias Model = CollectionCell.Model
	
	private weak var collectionView: CollectionView!
	private weak var tableView: TableView!
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBrown
		
		let layout = CollectionViewFlowLayout()
		layout.itemSize = .init(width: view.bounds.width, height: 44)
		let collectionView: CollectionView = .init(
			frame: view.bounds,
			collectionViewLayout: layout
		)
			.register(cellClass: CollectionCell.self, on: DispatchQueue.main)
		
		view.addSubview(collectionView)
		
		collectionView.backgroundColor = .clear
		
		self.collectionView = collectionView
		
//		let tableView: TableView = .init(frame: view.bounds, style: .plain)
//			.register(on: DispatchQueue.main)
//		
//		view.addSubview(tableView)
//		
//		tableView.backgroundColor = .clear
//		
//		self.tableView = tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let times = 10
		let numberOfItems = 1
		
		startAppendingData(times: times, numberOfItems: numberOfItems, list: tableView)
		startAppendingData(times: times, numberOfItems: numberOfItems, list: collectionView)
	}
	
	private func startAppendingData<List: AnyList>(times: Int, numberOfItems: Int, list: List?) where List.Model == RichModel {
		guard let list else { return }
		guard times >= 0 else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				[weak self] in
				guard let self else { return }
				removeItem()
			}
			return
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			[weak self] in
			guard let self else { return }
			var newItems: [List.Model] = []
			for i in 1 ... numberOfItems { newItems.append(.init(id: i, name: UUID().uuidString, imageURL: nil)) }
			if let collectionView {
				collectionView.send(newItems, strategy: .paginate)
			}
			if let tableView {
				tableView.send(newItems, strategy: .paginate, animation: .middle)
			}
			self.startAppendingData(times: times - 1, numberOfItems: numberOfItems, list: list)
		}
	}
	
	private func removeItem() {
		var newFeed = collectionView.items
		while newFeed.count > 2 { newFeed.remove(at: Int.random(in: 0..<newFeed.count)) }
		collectionView.send(newFeed, strategy: .update)
	}
}

import EZList
import NukeUI

struct RichModel: ListFeedItem {
	var id: Int
	let name: String
	let imageURL: URL?
}

final class CollectionView: EZCollectionView<CollectionCell> {
}

final class TableView: EZTableView<TableCell> {
}

final class CollectionCell: EZCollectionViewCell<RichModel> {
	
	typealias Model = RichModel
	
	private weak var label: UILabel!
	private weak var _imageView: LazyImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		label?.text = nil
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		let label = UILabel()
		contentView.addSubview(label)
		self.label = label
		
		label.textAlignment = .center
		
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			label.topAnchor.constraint(equalTo: contentView.topAnchor),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	override func update(_ model: Model) {
		label?.text = model.name
		label.textColor = .white
	}
}

final class TableCell: EZTableViewCell<RichModel> {
	
	typealias Model = RichModel
	
	private weak var label: UILabel!
	private weak var _imageView: LazyImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		label?.text = nil
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		let label = UILabel()
		contentView.addSubview(label)
		self.label = label
		
		contentView.backgroundColor = .clear
		backgroundColor = .clear
		
		label.textAlignment = .center
		
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			label.topAnchor.constraint(equalTo: contentView.topAnchor),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	override func update(_ model: Model) {
		label?.text = model.name
		label.textColor = .white
	}
}

final class CollectionViewFlowLayout: UICollectionViewFlowLayout {
	override init() {
		super.init()
		itemSize = .init(width: 100, height: 40)
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		itemSize = .init(width: 100, height: 40)
	}
}
