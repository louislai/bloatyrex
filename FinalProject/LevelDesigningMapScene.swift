//
//  LevelDesigningMapScene.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 14/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit
import Darwin

struct DesigningMapConstants {
    struct Dimension {
        static let minNumberOfRows = 1
        static let maxNumberOfRows = 8
        static let defaultNumberOfRows = 6
        static let minNumberOfColumns = 1
        static let maxNumberOfColumns = 8
        static let defaultNumberOfColumns = 6
    }
    struct Position {
        static let anchor = CGPoint(x: 0.5, y: 0.5)
        static let shiftLeft = CGFloat(-200)
        static let shiftUp = CGFloat(100)

        static let actionButtonY = -GlobalConstants.Dimension.screenHeight/2 + 40
        static let backButton = CGPoint(x: -GlobalConstants.Dimension.screenWidth/2 + 40,
                                        y: actionButtonY)
        static let testLevelButton = CGPoint(x: -100, y: actionButtonY)
        static let saveButton = CGPoint(x: 0, y: actionButtonY)
        static let loadButton = CGPoint(x: 100, y: actionButtonY)
        static let resetButton = CGPoint(x: GlobalConstants.Dimension.screenWidth/2 - 40,
                                         y: actionButtonY)
    }
}

class LevelDesigningMapScene: SKScene {
    var levelDesigningViewController: LevelDesigningViewController?
    var map: Map!
    let blocksLayer = SKNode()
    let unitsLayer = SKNode()
    let paletteLayer = SKNode()
    let actionsLayer = SKNode()
    private var numberOfRows: Int {
        return map.numberOfRows
    }
    private var numberOfColumns: Int {
        return map.numberOfColumns
    }
    var blockSize: CGSize {
        return CGSize(
            width: GlobalConstants.Dimension.blockWidth,
            height: GlobalConstants.Dimension.blockHeight
        )
    }
    var grid: [[SKSpriteNode]]!
    var paletteNode: SKSpriteNode!
    var currentMapUnitTypeSelected = MapUnitType.EmptySpace
    var arrowSprites: [String: SKSpriteNode]!

    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = DesigningMapConstants.Position.anchor
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    func setup() {
        setGrid()

        setLayerPositions()
        addChild(blocksLayer)
        addChild(unitsLayer)

        let palettePosition = CGPoint(x: 0, y: -768/2 + 20 + 95)
        paletteLayer.position = palettePosition
        addChild(paletteLayer)

        addArrows()
        addPalette()
        addActions()
        addBlocks()
        addBorders()
    }

    func setGrid() {
        grid = [[SKSpriteNode]](
            count: numberOfRows,
            repeatedValue: [SKSpriteNode](
                count: numberOfColumns,
                repeatedValue: SKSpriteNode()
            )
        )
    }

    func setLayerPositions() {
        let layerPosition = CGPoint(
            x: -GlobalConstants.Dimension.blockWidth * CGFloat(numberOfColumns) / 2
                + DesigningMapConstants.Position.shiftLeft,
            y: -GlobalConstants.Dimension.blockHeight * CGFloat(numberOfRows) / 2
                + DesigningMapConstants.Position.shiftUp
        )

        // The blocksLayer represent the shape of the map.
        // Each block is a square
        blocksLayer.position = layerPosition

        // This layer holds the MapUnit sprites. The positions of these sprites
        // are relative to the unitsLayer's bottom-left corner.
        unitsLayer.position = layerPosition
    }

    // Set all blocks to empty at the start
    func addBlocks() {
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let mapUnitType = map.retrieveMapUnitAt(row, column: column)!.type
                setBlock(mapUnitType, row: row, column: column)
            }
        }
    }

    func removeBlocks() {
        var blocksToRemove = [SKNode]()
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let blockNode = grid[row][column]
                blockNode.texture = nil
                blocksToRemove.append(blockNode)
            }
        }
        self.removeChildrenInArray(blocksToRemove)
    }

    // Set block at a given row and column with a given image
    func setBlock(mapUnit: MapUnitType, row: Int, column: Int) {
        let blockNode = mapUnit.nodeClass.init()
        // Update model
        map.setMapUnitAt(blockNode, row: row, column: column)

        // Update view
        blockNode.size = blockSize
        blockNode.position = pointFor(row, column: column)
        grid[row][column] = blockNode
        let node = blocksLayer.nodeAtPoint(pointFor(row, column: column))
        blocksLayer.removeChildrenInArray([node])
        blocksLayer.addChild(blockNode)

        // Checker
        // printGrid()
    }

    // Convert a row, column pair into a CGPoint relative to unitsLayer
    func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * GlobalConstants.Dimension.blockWidth,
            y: CGFloat(row) * GlobalConstants.Dimension.blockHeight
        )
    }

    // Convert a CGPoint relative to unitsLayer to a row number
    func rowFor(point: CGPoint) -> Int {
        let pointY = point.y - DesigningMapConstants.Position.shiftUp
        return Int(floor(pointY/GlobalConstants.Dimension.blockHeight
            + (CGFloat(numberOfRows) + 1)/2))
    }

    // Convert a CGPoint relative to unitsLayer to a column number
    func columnFor(point: CGPoint) -> Int {
        let pointX = point.x - DesigningMapConstants.Position.shiftLeft
        return Int(floor(pointX/GlobalConstants.Dimension.blockWidth
            + (CGFloat(numberOfColumns) + 1)/2))
    }

    // Checks if the row and column number is valid
    func isValidRowAndColumn(row: Int, column: Int) -> Bool {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }

    // Prints the grid for checking purposes
    func printGrid() {
//        for row in (0..<map.numberOfRows).reverse() {
//            var string = ""
//            for column in 0..<map.numberOfColumns {
//                string += String(map.retrieveMapUnitAt(row, column: column)!.rawValue) + " "
//            }
//            print(string)
//        }
//        print("=====")
    }
}

// This portion handles user interaction through gestures.
extension LevelDesigningMapScene {
    override func didMoveToView(view: SKView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(LevelDesigningMapScene.handleTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(LevelDesigningMapScene.handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
            action: #selector(LevelDesigningMapScene.handleLongPress(_:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    func handleGesture(sender: UIGestureRecognizer, mapUnitType: MapUnitType) {
        let viewPoint = sender.locationInView(view)
        let scenePoint = convertPointFromView(viewPoint)
        let row = rowFor(scenePoint)
        let column = columnFor(scenePoint)
        if isValidRowAndColumn(row, column: column) {
            setBlock(mapUnitType, row: row, column: column)
        }
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let viewPoint = sender.locationInView(view)
        let scenePoint = convertPointFromView(viewPoint)
        if let name = nodeAtPoint(scenePoint).name {
            switch name {
            case "Back":
                backAction()
            case "Save":
                saveAction()
            case "Load":
                loadAction()
            case "Play":
                playAction()
            case "Reset":
                resetAction()
            case "Agent":
                updateCurrentItemSelected(.Agent, nodeName: name)
            case "Block":
                updateCurrentItemSelected(.EmptySpace, nodeName: name)
            case "Toilet":
                updateCurrentItemSelected(.Goal, nodeName: name)
            case "Wall":
                updateCurrentItemSelected(.Wall, nodeName: name)
            case "Hole":
                updateCurrentItemSelected(.Hole, nodeName: name)
            case "Wooden Block":
                updateCurrentItemSelected(.WoodenBlock, nodeName: name)
            case "Add Top", "Remove Top", "Add Bottom", "Remove Bottom",
                "Add Left", "Remove Left", "Add Right", "Remove Right":
                updateGrid(name)
            default:
                handleGesture(sender, mapUnitType: currentMapUnitTypeSelected)
            }
        } else {
            handleGesture(sender, mapUnitType: currentMapUnitTypeSelected)
        }
    }

    func handlePan(sender: UIPanGestureRecognizer) {
        handleGesture(sender, mapUnitType: currentMapUnitTypeSelected)
    }

    func handleLongPress(sender: UILongPressGestureRecognizer) {
        handleGesture(sender, mapUnitType: .EmptySpace)
    }
}

// This portion handles arrow tapping.
extension LevelDesigningMapScene {
    func addArrows() {
        let shiftLeft = DesigningMapConstants.Position.shiftLeft
        let shiftUp = DesigningMapConstants.Position.shiftUp
        let arrowOffsetX = CGFloat(DesigningMapConstants.Dimension.maxNumberOfColumns)
            * GlobalConstants.Dimension.blockWidth / 2
        let arrowOffsetY = CGFloat(DesigningMapConstants.Dimension.maxNumberOfRows)
            * GlobalConstants.Dimension.blockHeight / 2
        arrowSprites = [:]

        let upOffset = arrowOffsetY
        let downOffset = -arrowOffsetY - GlobalConstants.Dimension.blockHeight
        addArrow("up-arrow", name: "Add Top",
                 position: CGPoint(x: -GlobalConstants.Dimension.blockWidth + shiftLeft, y: upOffset + shiftUp))
        addArrow("down-arrow", name: "Remove Top",
                 position: CGPoint(x: shiftLeft, y: upOffset + shiftUp))
        addArrow("down-arrow", name: "Add Bottom",
                 position: CGPoint(x: -GlobalConstants.Dimension.blockWidth + shiftLeft, y: downOffset + shiftUp))
        addArrow("up-arrow", name: "Remove Bottom",
                 position: CGPoint(x: shiftLeft, y: downOffset + shiftUp))

        let rightOffset = arrowOffsetX
        let leftOffset = -arrowOffsetX - GlobalConstants.Dimension.blockWidth
        addArrow("left-arrow", name: "Add Left",
                 position: CGPoint(x: leftOffset + shiftLeft, y: -GlobalConstants.Dimension.blockHeight + shiftUp))
        addArrow("right-arrow", name: "Remove Left",
                 position: CGPoint(x: leftOffset + shiftLeft, y: shiftUp))
        addArrow("right-arrow", name: "Add Right",
                 position: CGPoint(x: rightOffset + shiftLeft, y: -GlobalConstants.Dimension.blockHeight + shiftUp))
        addArrow("left-arrow", name: "Remove Right",
                 position: CGPoint(x: rightOffset + shiftLeft, y: shiftUp))

        updateArrows()
    }

    func addArrow(imageNamed: String, name: String, position: CGPoint) {
        let arrow = SKSpriteNode(texture: TextureManager.retrieveTexture(imageNamed))
        arrow.name = name
        arrow.size = blockSize
        arrow.position = position
        addChild(arrow)
        arrowSprites[name] = arrow
    }

    func updateArrows() {
        for arrow in arrowSprites.values {
            presentArrow(arrow, toPresent: true)
        }
        if numberOfRows == DesigningMapConstants.Dimension.maxNumberOfRows {
            presentArrow(arrowSprites["Add Top"]!, toPresent: false)
            presentArrow(arrowSprites["Add Bottom"]!, toPresent: false)
        }
        if numberOfRows == DesigningMapConstants.Dimension.minNumberOfRows {
            presentArrow(arrowSprites["Remove Top"]!, toPresent: false)
            presentArrow(arrowSprites["Remove Bottom"]!, toPresent: false)
        }
        if numberOfColumns == DesigningMapConstants.Dimension.maxNumberOfColumns {
            presentArrow(arrowSprites["Add Left"]!, toPresent: false)
            presentArrow(arrowSprites["Add Right"]!, toPresent: false)
        }
        if numberOfColumns == DesigningMapConstants.Dimension.minNumberOfColumns {
            presentArrow(arrowSprites["Remove Left"]!, toPresent: false)
            presentArrow(arrowSprites["Remove Right"]!, toPresent: false)
        }
    }

    func presentArrow(arrow: SKSpriteNode, toPresent: Bool) {
        arrow.hidden = !toPresent
    }

    func updateGrid(action: String) {
        var rows = numberOfRows
        var columns = numberOfColumns
        let mapCopy = map.copy() as! Map

        let updateDirection = action.componentsSeparatedByString(" ")

        if updateDirection[1] == "Top" || updateDirection[1] == "Bottom" {
            rows = (updateDirection[0] == "Add") ? rows + 1 : rows - 1
        } else {
            columns = (updateDirection[0] == "Add") ? columns + 1 : columns - 1
        }

        removeBlocks(action)
        resetGrid(rows, columns: columns)
        setLayerPositions()

        var rowIterators = Array(0..<rows)
        var columnIterators = Array(0..<columns)
        if (updateDirection[1] == "Top" || updateDirection[1] == "Bottom")
            && updateDirection[0] == "Add" {
            rowIterators.removeLast()
        } else if (updateDirection[1] == "Left" || updateDirection[1] == "Right")
            && updateDirection[0] == "Add" {
            columnIterators.removeLast()
        }

        var retrieveRowShift = 0
        var retrieveColumnShift = 0
        var setRowShift = 0
        var setColumnShift = 0
        if updateDirection[1] == "Bottom" {
            if updateDirection[0] == "Add" {
                setRowShift = 1
            } else {
                retrieveRowShift = 1
            }
        } else if updateDirection[1] == "Left" {
            if updateDirection[0] == "Add" {
                setColumnShift = 1
            } else {
                retrieveColumnShift = 1
            }
        }

        for row in rowIterators {
            for column in columnIterators {
                let mapUnit = mapCopy.retrieveMapUnitAt(row + retrieveRowShift,
                    column: column + retrieveColumnShift)!
                map.setMapUnitAt(mapUnit, row: row + setRowShift,
                    column: column + setColumnShift)
            }
        }
        addBlocks()
        updateArrows()
    }

    func removeBlocks(action: String) {
        let updateDirection = action.componentsSeparatedByString(" ")
        if updateDirection[0] == "Remove" {
            var childrenToRemove = [SKSpriteNode]()
            for row in 0..<numberOfRows {
                for column in 0..<numberOfColumns {
                    let blockNode = grid[row][column]
                    blockNode.texture = nil
                    childrenToRemove.append(blockNode)
                }
            }
            removeChildrenInArray(childrenToRemove)
        }
    }

    func resetGrid(rows: Int, columns: Int) {
        // Reset model
        map = Map(numberOfRows: rows, numberOfColumns: columns)

        // Reset view's data structure
        grid = [[SKSpriteNode]](
            count: rows,
            repeatedValue: [SKSpriteNode](
                count: columns,
                repeatedValue: SKSpriteNode()
            )
        )
    }
}

// This portion handles the palette.
extension LevelDesigningMapScene {
    func addPalette() {
        let paletteBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        paletteNode = SKSpriteNode(color: paletteBackgroundColor,
                                   size: CGSize(width: 1024, height: 50))
        paletteLayer.addChild(paletteNode)

        let textures = [MapUnitType.Agent.texture,
                        MapUnitType.EmptySpace.texture,
                        MapUnitType.Goal.texture,
                        MapUnitType.Wall.texture,
                        MapUnitType.Hole.texture,
                        MapUnitType.WoodenBlock.texture
        ]
        let textureNames = ["Agent", "Block", "Toilet", "Wall", "Hole", "Wooden Block"]
        for position in 0..<textures.count {
            let spriteNode = SKSpriteNode(texture: textures[position])
            spriteNode.size = blockSize
            spriteNode.position = CGPoint(x: -1024/2 + 25 + 50 * CGFloat(position), y: 0)
            spriteNode.name = textureNames[position]
            paletteNode.addChild(spriteNode)
        }
    }

    func updateCurrentItemSelected(mapUnitType: MapUnitType, nodeName: String) {
        currentMapUnitTypeSelected = mapUnitType

        // Update View
        for node in paletteNode.children {
            if node.name == nodeName {
                node.alpha = 1
            } else {
                node.alpha = 0.3
            }
        }
    }
}

// This portion deals with actions such as Save, Load, Test Level and Reset.
extension LevelDesigningMapScene {
    func addActions() {
        addActionButton("back", name: "Back",
                        position: DesigningMapConstants.Position.backButton)
        addActionButton("save", name: "Save",
                        position: DesigningMapConstants.Position.saveButton)
        addActionButton("open-folder", name: "Load",
                        position: DesigningMapConstants.Position.loadButton)
        addActionButton("play", name: "Play",
                        position: DesigningMapConstants.Position.testLevelButton)
        addActionButton("reset", name: "Reset",
                        position: DesigningMapConstants.Position.resetButton)
    }

    func addActionButton(imageNamed: String, name: String, position: CGPoint) {
        let action = SKSpriteNode(texture: TextureManager.retrieveTexture(imageNamed))
        action.name = name
        action.size = CGSize(width: 60.0, height: 60.0)
        action.position = position
        addChild(action)
    }

    func backAction() {
        levelDesigningViewController?.goBack()
    }

    func playAction() {
        levelDesigningViewController?.performSegueWithIdentifier(
            GlobalConstants.SegueIdentifier.designToPlaying, sender: nil)
    }

    func saveAction() {
        var name: UITextField?
        var savedSuccessfully = false
        let maximumNumberOfCharacters = 30
        let saveAlert = UIAlertController(
            title: "Save",
            message: "Name this level!",
            preferredStyle: UIAlertControllerStyle.Alert)
        saveAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            name = textField
            name?.placeholder = "Enter name here"
        }
        saveAlert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { (action: UIAlertAction!) in
                if name!.text!.characters.count <= maximumNumberOfCharacters {
                    savedSuccessfully = GlobalConstants.filesArchive.saveToFile(
                        self.map,
                        name: name!.text!)
                }
                if savedSuccessfully {
                    let successAlert = UIAlertController(
                        title: "Saved!",
                        message: "You have successfully saved this level!",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    successAlert.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: nil))
                    self.levelDesigningViewController!.presentViewController(successAlert,
                        animated: true,
                        completion: nil)
                } else {
                    let failureAlert = UIAlertController(
                        title: "Failed",
                        message: "Failed to save this level.",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    failureAlert.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: nil))
                    self.levelDesigningViewController!.presentViewController(failureAlert,
                        animated: true,
                        completion: nil)
                }
        }))
        saveAlert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil))
        levelDesigningViewController!.presentViewController(
            saveAlert,
            animated: true,
            completion: nil)
    }

    func loadAction() {
        let levelSelectorPageViewController = LevelSelectorPageViewController()
        levelSelectorPageViewController.currentStoryboard = levelDesigningViewController!.storyboard
        levelSelectorPageViewController.previousViewController = levelDesigningViewController
        levelSelectorPageViewController.numberOfItemsPerPage = 15
        levelDesigningViewController!.presentViewController(
            levelSelectorPageViewController,
            animated: true,
            completion: nil)
    }

    func resetAction() {
        let resetAlert = UIAlertController(
            title: "Reset",
            message: "The board will be reset.",
            preferredStyle: UIAlertControllerStyle.Alert)
        resetAlert.addAction(UIAlertAction(
            title: "Ok",
            style: .Default,
            handler: { (action: UIAlertAction!) in
                self.resetMap(
                    Map(numberOfRows: DesigningMapConstants.Dimension.defaultNumberOfRows,
                        numberOfColumns: DesigningMapConstants.Dimension.defaultNumberOfColumns))
            }))
        resetAlert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil))
        levelDesigningViewController!.presentViewController(
            resetAlert,
            animated: true,
            completion: nil)
    }

    func resetMap(newMap: Map) {
        removeBlocks()
        map = newMap
        setLayerPositions()
        setGrid()
        addBlocks()
        updateArrows()
    }
}

extension LevelDesigningMapScene {
    func addBorders() {
        addBorder("Top")
        addBorder("Bottom")
        addBorder("Left")
        addBorder("Right")
    }

    func addBorder(edgeName: String) {
        let dottedLine = SKSpriteNode(texture: TextureManager.retrieveTexture("dotted-line"))
        dottedLine.zPosition = GlobalConstants.zPosition.back
        dottedLine.size = CGSize(width: CGFloat(DesigningMapConstants.Dimension.maxNumberOfColumns)
            * GlobalConstants.Dimension.blockWidth, height: dottedLine.size.height)

        if edgeName == "Left" || edgeName == "Right" {
            let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: NSTimeInterval(0))
            dottedLine.runAction(rotate)
        }

        var positionX = -GlobalConstants.Dimension.blockWidth/2 + DesigningMapConstants.Position.shiftLeft
        var positionY = -GlobalConstants.Dimension.blockHeight/2 + DesigningMapConstants.Position.shiftUp
        let offsetX = CGFloat(DesigningMapConstants.Dimension.maxNumberOfColumns)
            * GlobalConstants.Dimension.blockWidth / 2 - 20
        let offsetY = CGFloat(DesigningMapConstants.Dimension.maxNumberOfRows)
            * GlobalConstants.Dimension.blockHeight / 2 - 20
        switch edgeName {
        case "Top":
            positionY = offsetY + DesigningMapConstants.Position.shiftUp
        case "Bottom":
            positionY = -offsetY - GlobalConstants.Dimension.blockHeight + DesigningMapConstants.Position.shiftUp
        case "Left":
            positionX = -offsetX - GlobalConstants.Dimension.blockWidth + DesigningMapConstants.Position.shiftLeft
        case "Right":
            positionX = offsetX + DesigningMapConstants.Position.shiftLeft
        default:
            break
        }
        dottedLine.position = CGPoint(x: positionX, y: positionY)

        addChild(dottedLine)
    }
}
