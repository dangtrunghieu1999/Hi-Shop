//
//  ProductParentCommentCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class CommentCollectionViewCell: BaseCommentCollectionViewCell {
    override func initialize() {
        super.initialize()
        setupLayout(isParentComment: true)
    }
}
