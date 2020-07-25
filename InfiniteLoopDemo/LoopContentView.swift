//
//  LoopContentView.swift
//  InfiniteLoopDemo
//
//  Created by yaojinhai on 2020/7/25.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

class LoopContentView: UIView {
    
    private var pageControl: UIPageControl!
    
    var contentView: InfiniteLoopContentView!
    
    private var numberOfCount = 0;
    
    var isShowPageIndicator = true {
        didSet{
            pageControl.isHidden = !isShowPageIndicator;
        }
    }
    
    
    weak var delegate: InfiniteLoopContentViewDelegate! {
        didSet{
            contentView.infiniteDelegate = delegate
        }
    }
    
    var beginTimer = true {
        didSet{
            contentView?.beginTimer = beginTimer
        }
    }
    
    private var width: CGFloat {
        frame.width
    }
    private var height: CGFloat {
        frame.height
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout();
        contentView = InfiniteLoopContentView(frame: bounds, collectionViewLayout: layout);
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        addSubview(contentView);
        
//        configPageControl();
//        contentView.pageControl = pageControl;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func register(_ cellClass: AnyClass?,forCellWithReuseIdentifier: String) {
        contentView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier);
    }
    
    
    private func configPageControl()  {
        pageControl = UIPageControl(frame: .init(x: 0, y: 0, width: 40, height: 37));
        pageControl.pageIndicatorTintColor = UIColor.lightGray;
        pageControl.hidesForSinglePage = true;
        addSubview(pageControl);
    }
    
    func reloadData() {
        contentView.reloadData();
        numberOfCount = contentView.numberOfItems(inSection: 0)/3;
        pageControl.currentPage = 0;
        pageControl.numberOfPages = numberOfCount;
        beginTimer = numberOfCount > 0;
        setNeedsLayout();
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews();
        
        if numberOfCount < 1 {
            return;
        }
        let pSize = pageControl.size(forNumberOfPages: numberOfCount);
        pageControl.frame = .init(x: width - pSize.width, y: height - pSize.height, width: pSize.width - 10, height: pSize.height);
        
    }
    deinit {
        delegate = nil;
    }
    
}
