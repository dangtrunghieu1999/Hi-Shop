//
//  ACTabScrollViewDelegateB.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 15/09/2021.
//

import UIKit

public protocol ACTabScrollViewDelegateB {
    
    // triggered by stopping at particular page
    func tabScrollView(_ tabScrollView: ACTabScrollViewB, didChangePageTo index: Int)
    
    // triggered by scrolling through any pages
    func tabScrollView(_ tabScrollView: ACTabScrollViewB, didScrollPageTo index: Int)
}

public protocol ACTabScrollViewDataSourceB {
    
    // get pages count
    func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollViewB) -> Int
    
    // get the tab at index
    func tabScrollView(_ tabScrollView: ACTabScrollViewB, tabViewForPageAtIndex index: Int) -> UIView
    
    // get the content at index
    func tabScrollView(_ tabScrollView: ACTabScrollViewB, contentViewForPageAtIndex index: Int) -> UIView
}
