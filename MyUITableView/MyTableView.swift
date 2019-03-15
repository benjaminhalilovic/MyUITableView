//
//  MyTableView.swift
//  MyUITableView
//
//  Created by mac on 13/02/2018.
//  Copyright © 2018 Benjamin Halilovic. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MyTableViewDataSource {
    func tableView(_ tableView:MyTableView, numberOfRowsInSection section: NSInteger) -> NSInteger
    func tableView(_ tableView:MyTableView, cellForRowAtIndexPath _index: NSIndexPath) -> UITableViewCell
    @objc optional func numberOfSectionInTableView(_ tableView: MyTableView) -> NSInteger
    @objc optional func tableView(_ tableView: MyTableView, titleForHeaderInSection: NSInteger) -> NSInteger
    @objc optional func tableView(_ tableView: MyTableView, titleForFooterInSection: NSInteger) -> NSInteger
    @objc optional func tableView(_ tableView: MyTableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    @objc optional func tableView(_ tableView: MyTableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
}

@objc protocol MyTableViewDelegate {
    @objc optional func tableView(_ tableView: MyTableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: MyTableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath
    @objc optional func tableView(_ tableView: MyTableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    @objc optional func tableView(_ tableView: MyTableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath
    @objc optional func tableView(_ tableView: MyTableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    
    @objc optional func tableView(_ tableView: MyTableView, heightForHeaderInSection section: NSInteger) -> CGFloat
    @objc optional func tableView(_ tableView: MyTableView, heightForFooterInSection section: NSInteger) -> CGFloat
    @objc optional func tableView(_ tableView: MyTableView, viewForHeaderInSection section: NSInteger) -> UIView
    @objc optional func tableView(_ tableView: MyTableView, viewForFooterInSection section: NSInteger) -> UIView
    
    @objc optional func tableView(_ tableView: MyTableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath)
    @objc optional func tableView(_ tableView: MyTableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath)
    @objc optional func tableView(_ tableView: MyTableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> NSString
}




enum UITableViewStyle: Int {
    case UITableViewStylePlain
    case UITableViewStyleGrouped
}

enum UITableViewScrollPosition: Int {
    case UITableViewScrollPositionNone
    case UITableViewScrollPositionTop
    case UITableViewScrollPositionMiddle
    case UITableViewScrollPositionBottom
}

enum UITableViewRowAnimation: Int {
    case UITableViewRowAnimationFade
    case UITableViewRowAnimationRight
    case UITableViewRowAnimationLeft
    case UITableViewRowAnimationTop
    case UITableViewRowAnimationBottom
    case UITableViewRowAnimationNone
    case UITableViewRowAnimationMiddle
    case UITableViewRowAnimationAutomatic = 100
}

var UITableViewDefaulRowHeight:CGFloat = 500

open class MyTableView:UIScrollView {
    
    var style: UITableViewStyle
    var rowHeight: CGFloat?
    var separatorStyle: UITableViewCellSeparatorStyle?
    var separatorColor: UIColor?
    var tableHeaderView: UIView? {
        didSet {
            if tableHeaderView != oldValue {
                oldValue?.removeFromSuperview()
                setContetnSize()
                addSubview(tableHeaderView!)
            }
        }
    }
    var tableFooterView: UIView? {
        didSet(value) {
            if value != tableFooterView {
                tableFooterView?.removeFromSuperview()
                tableFooterView = value
                self.setContetnSize()
                addSubview(tableFooterView!)
            }
        }
    }
    var backgroundView: UIView? {
         didSet(value) {
            if value != backgroundView {
                backgroundView?.removeFromSuperview()
                backgroundView = value
                insertSubview(backgroundView!, at: 0)
            }
        }
    }
    
    var allowsSection: Bool = true
    var editing: Bool = false
    var sectionHeaderHeight: CGFloat
    var sectionFooterHeight: CGFloat
    
    fileprivate var cachedCells: NSMutableDictionary
    fileprivate var reusableCells: NSMutableSet
    fileprivate var sections: NSMutableArray
    
    fileprivate var selectedRow: NSIndexPath?
    fileprivate var highlightedRow: NSIndexPath?
    
    fileprivate var needReload: Bool = false /*{
        didSet  {
            if needReload {
                print("need reload")
                setNeedsLayout()
            }
        }
    }*/
    
    
    weak var dataSource:MyTableViewDataSource? {
        didSet {
          setNeedReload()
        }
    }
    
    weak var delegateTable: MyTableViewDelegate? {
        didSet {
            setNeedReload()
        }
    }
    
    /*Override frame (setFrame)*/
    override open var frame: CGRect {
        didSet (newValue) {
            let oldValue = self.frame
            if oldValue.equalTo(newValue) {
                super.frame = newValue
                if oldValue.size.width != newValue.size.width {
                    updateSectionsCache()
                }
                setContetnSize()
            }
        }
    }
    
    
    init(withFrame frame:CGRect, style theStyle: UITableViewStyle) {
        style = theStyle
        cachedCells = NSMutableDictionary()
        sections = NSMutableArray()
        reusableCells = NSMutableSet()
      
        separatorColor = UIColor.init(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        separatorStyle = UITableViewCellSeparatorStyle.singleLine
        allowsSection = true
        sectionHeaderHeight = 22
        sectionFooterHeight = 22
        super.init(frame: frame)
        
        if (style == UITableViewStyle.UITableViewStylePlain) {
            backgroundColor = UIColor.white
        }
        showsHorizontalScrollIndicator = false

        setNeedReload()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateSectionsCache() {
        //Assume there aren't section Header and Footer
        for previousSectionRecord in sections as! [MyTableViewSection]{
            previousSectionRecord.headerView?.removeFromSuperview()
            previousSectionRecord.footerView?.removeFromSuperview()
        }
        
        sections.removeAllObjects()
        
        if dataSource != nil {
            let defaultRowHeight: CGFloat = rowHeight != nil ? rowHeight! : UITableViewDefaulRowHeight
            let numberOfSection = self.numberOfSection()
            for section in 0..<numberOfSection {
                let numberOfRowsInSection = self.numberOfRowsInSection(section: section)
                let sectionRecord = MyTableViewSection()
                /*
                 sectionRecord.headerTitle = _dataSourceHas.titleForHeaderInSection? [self.dataSource tableView:self titleForHeaderInSection:section] : nil;
                 sectionRecord.footerTitle = _dataSourceHas.titleForFooterInSection? [self.dataSource tableView:self titleForFooterInSection:section] : nil;
                 
                 sectionRecord.headerHeight = _delegateHas.heightForHeaderInSection? [self.delegate tableView:self heightForHeaderInSection:section] : _sectionHeaderHeight;
                 sectionRecord.footerHeight = _delegateHas.heightForFooterInSection ? [self.delegate tableView:self heightForFooterInSection:section] : _sectionFooterHeight;
                 
                 sectionRecord.headerView = (sectionRecord.headerHeight > 0 && _delegateHas.viewForHeaderInSection)? [self.delegate tableView:self viewForHeaderInSection:section] : nil;
                 sectionRecord.footerView = (sectionRecord.footerHeight > 0 && _delegateHas.viewForFooterInSection)? [self.delegate tableView:self viewForFooterInSection:section] : nil;
                 
                 // make a default section header view if there's a title for it and no overriding view
                 if (!sectionRecord.headerView && sectionRecord.headerHeight > 0 && sectionRecord.headerTitle) {
                 sectionRecord.headerView = [UITableViewSectionLabel sectionLabelWithTitle:sectionRecord.headerTitle];
                 }
                 
                 // make a default section footer view if there's a title for it and no overriding view
                 if (!sectionRecord.footerView && sectionRecord.footerHeight > 0 && sectionRecord.footerTitle) {
                 sectionRecord.footerView = [UITableViewSectionLabel sectionLabelWithTitle:sectionRecord.footerTitle];
                 }
                 */
                
                if let sectionHeaderView = sectionRecord.headerView {
                    addSubview(sectionHeaderView)
                } else {
                    sectionRecord.headerHeight = 0
                }
                
                if let sectionFooterView = sectionRecord.footerView {
                    addSubview(sectionFooterView)
                } else {
                    sectionRecord.footerHeight = 0
                }
                
                var rowHeights : [CGFloat] = []
                var totalRowHeight: CGFloat = 0
                for _ in 0..<numberOfRowsInSection {
                    //Need to add custom row height
                    let rowHeight = defaultRowHeight
                    rowHeights.append(rowHeight)
                    totalRowHeight += rowHeight
                }
                sectionRecord.rowsHeight = totalRowHeight
                sectionRecord.setNumberOfRows(rows: numberOfRowsInSection, withHeights: rowHeights)
                sections.add(sectionRecord)
            }
            
        }
    }
    
    func updateSectionCacheIfNeeded() {
        if sections.count == 0 {
            updateSectionsCache()
        }
    }
    
    func setContetnSize(){
        updateSectionCacheIfNeeded()
        var height:CGFloat = 0
        if let header = tableHeaderView {
            height = header.frame.size.height
        }
        for section in sections as! [MyTableViewSection] {
            height += section.sectionHeight
        }
        if let footer = tableFooterView {
            height = footer.frame.size.height
        }
        self.contentSize = CGSize(width: 0, height: height)
    }

    
    
   
    
    
    
    func layoutTableView() {
        let boundSize: CGSize = self.bounds.size
        let contentOffset: CGFloat = self.contentOffset.y
        let visibleBounds = CGRect(x: 0, y: contentOffset, width: boundSize.width, height: boundSize.height)
        var tableHeight:CGFloat = 0
        
        if let header = tableHeaderView {
            var tableHeaderFrame = header.frame
            tableHeaderFrame.origin = .zero
            tableHeaderFrame.size.width = boundSize.width
            tableHeaderView?.frame = tableHeaderFrame
            tableHeight += tableHeaderFrame.size.height
        }
        
        //layout section and rows
        let availableCells: NSMutableDictionary = cachedCells.mutableCopy() as! NSMutableDictionary
        let numberOfSection = sections.count
        cachedCells.removeAllObjects()
        
        for section in 0..<numberOfSection {
            let sectionRect = rectForSection(section: section)
            tableHeight += sectionRect.size.height
            
            if sectionRect.intersects(visibleBounds) {
                let headerRect = rectForHeaderInSection(section: section)
                let footerRect = rectForFooterInSection(section: section)
                let sectionRecord = sections.object(at: section) as! MyTableViewSection
                let numberOfRows = sectionRecord.numberOfRows
                
                if sectionRecord.headerView != nil {
                    sectionRecord.headerView?.frame = headerRect
                }
                
                if sectionRecord.footerView != nil {
                    sectionRecord.footerView?.frame = footerRect
                }
                for row in 0..<numberOfRows {
                    let indexPath = NSIndexPath.init(row: row, section: section)
                    let rowRect = rectForRowAtIndexPath(at: indexPath)
                    if (rowRect.intersects(visibleBounds) && rowRect.size.height > 0) {
                        let cell  = availableCells.object(forKey: indexPath) as? UITableViewCell ?? dataSource?.tableView(self, cellForRowAtIndexPath: indexPath)
                        if let cellRecord = cell {
                            cachedCells .setObject(cellRecord, forKey: indexPath)
                            availableCells.removeObject(forKey: indexPath)
                            cellRecord.frame = rowRect
                            cellRecord.backgroundColor = UIColor.orange
                            addSubview(cellRecord)
                        }
                    }
                }
            }
        }

        for cell in availableCells.allValues as! [UITableViewCell] {
            print("Available cell count \(availableCells.allValues.count)")
            if (cell.reuseIdentifier != nil) {
                reusableCells.add(cell)
            } else {
                cell.removeFromSuperview()
            }
        }
        
        // now make sure that all available (but unused) reusable cells aren't on screen in the visible area.
        // this is done becaue when resizing a table view by shrinking it's height in an animation, it looks better. The reason is that
        // when an animation happens, it sets the frame to the new (shorter) size and thus recalcuates which cells should be visible.
        // If it removed all non-visible cells, then the cells on the bottom of the table view would disappear immediately but before
        // the frame of the table view has actually animated down to the new, shorter size. So the animation is jumpy/ugly because
        // the cells suddenly disappear instead of seemingly animating down and out of view like they should. This tries to leave them
        // on screen as long as possible, but only if they don't get in the way.
        /*NSArray* allCachedCells = [_cachedCells allValues];
         for (UITableViewCell *cell in _reusableCells) {
         if (CGRectIntersectsRect(cell.frame,visibleBounds) && ![allCachedCells containsObject: cell]) {
         [cell removeFromSuperview];
         }
         }*/
        
        if let footer = tableFooterView {
            var tableFooterFrame = footer.frame
            tableFooterFrame.origin = CGPoint(x: 0, y: tableHeight)
            tableFooterFrame.size.width = boundSize.width
            tableFooterView?.frame = tableFooterFrame
        }
        
        
    }
    
    private func cgRectFromVerticalOffset(offset: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: offset, width: bounds.size.width, height: height)
    }
    
    private func offsetForSection(section: NSInteger) -> CGFloat {
        var offset: CGFloat = 0
        if let headerView = tableHeaderView {
            offset = headerView.frame.size.height
        }
        
        for i in 0..<section {
            let sect = sections.object(at: i) as! MyTableViewSection
            offset += sect.sectionHeight
        }
        return offset
    }
    
    func rectForSection(section: NSInteger) -> CGRect {
        self.updateSectionCacheIfNeeded()
        return cgRectFromVerticalOffset(offset: offsetForSection(section: section), height: (sections.object(at: section) as! MyTableViewSection).sectionHeight)
    }
    
    func rectForHeaderInSection(section: NSInteger) -> CGRect {
        self.updateSectionCacheIfNeeded()
        return cgRectFromVerticalOffset(offset: offsetForSection(section: section), height: (sections.object(at: section) as! MyTableViewSection).headerHeight)
    }
    
    func rectForFooterInSection(section: NSInteger) -> CGRect {
        self.updateSectionCacheIfNeeded()
        let sectionRecord = sections.object(at: section) as! MyTableViewSection
        var offset: CGFloat = offsetForSection(section: section)
        offset += sectionRecord.headerHeight
        offset += sectionRecord.rowsHeight
        return cgRectFromVerticalOffset(offset: offset, height: sectionRecord.footerHeight)
    }
    
    func rectForRowAtIndexPath(at indexPath: NSIndexPath) -> CGRect {
        self.updateSectionCacheIfNeeded()
        if (indexPath.section < sections.count) {
            let sectionRecord = sections.object(at: indexPath.section) as! MyTableViewSection
            let row = indexPath.row
            if (row < sectionRecord.numberOfRows) {
                let rowHeights = sectionRecord.rowHeights
                var offset = offsetForSection(section: indexPath.section)
                offset += sectionRecord.headerHeight
                
                for currentRow in 0..<row {
                    offset += rowHeights[currentRow]
                }
                return cgRectFromVerticalOffset(offset: offset, height: rowHeights[row])
            }
        }
        return CGRect.zero
    }
    
    func beginUpdates() {
        
    }
    
    func endUpdates() {
        
    }
    
    func cellForRowAtIndexPath(_ indexPath: NSIndexPath) -> UITableViewCell? {
        //Problem called before layout table view
        if cachedCells.count > 0 {
            return cachedCells.object(forKey: indexPath) as? UITableViewCell
        }
        return nil
        
    }
    
    
    // This needs to return the index paths even if the cells don't exist in any caches or are not on screen
    // For now I'm assuming the cells stretch all the way across the view. It's not clear to me if the real
    // implementation gets anal about this or not (haven't tested it).
    func indexPathsForRowsInRect(rect: CGRect) -> NSArray {
        updateSectionCacheIfNeeded()

        let result = NSMutableArray()
        let numberOfSection = sections.count
        
        var offset : CGFloat = 0
        if let tableHeaderView = tableHeaderView {
             offset = tableHeaderView.frame.size.height
        }
        
        for section in 0..<numberOfSection {
            let sectionRecord = sections.object(at: section) as! MyTableViewSection
            let rowHeights = sectionRecord.rowHeights
            
            let numberOfRows = sectionRecord.numberOfRows
            
            if (offset + sectionRecord.rowsHeight >= rect.origin.y) {
                for row in 0..<numberOfRows {
                   let height = rowHeights[row]
                    let simpleRowRect = CGRect(x: rect.origin.x
                        , y: offset, width: rect.size.width, height: height)
                    
                    if rect.intersects(simpleRowRect) {
                        result.add(NSIndexPath(row: row, section: section))
                    } else if(simpleRowRect.origin.y > rect.origin.y + rect.size.height) {
                        break
                    }
                    offset += height
                }
                
            } else {
                //Increment until we arrive to rect.origin.y
                offset += sectionRecord.rowsHeight
            }
            
            offset += sectionRecord.footerHeight
        }
        
        return result
    }
    
    
    func indexPathForRowAtPoint(_ point: CGPoint) -> NSIndexPath? {
        let array = indexPathsForRowsInRect(rect: CGRect(x: point.x, y: point.y, width: 1, height: 1))
        return (array.count > 0) ? array.object(at: 0) as? NSIndexPath : nil
    }
    
    func indexPathForVisibleRows() -> NSArray  {
        layoutTableView()
        let indexes: NSMutableArray = NSMutableArray(capacity: cachedCells.count)
        let bounds = self.bounds
        
        // Special note - it's unclear if UIKit returns these in sorted order. Because we're assuming that visibleCells returns them in order (top-bottom)
        // and visibleCells uses this method, I'm going to make the executive decision here and assume that UIKit probably does return them sorted - since
        // there's nothing warning that they aren't. :)
        for indexPath in cachedCells.allKeys {
            if bounds.intersects(rectForRowAtIndexPath(at: indexPath as! NSIndexPath)){
                indexes.add(indexPath)
            }
        }
        return indexes
    }
    
    
    func numberOfSection() -> NSInteger {
        if let number = dataSource?.numberOfSectionInTableView?(self) {
            return number
        }
        return 1
    }
    
    func numberOfRowsInSection(section: NSInteger) -> NSInteger {
        return (dataSource?.tableView(self, numberOfRowsInSection: section))!
    }
    
    
    func reloadData() {
        let cachedcells = cachedCells.allValues as! [UIView]
        cachedcells.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let reusablecells = reusableCells
        reusablecells.forEach { subview in
            (subview as AnyObject).removeFromSuperview()
        }
        
        reusableCells.removeAllObjects()
        cachedCells.removeAllObjects()
        
        selectedRow = nil
        highlightedRow = nil
        
        updateSectionsCache()
        setContetnSize()
        
        needReload = false
    }
    
    fileprivate func reloadDataIfNeeded() {
        if needReload {
            reloadData()
        }
    }
    
    fileprivate func setNeedReload() {
        needReload = true
        setNeedsLayout()
    }
    
    override open func layoutSubviews() {
        print("Layout subview")
        backgroundView?.frame = self.bounds
        reloadDataIfNeeded()
        layoutTableView()
        super.layoutSubviews()
    }
    
    func indexPathForSelectedRow() -> NSIndexPath? {
        return selectedRow
    }
    
    func indexPathForCell(_ cell: UITableViewCell) -> NSIndexPath? {
        let cachedCellsIndex = cachedCells.allKeys as! [NSIndexPath]
        for index in cachedCellsIndex {
            if cachedCells.object(forKey: index) as! UITableViewCell == cell {
                return index
            }
        }
        
        return nil
    }
    
    func deselectRowAtIndexPath(_ indexPath: NSIndexPath, animated: Bool) {
        if indexPath.isEqual(selectedRow) {
            cellForRowAtIndexPath(selectedRow!)?.setSelected(false, animated: false)
            selectedRow = nil
        }
    }
    
    func selectRowAtIndexPath(_ indexPath: NSIndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        // unlike the other methods that I've tested, the real UIKit appears to call reload during selection if the table hasn't been reloaded
        // yet. other methods all appear to rebuild the section cache "on-demand" but don't do a "proper" reload. for the sake of attempting
        // to maintain a similar delegate and dataSource access pattern to the real thing, I'll do it this way here. :)
        
        reloadDataIfNeeded()
        if let selectRow = selectedRow {
            if !selectRow.isEqual(indexPath) {
                deselectRowAtIndexPath(selectRow, animated: animated)
                selectedRow = indexPath
                cellForRowAtIndexPath(selectRow)?.setSelected(true, animated: false)
            }
        } else {
            selectedRow = indexPath
            cellForRowAtIndexPath(selectedRow!)?.setSelected(true, animated: false)
        }
        
    }
    
    func dequeueReusableCellWithIdentifier(_ identifier: String) -> UITableViewCell? {
        for cell in reusableCells {
            let cellRecord = cell as! UITableViewCell
            if cellRecord.reuseIdentifier == identifier {
                let strongCell = cellRecord
                reusableCells.remove(cell)
                strongCell.prepareForReuse()
                return strongCell
            }
        }
        return nil
    }
 
    
    
  //End
}
