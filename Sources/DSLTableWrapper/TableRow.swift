//
//  File.swift
//  
//
//  Created by Ihor Malovanyi on 09.05.2022.
//

import UIKit

public class TableRowBase {
    
    var nib: UINib?
    var identifier: String
    
    var canEdit: Bool?
    var canEditHandler: Return<Bool>?
    
    var canMove: Bool?
    var canMoveHandler: Return<Bool>?
    
    var height: CGFloat?
    var heightHandler: Return<CGFloat>?
    
    var estimatedHeight: CGFloat?
    var estimatedHeightHandler: Return<CGFloat>?
    
    var shouldHighlight: Bool?
    var shouldHighlightHandler: Return<Bool>?
    
    var editingStyle: UITableViewCell.EditingStyle?
    var editingStyleHandler: Return<UITableViewCell.EditingStyle>?
    
    var leadingSwipeActionsConfiguration: UISwipeActionsConfiguration?
    var leadingSwipeActionsConfigurationHandler: Return<UISwipeActionsConfiguration>?
    
    var trailingSwipeActionsConfiguration: UISwipeActionsConfiguration?
    var trailingSwipeActionsConfigurationHandler: Return<UISwipeActionsConfiguration>?
    
    var commitHandler: ((UITableViewCell.EditingStyle) -> ())?
    var willDisplayHandler: (() -> ())?
    var didEndDisplayHandler: (() -> ())?
    var accessoryButtonAction: (() -> ())?
    var didHighlightHandler: (() -> ())?
    var didUnhighlightHandler: (() -> ())?
    var willSelectHandler: (() -> (Bool))?
    var willDeselectHandler: (() -> (Bool))?
    var didSelectHandler: (() -> ())?
    var didDeselectHandler: (() -> ())?
    
    func register(in table: UITableView?) {}
    
    func setup(_ cell: UITableViewCell) {}
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
}

public class TableRow<T: UITableViewCell>: TableRowBase {
    
    var setupHandler: ((T) -> ())?
    
    @discardableResult
    public func nib(_ nib: UINib?) -> TableRow {
        self.nib = nib
        return self
    }
    
    @discardableResult
    public func setup(_ handler: @escaping (T) -> ()) -> TableRow {
        setupHandler = handler
        return self
    }
    
    @discardableResult
    public func canEdit(_ value: Bool) -> TableRow {
        canEdit = value
        canEditHandler = nil
        return self
    }
    
    @discardableResult
    public func canEdit(_ handler: @escaping Return<Bool>) -> TableRow {
        canEditHandler = handler
        canEdit = nil
        return self
    }
    
    @discardableResult
    public func canMove(_ value: Bool) -> TableRow {
        canMove = value
        canMoveHandler = nil
        return self
    }
    
    @discardableResult
    public func canMove(_ handler: @escaping Return<Bool>) -> TableRow {
        canMoveHandler = handler
        canMove = nil
        return self
    }
    
    @discardableResult
    public func commit(_ handler: @escaping (UITableViewCell.EditingStyle) -> ()) -> TableRow {
        commitHandler = handler
        return self
    }
    
    @discardableResult
    public func willDisplay(_ handler: @escaping () -> ()) -> TableRow {
        willDisplayHandler = handler
        return self
    }
    
    @discardableResult
    public func didEndDisplay(_ handler: @escaping () -> ()) -> TableRow {
        didEndDisplayHandler = handler
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> TableRow {
        height = value
        heightHandler = nil
        return self
    }
    
    @discardableResult
    public func height(_ handler: @escaping Return<CGFloat>) -> TableRow {
        heightHandler = handler
        height = nil
        return self
    }
    
    @discardableResult
    public func estimatedHeight(_ value: CGFloat) -> TableRow {
        estimatedHeight = value
        estimatedHeightHandler = nil
        return self
    }
    
    @discardableResult
    public func estimatedHeight(_ handler: @escaping Return<CGFloat>) -> TableRow {
        estimatedHeightHandler = handler
        estimatedHeight = nil
        return self
    }
    
    @discardableResult
    public func accessoryButtonTapped(_ handler: @escaping () -> ()) -> TableRow {
        accessoryButtonAction = handler
        return self
    }
    
    @discardableResult
    public func shouldHighlight(_ value: Bool) -> TableRow {
        shouldHighlight = value
        shouldHighlightHandler = nil
        return self
    }
    
    @discardableResult
    public func shouldHighlight(_ handler: @escaping Return<Bool>) -> TableRow {
        shouldHighlightHandler = handler
        shouldHighlight = nil
        return self
    }
    
    @discardableResult
    public func didHighlight(_ handler: @escaping () -> ()) -> TableRow {
        didHighlightHandler = handler
        return self
    }
    
    @discardableResult
    public func willSelect(_ handler: @escaping () -> (Bool)) -> TableRow {
        willSelectHandler = handler
        return self
    }
    
    @discardableResult
    public func willDeselect(_ handler: @escaping () -> (Bool)) -> TableRow {
        willDeselectHandler = handler
        return self
    }
    
    @discardableResult
    public func didSelect(_ handler: @escaping () -> ()) -> TableRow {
        didSelectHandler = handler
        return self
    }
    
    @discardableResult
    public func didDeselect(_ handler: @escaping () -> ()) -> TableRow {
        didDeselectHandler = handler
        return self
    }
    
    @discardableResult
    public func didUnhighlight(_ handler: @escaping () -> ()) -> TableRow {
        didUnhighlightHandler = handler
        return self
    }
    
    @discardableResult
    public func editingStyle(_ value: UITableViewCell.EditingStyle) -> TableRow {
        editingStyle = value
        editingStyleHandler = nil
        return self
    }
    
    @discardableResult
    public func editingStyle(_ handler: @escaping Return<UITableViewCell.EditingStyle>) -> TableRow {
        editingStyleHandler = handler
        editingStyle = nil
        return self
    }
    
    @discardableResult
    public func leadingSwipeActionsConfiguration(_ value: UISwipeActionsConfiguration) -> TableRow {
        leadingSwipeActionsConfiguration = value
        leadingSwipeActionsConfigurationHandler = nil
        return self
    }
    
    @discardableResult
    public func leadingSwipeActionsConfiguration(_ handler: @escaping Return<UISwipeActionsConfiguration>) -> TableRow {
        leadingSwipeActionsConfigurationHandler = handler
        leadingSwipeActionsConfiguration = nil
        return self
    }
    
    @discardableResult
    public func trailingSwipeActionsConfiguration(_ value: UISwipeActionsConfiguration) -> TableRow {
        trailingSwipeActionsConfiguration = value
        trailingSwipeActionsConfigurationHandler = nil
        return self
    }
    
    @discardableResult
    public func trailingSwipeActionsConfiguration(_ handler: @escaping Return<UISwipeActionsConfiguration>) -> TableRow {
        trailingSwipeActionsConfigurationHandler = handler
        trailingSwipeActionsConfiguration = nil
        return self
    }
    
    override func register(in table: UITableView?) {
        if nib == nil {
            table?.register(T.self, forCellReuseIdentifier: identifier)
        } else {
            table?.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    override func setup(_ cell: UITableViewCell) {
        setupHandler?(cell as! T)
    }
    
}
