//
//  File.swift
//  
//
//  Created by Ihor Malovanyi on 09.05.2022.
//

import UIKit

public class ProjectedTableDataSourceDelegate: NSObject {
    
    private(set) var sections: [TableSection] = []
    private var rowMap: [IndexPath : TableRowBase] = [:]
    
    private weak var table: UITableView?
    private var registeredIdentifiers: Set<String> = []
    
    private var indexTitles: [String]?
    private var indexTitlesHandler: Return<[String]>?
    
    init(_ table: UITableView) {
        super.init()
        
        self.table = table
    }
    
    @discardableResult
    public func reload(@ProjectedTableDataSourceBuilder _ build: () -> [TableSection]) -> ProjectedTableDataSourceDelegate {
        sections = build()
        
        rowMap = [:]
        
        sections.enumerated().forEach { section, sectionElement in
            sectionElement.rows.enumerated().forEach { row, rowElement in
                rowMap[IndexPath(row: row, section: section)] = rowElement
                rowElement.register(in: table)
            }
        }
        
        table?.reloadData()
        
        return self
    }
    
    @discardableResult
    public func sectionIndexTitles(_ values: [String]?) -> ProjectedTableDataSourceDelegate {
        indexTitles = values
        indexTitlesHandler = nil
        table?.reloadData()
        return self
    }
    
    @discardableResult
    public func sectionIndexTitles(_ handler: @escaping Return<[String]>) -> ProjectedTableDataSourceDelegate {
        indexTitlesHandler = handler
        indexTitles = nil
        table?.reloadData()
        
        return self
    }
    
    public func select(_ value: TableRowBase, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        guard let indexPath = rowMap.first(where: { $0.value === value })?.key else { return }
        table?.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
}

extension ProjectedTableDataSourceDelegate: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Data Source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowMap[indexPath]
        let cell = tableView.dequeueReusableCell(withIdentifier: row?.identifier ?? "", for: indexPath)
        
        row?.setup(cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header?.stringHandler?() ?? sections[section].header?.string
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer?.stringHandler?() ?? sections[section].footer?.string
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        rowMap[indexPath]?.canEditHandler?() ?? rowMap[indexPath]?.canEdit ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        rowMap[indexPath]?.canMoveHandler?() ?? rowMap[indexPath]?.canMove ?? false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        indexTitlesHandler?() ?? indexTitles
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.commitHandler?(editingStyle)
    }
    
    //MARK: TODO
//    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    //MARK: Delegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.willDisplayHandler?()
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        sections[section].header?.willDisplayHandler?(view)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        sections[section].footer?.willDisplayHandler?(view)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.didEndDisplayHandler?()
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        sections[section].header?.didEndDisplayHandler?(view)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        sections[section].footer?.didEndDisplayHandler?(view)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowMap[indexPath]?.heightHandler?() ?? rowMap[indexPath]?.height ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].header?.heightHandler?() ?? sections[section].header?.height ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sections[section].footer?.heightHandler?() ?? sections[section].footer?.height ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        rowMap[indexPath]?.estimatedHeightHandler?() ?? rowMap[indexPath]?.estimatedHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        sections[section].header?.estimatedHeightHandler?() ?? sections[section].header?.estimatedHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        sections[section].footer?.estimatedHeightHandler?() ?? sections[section].footer?.estimatedHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].header?.viewHandler?() ?? sections[section].header?.view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sections[section].footer?.viewHandler?() ?? sections[section].footer?.view
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        rowMap[indexPath]?.accessoryButtonAction?()
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        rowMap[indexPath]?.shouldHighlightHandler?() ?? true
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.didHighlightHandler?()
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.didUnhighlightHandler?()
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        rowMap[indexPath]?.willSelectHandler?() == false ? nil : indexPath
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        rowMap[indexPath]?.willDeselectHandler?() == false ? nil : indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.didSelectHandler?()
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        rowMap[indexPath]?.didDeselectHandler?()
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        rowMap[indexPath]?.editingStyleHandler?() ?? rowMap[indexPath]?.editingStyle ?? .none
    }

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        nil
    }

    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        rowMap[indexPath]?.leadingSwipeActionsConfigurationHandler?() ?? rowMap[indexPath]?.leadingSwipeActionsConfiguration
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        rowMap[indexPath]?.trailingSwipeActionsConfigurationHandler?() ?? rowMap[indexPath]?.trailingSwipeActionsConfiguration
    }

    //MARK: TODO

//    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    
//    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    
//    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    
//    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    
//    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    
//    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    
//    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    
//    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    
//    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    
//    public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
    
}
