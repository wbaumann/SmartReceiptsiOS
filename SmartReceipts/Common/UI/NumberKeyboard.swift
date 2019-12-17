//
//  NumberKeyboard.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/03/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

protocol NumberKeyboardDelegate: class {
    func didRemove()
    func didInsert(char: String)
}

class NumberKeyboard: UIView, UIInputViewAudioFeedback {
    var delegate: NumberKeyboardDelegate?
    @IBOutlet weak var decimalSeparator: UIButton!
    @IBOutlet var roundedViews: [UIButton]!
    
    class func create(delegate: NumberKeyboardDelegate? = nil) -> NumberKeyboard {
        let nib = "NumberKeyboard"
        let keyboard = Bundle.main.loadNibNamed(nib, owner: nil, options: nil)!.first! as! NumberKeyboard
        keyboard.delegate = delegate
        return keyboard
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        decimalSeparator.setTitle(Locale.current.decimalSeparator, for: .normal)
        for view in roundedViews {
            view.layer.cornerRadius = AppTheme.buttonCornerRadius
            view.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9254901961, alpha: 1)
            view.layer.borderWidth = 1
        }
    }
    
    //MARK: - Actions
    
    @IBAction func charTap(button: UIButton) {
        guard let char = button.titleLabel?.text else { return }
        UIDevice.current.playInputClick()
        delegate?.didInsert(char: char)
    }
    
    @IBAction func removeTap() {
        delegate?.didRemove()
        UIDevice.current.playInputClick()
    }
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
}

extension UITextField: NumberKeyboardDelegate {
    func didRemove() {
        deleteBackward()
    }
    
    func didInsert(char: String) {
        insertText(char)
    }
}
