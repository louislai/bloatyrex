//
//  NestingZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 4/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// This class serves as a container for subprograms that may like within constructs such as 
/// a while loop or the branches of an if else clause.
class NestingZone: SKNode, ContainerBlockProtocol {
    var blocks = [CodeBlock]()
    var count: Int {
        get {
            return blocks.count
        }
    }

    /**
     The dropZones of each block in this nesting zone make up the dropZones available due to this 
     class
     **/
    var dropZones: [DropZone] {
        get {
            return blocks.flatMap { $0.actionZones }
        }
    }

    /**
     Inserts a code block given an insertionPosition as appropriate
     **/
    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition) {
        if let position = insertionPosition.position {
            blocks.insert(block, atIndex: position - 1)
            self.addChild(block)
            flushBlocks()
        }
    }

    /**
     Removes the code block at given index.
     **/
    func removeBlockAtIndex(index: Int) {
        blocks.removeAtIndex(index - 1)
    }

    /**
     Unfocuses all contained blocks
     **/
    func unfocus() {
        for block in blocks {
            block.unfocus()
        }
    }

    /**
     Gets the selected block given a location. Typically used to find out which of the containing
     block is being clicked.
     **/
    func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let correctedLocation = CGPoint(x: x, y: y)
        for block in blocks {
            if block.containsPoint(correctedLocation) {
                return block.getBlock(correctedLocation)
            }
        }
        return nil
    }

    /**
     Returns the subprogram contained by this nestingZone. If the contained subprogram is invalid,
     nil is returned.
     **/
    func parseBlock(programCounter: Int) -> Program? {
        guard blocks.count > programCounter else {
            return nil
        }

        let block: Statement?
        switch blocks[programCounter].getBlockConstruct() {
        case .ActionConstruct(let action):
            switch action {
            case .Forward(let block):
                block?.unhighlight()
            case .Jump(let block):
                block?.unhighlight()
            case .RotateLeft(let block):
                block?.unhighlight()
            case .RotateRight(let block):
                block?.unhighlight()
            case .NoAction(let block):
                block?.unhighlight()
            case .ChooseButton(_, let block):
                block?.unhighlight()
            }
            block = Statement.ActionStatement(action)
        case .LoopExpressionConstruct(let loopExpression):
            block = Statement.LoopStatement(loopExpression)
        case .ConditionalExpressionConstruct(let conditionalExpression):
            block = Statement.ConditionalStatement(conditionalExpression)
        default:
            block = nil
        }

        if let statement = block {
            if blocks.count > programCounter + 1 {
                if let nextBlock = parseBlock(programCounter + 1) {
                    return Program.MultipleStatement(statement, nextBlock)
                } else {
                    return nil
                }
            } else {
                return Program.SingleStatement(statement)
            }
        } else {
            return nil
        }
    }

    /**
     Realigns the contained blocks
     **/
    func flushBlocks() {
        var yPos: CGFloat = 0
        let xPos: CGFloat = 0
        for (i, block) in blocks.enumerate() {
            block.blockPosition = i + 1
            block.position.x = xPos
            block.flushBlocks()
            yPos -= block.calculateAccumulatedFrame().height
            block.position.y = yPos
        }
    }

    func activateDropZones() {
        for block in blocks {
            block.activateDropZone()
        }
    }

    func deactivateDropZones() {
        for block in blocks {
            block.deactivateDropZone()
        }
    }
}
