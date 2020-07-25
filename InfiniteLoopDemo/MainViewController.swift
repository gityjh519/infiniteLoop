//
//  MainViewController.swift
//  InfiniteLoopDemo
//
//  Created by yaojinhai on 2020/7/25.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    var loopView: InfiniteLoopContentView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let layout = UICollectionViewFlowLayout();
        loopView = InfiniteLoopContentView(frame: .init(x: 0, y: 200, width: view.frame.width, height: 200), collectionViewLayout: layout);
        view.addSubview(loopView);
        loopView.infiniteDelegate = self;
        loopView.register(LoopViewCell.self, forCellWithReuseIdentifier: "cell");
        loopView.reloadData();
    }
    


}

extension MainViewController: InfiniteLoopContentViewDelegate{
    func infiniteLoopView(loopView: InfiniteLoopContentView, index: Int) -> UICollectionViewCell {
        let cell = loopView.dequeueReusableCell(withReuseIdentifier: "cell", for: .init(row: index, section: 0)) as! LoopViewCell;
        cell.imageView.image = UIImage(named: (index + 1).description);
        
        return cell;
    }
    
    func numberCountOfRows(loopView: InfiniteLoopContentView) -> Int {
        return 3;
    }
    
    func infiniteLoopView(loopView: InfiniteLoopContentView, didSelectedIndexPath index: Int) {
        
    }
    
    
}


class LoopViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame);
        imageView = UIImageView(frame: bounds);
        imageView.contentMode = .scaleAspectFit;
        addSubview(imageView);
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
