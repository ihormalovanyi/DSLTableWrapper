import UIKit

@propertyWrapper
public struct DSLTableOutlet<T: UITableView> {

    public var wrappedValue: T! {
        didSet {
            projectedValue = .init(wrappedValue)
            wrappedValue.delegate = projectedValue
            wrappedValue.dataSource = projectedValue
        }
    }

    public private(set) var projectedValue: ProjectedTableDataSourceDelegate!
    
    public init() {}

}

@propertyWrapper
public class DSLTable<T: UITableView> {
    
    public var wrappedValue: T
    
    public private(set) var projectedValue: ProjectedTableDataSourceDelegate
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.projectedValue = ProjectedTableDataSourceDelegate(wrappedValue)
        self.wrappedValue.delegate = projectedValue
        self.wrappedValue.dataSource = projectedValue
    }
    
}
