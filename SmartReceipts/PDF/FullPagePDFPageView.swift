//
//  FullPagePDFPageView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class FullPagePDFPageView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var pageRenderView: PDFPageRenderView!
    
    func renderPage(page: CGPDFPage, title: String?) {
        titleLabel.text = title
        pageRenderView.render(page: page)
    }
}
