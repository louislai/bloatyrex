//
//  LevelDesigningMapScene.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 14/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit
import Darwin

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
    let blockWidth = CGFloat(40.0)
    let blockHeight = CGFloat(40.0)
    var blockSize: CGSize {
        return CGSize(
            width: blockWidth,
            height: blockHeight
        )
    }
    var grid: [[SKSpriteNode]]!
    var paletteNode: SKSpriteNode!
    var currentMapUnitSelected = MapUnit.EmptySpace
    var arrowSprites: [String: SKSpriteNode]!
    let minNumberOfRows = 1
    let maxNumberOfRows = 8
    let minNumberOfColumns = 1
    let maxNumberOfColumns = 8
    let filesArchive = FilesArchive()

    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
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

        let palettePosition = CGPoint(x: 0, y: -768/2 + 20 + 45)
        paletteLayer.position = palettePosition
        addChild(paletteLayer)

        // actionsLayer shows the actions that user can do, such as
        // Save, Load, Play, Reset.
        let actionsPosition = CGPoint(x: 0, y: -768/2 + 20)
        actionsLayer.position = actionsPosition
        addChild(actionsLayer)

        addArrows()
        addPalette()
        addActions()
        addBlocks()
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
            x: -blockWidth * CGFloat(numberOfColumns) / 2,
            y: -blockHeight * CGFloat(numberOfRows) / 2
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
                let mapUnit = map.retrieveMapUnitAt(row, column: column)!
                setBlock(mapUnit, row: row, column: column)
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
    func setBlock(mapUnit: MapUnit, row: Int, column: Int) {
        // Update model
        map.setMapUnitAt(mapUnit, row: row, column: column)

        // Update view
        let blockNode = getBlockNode(mapUnit)
        blockNode.size = blockSize
        blockNode.position = pointFor(row, column: column)
        grid[row][column] = blockNode
        let node = blocksLayer.nodeAtPoint(pointFor(row, column: column))
        blocksLayer.removeChildrenInArray([node])
        blocksLayer.addChild(blockNode)

        // Checker
        printGrid()
    }

    func getBlockNode(mapUnit: MapUnit) -> SKSpriteNode {
        switch mapUnit {
        case .Agent:
            return SKSpriteNode(texture: TextureManager.agentUpTexture)
        case .EmptySpace:
            return SKSpriteNode(texture: TextureManager.retrieveTexture("Block"))
        case .Goal:
            return SKSpriteNode(texture: TextureManager.retrieveTexture("toilet"))
        case .Wall:
            return SKSpriteNode(texture: TextureManager.retrieveTexture("wall"))
        }
    }

    // Convert a row, column pair into a CGPoint relative to unitsLayer
    func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * blockWidth,
            y: CGFloat(row) * blockHeight
        )
    }

    // Convert a CGPoint relative to unitsLayer to a row number
    func rowFor(point: CGPoint) -> Int {
        return Int(floor(point.y/blockHeight + (CGFloat(numberOfRows) + 1)/2))
    }

    // Convert a CGPoint relative to unitsLayer to a column number
    func columnFor(point: CGPoint) -> Int {
        return Int(floor(point.x/blockWidth + (CGFloat(numberOfColumns) + 1)/2))
    }

    // Checks if the row and column number is valid
    func isValidRowAndColumn(row: Int, column: Int) -> Bool {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }

    // Prints the grid for checking purposes
    func printGrid() {
        for row in (0..<map.numberOfRows).reverse() {
            var string = ""
            for column in 0..<map.numberOfColumns {
                string += String(map.retrieveMapUnitAt(row, column: column)!.rawValue) + " "
            }
            print(string)
        }
        print("=====")
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

    func handleGesture(sender: UIGestureRecognizer, mapUnit: MapUnit) {
        let viewPoint = sender.locationInView(view)
        let scenePoint = convertPointFromView(viewPoint)
        let row = rowFor(scenePoint)
        let column = columnFor(scenePoint)
        if isValidRowAndColumn(row, column: column) {
            setBlock(mapUnit, row: row, column: column)
        }
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let viewPoint = sender.locationInView(view)
        let scenePoint = convertPointFromView(viewPoint)
        if let name = nodeAtPoint(scenePoint).name {
            switch name {
            case "Save":
                saveAction()
            case "Load":
                loadAction()
            case "Test Level":
                testLevel()
            case "Reset":
                resetAction()
            case "Agent":
                updateCurrentItemSelected(MapUnit.Agent, nodeName: name)
            case "Block":
                updateCurrentItemSelected(MapUnit.EmptySpace, nodeName: name)
            case "Toilet":
                updateCurrentItemSelected(MapUnit.Goal, nodeName: name)
            case "Wall":
                updateCurrentItemSelected(MapUnit.Wall, nodeName: name)
            case "Add Top", "Remove Top", "Add Bottom", "Remove Bottom",
                "Add Left", "Remove Left", "Add Right", "Remove Right":
                updateGrid(name)
            default:
                handleGesture(sender, mapUnit: currentMapUnitSelected)
            }
        } else {
            handleGesture(sender, mapUnit: currentMapUnitSelected)
        }
    }

    func handlePan(sender: UIPanGestureRecognizer) {
        handleGesture(sender, mapUnit: currentMapUnitSelected)
    }

    func handleLongPress(sender: UILongPressGestureRecognizer) {
        handleGesture(sender, mapUnit: MapUnit.EmptySpace)
    }
}

// This portion handles arrow tapping.
extension LevelDesigningMapScene {
    func addArrows() {
        let arrowOffsetX = CGFloat(maxNumberOfRows - numberOfRows) * blockWidth / 2
        let arrowOffsetY = CGFloat(maxNumberOfColumns - numberOfColumns) * blockHeight / 2
        arrowSprites = [:]

        let verticalOffset = blockHeight * CGFloat(numberOfRows) / 2
        let upOffset = verticalOffset + arrowOffsetY
        let downOffset = -upOffset - blockHeight
        addArrow("up-arrow", name: "Add Top", position: CGPoint(x: -blockWidth, y: upOffset))
        addArrow("down-arrow", name: "Remove Top", position: CGPoint(x: 0, y: upOffset))
        addArrow("down-arrow", name: "Add Bottom", position: CGPoint(x: -blockWidth, y: downOffset))
        addArrow("up-arrow", name: "Remove Bottom", position: CGPoint(x: 0, y: downOffset))

        let horizontalOffset = blockWidth * CGFloat(numberOfColumns) / 2
        let rightOffset = horizontalOffset + arrowOffsetX
        let leftOffset = -rightOffset - blockWidth
        addArrow("left-arrow", name: "Add Left", position: CGPoint(x: leftOffset, y: -blockHeight))
        addArrow("right-arrow", name: "Remove Left", position: CGPoint(x: leftOffset, y: 0))
        addArrow("right-arrow", name: "Add Right", position: CGPoint(x: rightOffset, y: -blockHeight))
        addArrow("left-arrow", name: "Remove Right", position: CGPoint(x: rightOffset, y: 0))

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
        if numberOfRows == maxNumberOfRows {
            presentArrow(arrowSprites["Add Top"]!, toPresent: false)
            presentArrow(arrowSprites["Add Bottom"]!, toPresent: false)
        }
        if numberOfRows == minNumberOfRows {
            presentArrow(arrowSprites["Remove Top"]!, toPresent: false)
            presentArrow(arrowSprites["Remove Bottom"]!, toPresent: false)
        }
        if numberOfColumns == maxNumberOfColumns {
            presentArrow(arrowSprites["Add Left"]!, toPresent: false)
            presentArrow(arrowSprites["Add Right"]!, toPresent: false)
        }
        if numberOfColumns == minNumberOfColumns {
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
        paletteNode = SKSpriteNode(color: paletteBackgroundColor, size: CGSize(width: 1024, height: 50))
        paletteLayer.addChild(paletteNode)

        let textures = [TextureManager.agentUpTexture,
                        TextureManager.retrieveTexture("Block"),
                        TextureManager.retrieveTexture("toilet"),
                        TextureManager.retrieveTexture("wall")]
        let textureNames = ["Agent", "Block", "Toilet", "Wall"]
        for position in 0..<textures.count {
            let spriteNode = SKSpriteNode(texture: textures[position])
            spriteNode.size = blockSize
            spriteNode.position = CGPoint(x: -1024/2 + 25 + 50 * CGFloat(position), y: 0)
            spriteNode.name = textureNames[position]
            paletteNode.addChild(spriteNode)
        }
    }

    func updateCurrentItemSelected(mapUnit: MapUnit, nodeName: String) {
        currentMapUnitSelected = mapUnit

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
        let actionsNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 1024, height: 40))
        actionsLayer.addChild(actionsNode)

        let saveLabel = makeLabel("Save", position: CGPoint(x: -1024/2 + 30, y: 0))
        actionsNode.addChild(saveLabel)

        let loadLabel = makeLabel("Load", position: CGPoint(x: -1024/2 + 80, y: 0))
        actionsNode.addChild(loadLabel)

        let testLevelLabel = makeLabel("Test Level", position: CGPoint(x: 0, y: 0))
        actionsNode.addChild(testLevelLabel)

        let resetLabel = makeLabel("Reset", position: CGPoint(x: 1024/2 - 30, y: 0))
        actionsNode.addChild(resetLabel)
    }

    // A wrapper to make SKLabelNode based on given label name and position
    func makeLabel(labelName: String, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(text: labelName)
        label.fontColor = UIColor.whiteColor()
        label.fontName = "Arial"
        label.fontSize = 17
        label.position = position
        label.name = labelName
        return label
    }

    func testLevel() {
        levelDesigningViewController?.performSegueWithIdentifier(GlobalConstants.SegueIdentifier.designToPlaying, sender: nil)
    }

    func saveAction() {
        var name: UITextField?
        var savedSuccessfully = false
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
                if name!.text!.characters.count <= 30 {
                    savedSuccessfully = self.filesArchive.saveToPropertyList(self.map, name: name!.text!)
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
        levelSelectorPageViewController.totalNumberOfPages = Int(ceil(Double(
            levelSelectorPageViewController.totalNumberOfItems) /
            Double(levelSelectorPageViewController.numberOfItemsPerPage!)))
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
                self.resetMap(Map(numberOfRows: 6, numberOfColumns: 6))
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
