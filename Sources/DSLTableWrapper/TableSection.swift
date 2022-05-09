//
//  File.swift
//  
//
//  Created by Ihor Malovanyi on 09.05.2022.
//

import UIKit

public class TableSection {
    
    public class HeaderFooterElement {
        
        var string: String?
        var stringHandler: Return<String>?
        
        var view: UIView?
        var viewHandler: Return<UIView>?
        
        var height: CGFloat?
        var heightHandler: Return<CGFloat>?
        
        var estimatedHeight: CGFloat?
        var estimatedHeightHandler: Return<CGFloat>?
        
        var willDisplayHandler: ((UIView) -> ())?
        var didEndDisplayHandler: ((UIView) -> ())?
        
        public static func defaultLabel(_ text: String) -> HeaderFooterElement {
            let result = HeaderFooterElement()
            result.string = text
            
            return result
        }
        
        public static func defaultLabel(_ handler: @escaping Return<String>) -> HeaderFooterElement {
            let result = HeaderFooterElement()
            result.stringHandler = handler
            
            return result
        }
        
        public static func view(_ view: UIView) -> HeaderFooterElement {
            let result = HeaderFooterElement()
            result.view = view
            
            return result
        }
        
        public static func view(_ handler: @escaping Return<UIView>) -> HeaderFooterElement {
            let result = HeaderFooterElement()
            result.viewHandler = handler
            
            return result
        }
        
        @discardableResult
        public func willDisplay(_ handler: @escaping (UIView) -> ()) -> HeaderFooterElement {
            willDisplayHandler = handler
            return self
        }
        
        @discardableResult
        public func didEndDisplay(_ handler: @escaping (UIView) -> ()) -> HeaderFooterElement {
            didEndDisplayHandler = handler
            return self
        }
        
        @discardableResult
        public func height(_ value: CGFloat) -> HeaderFooterElement {
            height = value
            heightHandler = nil
            return self
        }
        
        @discardableResult
        public func height(_ handler: @escaping Return<CGFloat>) -> HeaderFooterElement {
            heightHandler = handler
            height = nil
            return self
        }
        
        @discardableResult
        public func estimatedHeight(_ value: CGFloat) -> HeaderFooterElement {
            estimatedHeight = value
            estimatedHeightHandler = nil
            return self
        }
        
        @discardableResult
        public func estimatedHeight(_ handler: @escaping Return<CGFloat>) -> HeaderFooterElement {
            estimatedHeightHandler = handler
            estimatedHeight = nil
            return self
        }
        
    }
    
    var rows: [TableRowBase]
    
    private(set) var header: HeaderFooterElement?
    private(set) var footer: HeaderFooterElement?
    
    public init(@ProjectedTableSectionBuilder _ build: () -> ([TableRowBase])) {
        rows = build()
    }
    
    func registerRows(in table: UITableView?) {
        rows.forEach { $0.register(in: table) }
    }
    
    @discardableResult
    public func header(_ value: HeaderFooterElement?) -> TableSection {
        header = value
        return self
    }
    
    @discardableResult
    public  func footer(_ value: HeaderFooterElement?) -> TableSection {
        footer = value
        return self
    }
    
}
