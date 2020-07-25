//
//  InfiniteLoopContentView.swift
//  InfiniteLoopDemo
//
//  Created by yaojinhai on 2020/7/25.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import UIKit

protocol InfiniteLoopContentViewDelegate: NSObjectProtocol {
    
    func infiniteLoopView(loopView: InfiniteLoopContentView,index: Int) -> UICollectionViewCell;
     func numberCountOfRows(loopView: InfiniteLoopContentView) -> Int;
     func infiniteLoopView(loopView: InfiniteLoopContentView,didSelectedIndexPath index: Int);
     
    func didEndScrollView(loopView: InfiniteLoopContentView) -> Void
}

extension InfiniteLoopContentViewDelegate {
    
    func didEndScrollView(loopView: InfiniteLoopContentView) {
        
    }
}

class InfiniteLoopContentView: UICollectionView {

    private var perContentSize: CGFloat {
        return contentSize.width / 3;
    }
    
    weak var infiniteDelegate: InfiniteLoopContentViewDelegate!
    
    private var perCount = 0;
    
    private var isAutoScroll = false;
    
    private let runDiration: Double = 3.2;
    
    weak fileprivate var pageControl: UIPageControl!
    
    var beginTimer = true {
        didSet{
            runTimer();
        }
    }
    
    private var width: CGFloat {
        frame.width
    }
    private var height: CGFloat {
        frame.height
    }
    
    private func runTimer() -> Void {
        if beginTimer {
            NSObject.cancelPreviousPerformRequests(withTarget: self);
            perform(#selector(runTimerAction), with: nil, afterDelay: runDiration);
        }else {
            NSObject.cancelPreviousPerformRequests(withTarget: self);
            isAutoScroll = false;
        }
    }
    
    

    @objc func runTimerAction() -> Void {
        if perCount <= 1 || contentSize.width < self.width {
            return;
        }
        let offsetx = contentOffset.x;
        guard let indexPath = indexPathForItem(at: .init(x: offsetx + width/2, y: height/2)) else{
            return;
        }
        isAutoScroll = true;
        var next = indexPath.row + 1;
        if next >= (perCount * 3 - 1) {
            next = perCount * 3 - 1;
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.scrollToItem(at: .init(row: next, section: 0), at: .centeredHorizontally, animated: false);
            }) { (finished) in
                self.pageControl?.currentPage = self.perCount - 1;
                self.contentOffset = .init(x: (self.perCount - 1) * Int(self.width), y: 0);
            }
            
        }else{
            scrollToItem(at: .init(row: next, section: 0), at: .centeredHorizontally, animated: true);
            pageControl?.currentPage = next % perCount;
        }
        perform(#selector(runTimerAction), with: nil, afterDelay: runDiration);

    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout);
        if let subLayout = layout as? UICollectionViewFlowLayout {
            subLayout.scrollDirection = .horizontal;
            subLayout.minimumLineSpacing = 0;
            subLayout.minimumInteritemSpacing = 0;
            subLayout.itemSize = .init(width: width, height: height);
        }
        showsHorizontalScrollIndicator = false;
        showsVerticalScrollIndicator = false;
        isPagingEnabled = true;
        delegate = self;
        dataSource = self;
        backgroundColor = UIColor.systemBackground;
        
        runTimer();
    }
    
    deinit {
        infiniteDelegate = nil;
        beginTimer = false;
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        if perCount <= 1 || isAutoScroll {
            return;
        }
        
        if contentSize.width < self.width {
            return;
        }
        
        
        let contentOffset = self.contentOffset;
        
        if contentOffset.x >= (perContentSize * 2) {
            let offset = contentOffset.x - (perContentSize * 2);
            self.contentOffset = .init(x: perContentSize + offset, y: 0);
        }else if contentOffset.x < perContentSize {
            let offset = Int(contentOffset.x) % Int(perContentSize); 
            self.contentOffset = .init(x: perContentSize + CGFloat(offset), y: 0);
        }
        pageControl?.currentPage = Int((contentOffset.x + width/2) / width) % perCount;

        
    }
}

extension InfiniteLoopContentView: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    // MARK: - collection view delegate and dataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        perCount = infiniteDelegate?.numberCountOfRows(loopView: self) ?? 0
        if perCount == 1 {
            return perCount;
        }
        return perCount * 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return infiniteDelegate.infiniteLoopView(loopView: self, index: indexPath.row % perCount);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate.infiniteLoopView(loopView: self, didSelectedIndexPath: indexPath.row % perCount);
    }

}

extension InfiniteLoopContentView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginTimer = false;
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        beginTimer = true;
        infiniteDelegate?.didEndScrollView(loopView: self);
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView);
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView);
    }
}
