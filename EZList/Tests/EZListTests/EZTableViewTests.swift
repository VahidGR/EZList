import XCTest
import Combine
@testable import EZList

final class EZTableViewTests: XCTestCase {
	private typealias Model = TableCell.Model
	
	weak var tableView: UITableView!
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
		XCTAssertNil(tableView)
	}
	
	func testTableViewReload() {
		let expectation: XCTestExpectation = .init(description: "Value received")
		
		// Given
		let tableView = buildSUT()
		
		tableView.feed
			.receive(on: DispatchQueue.main)
			.sink { [weak self] output in
				// Then
				let expectedOutput = self?.list
				XCTAssertEqual(expectedOutput, output.items)
				
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		// When
		tableView.send(list, strategy: .reload, animation: .automatic)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testTableViewPaginate() {
		let expectation: XCTestExpectation = .init(description: "Value received")
		let expectation2: XCTestExpectation = .init(description: "Value updated")
		
		// Given
		let tableView = buildSUT()
		
		tableView.feed
			.receive(on: DispatchQueue.main)
			.sink { [weak self] output in
				guard let self else { return }
				
				// Then
				if output.strategy == .reload {
					XCTAssertEqual(output.items, self.list)
					XCTAssertEqual(output.animation, .automatic)
					expectation.fulfill()
				}
				//XCTAssertEqual(expectedOutput, output)
				
				if output.strategy == .paginate {
					XCTAssertEqual(output.items, self.list2)
					XCTAssertEqual(output.animation, .fade)
					expectation2.fulfill()
				}
				
				
			}
			.store(in: &cancellables)
		
		// When
		tableView.send(list, strategy: .reload, animation: .automatic)
		//sleep(1)
		tableView.send(list2, strategy: .paginate, animation: .fade)
		
		wait(for: [expectation, expectation2], timeout: 1)
	}
	
	private func buildSUT() -> (
		EZTableView<TableCell>
	) {
		let tableView: EZTableView = .init(frame: .zero, style: .plain)
			.register(cellClass: TableCell.self, on: RunLoop.main)
		
		self.tableView = tableView
		
		return tableView
	}
	
}
