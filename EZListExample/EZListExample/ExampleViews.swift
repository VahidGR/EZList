//
//  ExampleViews.swift
//  EZListExample
//
//  Created by Vahid Ghanbarpour on 2/6/24.
//

import UIKit
import EZList

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
	//private weak var _imageView: LazyImageView!
	
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
	//private weak var _imageView: LazyImageView!
	
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
