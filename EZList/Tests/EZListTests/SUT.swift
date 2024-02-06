//
//  File.swift
//  
//
//  Created by Vahid Ghanbarpour on 1/27/24.
//

import UIKit
import EZList
//import NukeUI

struct RichModel: ListFeedItem {
	let id: Int
	let name: String
	let imageURL: URL?
}

final class CollectionCell: EZCollectionViewCell<RichModel> {
	
	private weak var label: UILabel!
	//private weak var _imageView: LazyImageView!
	
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
		self.label = .init(label)
	}
	
	override func update(_ model: Model) {
		label?.text = model.name
	}
}

final class TableCell: EZTableViewCell<RichModel> {
	
	private weak var label: UILabel!
	//private weak var _imageView: LazyImageView!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		let label = UILabel()
		self.label = .init(label)
	}
	
	override func update(_ model: Model) {
		label.text = model.name
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
