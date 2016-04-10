//
//  CodeBlocksViewController.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class CodeBlocksViewController: UIViewController {

    var scene: CodeBlocksScene!
    var programBlocksToLoad: ProgramBlocks?
    var editEnabled: Bool!

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        scene = CodeBlocksScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.editEnabled = editEnabled
        skView.presentScene(scene)

        if let programBlocksToLoad = programBlocksToLoad {
            scene.setProgramBlocks(programBlocksToLoad)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CodeBlocksViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return scene.retrieveProgram()
    }
}

extension CodeBlocksViewController: ProgramBlocksSupplier {
    func retrieveProgramBlocks() -> ProgramBlocks {
        return scene.getProgramBlocks()
    }
}
