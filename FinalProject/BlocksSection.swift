//
//  BlocksSection.swift
//  BloatyRex
//
//  Created by Koh Wai Kit on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class BlocksSection: SKNode {

    var sectionHeader: SKShapeNode
    var sectionTitle: SKLabelNode
    var buttons = [BlockButton]()

    init(title: String, color: SKColor) {
        sectionHeader = SKShapeNode(
            rect: CGRect(
                x: 0,
                y: 0,
                width: GlobalConstants.CodeBlocks.blockSectionWidth,
                height: GlobalConstants.CodeBlocks.blockSectionTitleHeight
            )
        )
        sectionHeader.fillColor = color
        sectionTitle = SKLabelNode(text: title)
        sectionTitle.zPosition = 1
        sectionTitle.fontName = GlobalConstants.Font.defaultNameBold
        sectionTitle.fontSize = GlobalConstants.CodeBlocks.blockSectionTitleSize
        sectionTitle.position = CGPoint(x: GlobalConstants.CodeBlocks.blockSectionWidth/2, y: GlobalConstants.CodeBlocks.blockSectionTitleHeight/2)
        super.init()
        self.addChild(sectionHeader)
        self.addChild(sectionTitle)
    }

    func addButton(button: BlockButton) {
        button.position = calculateButtonPosition(buttons.count)
        buttons.append(button)
        self.addChild(button)
    }

    func getButton(location: CGPoint) -> BlockButton? {
        var location = location
        location.x -= self.position.x
        location.y -= self.position.y

        for button in buttons {
            if button.containsPoint(location) {
                return button
            }
        }

        return nil
    }

    private func calculateButtonPosition(index: Int) -> CGPoint {
        let rowLimit = GlobalConstants.CodeBlocks.blockSectionButtonsPerRow
        let margin = GlobalConstants.CodeBlocks.blockSectionMargin
        let size = GlobalConstants.CodeBlocks.blockSize
        let x = (CGFloat(index % rowLimit) + 0.5) * (margin + size)
        let y = -1 * (CGFloat(index / rowLimit) + 0.5) * (margin + size)
        return CGPoint(x: x, y: y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
