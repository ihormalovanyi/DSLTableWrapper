//
//  File.swift
//  
//
//  Created by Ihor Malovanyi on 09.05.2022.
//

import Foundation

public protocol ProjectedTableRowGroup {
    
    var values: [TableRowBase] { get }
    
}

extension TableRowBase: ProjectedTableRowGroup {
    
    public var values: [TableRowBase] { [self] }
    
}

extension Array: ProjectedTableRowGroup where Element: TableRowBase {
    
    public var values: [TableRowBase] { self }
    
}

@resultBuilder
public struct ProjectedTableSectionBuilder {
    
    public static func buildBlock(_ components: ProjectedTableRowGroup...) -> [TableRowBase] { components.flatMap(\.values) }
    public static func buildOptional(_ components: [ProjectedTableRowGroup]?) -> [TableRowBase] { components?.flatMap(\.values) ?? [] }
    public static func buildEither(first components: [ProjectedTableRowGroup]) -> [TableRowBase] { components.flatMap(\.values) }
    public static func buildEither(second components: [ProjectedTableRowGroup]) -> [TableRowBase] { components.flatMap(\.values) }
    public static func buildArray(_ components: [ProjectedTableRowGroup]) -> [TableRowBase] { components.flatMap(\.values) }
    
}

public protocol ProjectedTableSectionGroup {
    
    var values: [TableSection] { get }
    
}

extension TableSection: ProjectedTableSectionGroup {
    
    public var values: [TableSection] { [self] }
    
}

extension Array: ProjectedTableSectionGroup where Element: TableSection {
    
    public var values: [TableSection] { self }
    
}

@resultBuilder
public struct ProjectedTableDataSourceBuilder {
    
    public static func buildBlock(_ components: ProjectedTableSectionGroup...) -> [TableSection] { components.flatMap(\.values) }
    public static func buildOptional(_ components: [ProjectedTableSectionGroup]?) -> [TableSection] { components?.flatMap(\.values) ?? [] }
    public static func buildEither(first components: [ProjectedTableSectionGroup]) -> [TableSection] { components.flatMap(\.values) }
    public static func buildEither(second components: [ProjectedTableSectionGroup]) -> [TableSection] { components.flatMap(\.values) }
    public static func buildArray(_ components: [[ProjectedTableSectionGroup]]) -> [TableSection] { components.reduce([], +).flatMap(\.values) }
    
}
