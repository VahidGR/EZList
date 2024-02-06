import XCTest
import Combine
@testable import EZList

final class EZCollectionViewTests: XCTestCase {
	private typealias Model = CollectionCell.Model
	
	private weak var collectionView: UICollectionView!
	private var cancellables: Set<AnyCancellable> = .init()
	private let list: [Model] = [
		.init(
			id: 1,
			name: "cat",
			imageURL: .init(
				string: "https://img.izismile.com/img/img15/20240125/640/childhood_wonder_unleashed_simple_world_facts_for_all_ages_640_12.jpg"
			)
		),
		.init(
			id: 2,
			name: "cat",
			imageURL: .init(
				string: "https://img.izismile.com/img/img15/20240125/640/childhood_wonder_unleashed_simple_world_facts_for_all_ages_640_12.jpg"
			)
		),
	]
	
	private let list2: [Model] = [
		.init(
			id: 3,
			name: "cat",
			imageURL: .init(
				string: "https://img.izismile.com/img/img15/20240125/640/childhood_wonder_unleashed_simple_world_facts_for_all_ages_640_12.jpg"
			)
		)
	]
	
	override func tearDown() {
		super.tearDown()
		XCTAssertNil(collectionView)
	}
	
	func testCollectionViewReload() {
		let expectation: XCTestExpectation = .init(description: "Value received")
		
		// Given
		let collectionView = buildSUT()
		
		collectionView.feed
			//.subscribe(on: DispatchQueue.main)
			.receive(on: RunLoop.main)
			.sink { [weak self] output in
				// Then
				let expectedOutput = self?.list
				XCTAssertEqual(expectedOutput, output.items)
				
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		// When
		collectionView.send(list, strategy: .reload)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testCollectionViewAppend() {
		let expectation: XCTestExpectation = .init(description: "Value received")
		let expectation2: XCTestExpectation = .init(description: "Value updated")
		
		// Given
		let collectionView = buildSUT()
		
		collectionView.feed
			.receive(on: DispatchQueue.main)
			.sink { [weak self] output in
				guard let self else { return }
				
				// Then
				if output.strategy == .reload {
					XCTAssertEqual(output.items, self.list)
					expectation.fulfill()
				}
				//XCTAssertEqual(expectedOutput, output)
				
				if output.strategy == .paginate {
					XCTAssertEqual(output.items, self.list2)
					expectation2.fulfill()
				}
				
				
			}
			.store(in: &cancellables)

		// When
		collectionView.send(list, strategy: .reload)
		//sleep(1)
		collectionView.send(list2, strategy: .paginate)
		
		wait(for: [expectation, expectation2], timeout: 1)
	}
	
	private func buildSUT() -> (
		EZCollectionView<CollectionCell>
	) {
		let layout = RTLCollectionViewFlowLayout()
		let collectionView: EZCollectionView = .init(frame: .zero, collectionViewLayout: layout)
			.register(cellClass: CollectionCell.self, on: RunLoop.main)
		
		self.collectionView = collectionView
		
		return collectionView
	}
	
}
