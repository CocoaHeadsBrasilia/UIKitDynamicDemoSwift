//
//  ViewController.swift
//  UIKitDynamicDemoSwift
//
//  Created by Gazolla on 07/02/15.
//  Copyright (c) 2015 Gazolla. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    /*
    * Cria um objeto da classe UIView, pinta de azul e adiciona na view deste ViewController
    */
    lazy var square:UIView = {
        var v = UIView (frame: CGRectMake(20, 20, 40, 40))
        v.backgroundColor = UIColor.blueColor()
        self.view.addSubview(v)
        return v
    }()
    
    /*
    * Cria um objeto da classe UIView, pinta de cinza. Esta será nossa View com a densidade grande.
    */
    lazy var block:UIView = {
        var b = UIView (frame: CGRectMake(100, 100, 150, 150))
        b.backgroundColor = UIColor.grayColor()
        self.view.addSubview(b)
        return b
    }()
    
    /*
    * Instancia um objeto UIDymanicAnimator e define a view de referência
    * como a View  deste UIViewController
    */
    lazy var animator:UIDynamicAnimator = {
        var a = UIDynamicAnimator (referenceView: self.view)
        return a
    }()
    
    /*
    * Instancia um comportamento de gravidade
    */
    lazy var gravity:UIGravityBehavior = {
        var g = UIGravityBehavior()
        self.animator.addBehavior(g)
        return g
    }()
    
    /*
    * Instancia um comportamento configurável e defini a
    * densidade (teoricamente quantidade de massa por unidade de volume) com 1000 unidade
    * o padrão (default) é 1 unidade.
    */
    lazy var blockBehavior:UIDynamicItemBehavior = {
        var bb = UIDynamicItemBehavior()
        bb.density = 1000
        self.animator.addBehavior(bb)
        return bb
    }()
    
    /*
    * Instancia um comportamento de colisão e define
    * as bordas da view do controlador como barreiras.
    */
    lazy var collider:UICollisionBehavior = {
        var c = UICollisionBehavior()
        c.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(c)
        return c
    }()
    
    /*
    * Instancia um objeto de NSOperationQueue.
    */
    lazy var motionQueue:NSOperationQueue = {
       var oq = NSOperationQueue()
       return oq
    }()
    
    /*
    * Instancia um objeto de CMMotionManager.
    */
    lazy var motionManager:CMMotionManager = {
        var mm = CMMotionManager()
        return mm
    }()

    func startGravity(){
        
        self.collider.addItem(self.block)
        self.blockBehavior.addItem(self.block) // <== comente esse para ver um evento bem interessante.
   //   self.gravity.addItem(self.block)  <== Para ver o pequeno bloco azul ser esmagado pelo cinza descomente essa linha
        self.gravity.addItem(self.square)
        self.collider.addItem(self.square)
        
        self.motionManager.startDeviceMotionUpdatesToQueue(self.motionQueue, withHandler: { (motion:CMDeviceMotion!, error:NSError!) -> Void in
            // captura os movimentos gerados pelo acelerômetro.
            var gravity:CMAcceleration = motion.gravity
            // Cria um bloco assincrono para atualizar a thread principal (que manipula a interface gráfica)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 //Atualiza o nosso comportamento de gravidade a partir dos dados gerados pelo acelerômetro.
                self.gravity.gravityDirection = CGVectorMake(CGFloat(gravity.x), CGFloat(-gravity.y))
            })
            
        })
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startGravity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

