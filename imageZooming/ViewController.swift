//
//  ViewController.swift
//  imageZooming
//
//  Created by Ryan Chang on 2021/4/20.
//

import UIKit

//先宣告UIScrollViewDelegate
class ViewController: UIViewController & UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var imageViews: [UIImageView]!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //載入圖片
        update()
        setNavigationbar()
        doubleTap()
        swipeDown()
        pageControl.layer.cornerRadius = pageControl.frame.height/2
    }
    

    
    //縮放
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for pageView in scrollView.subviews{
            if pageView.isKind(of: UIView.self){
                return pageView
            }
        }
        return nil
    }
    
    //設定navigationbar樣式
    func setNavigationbar(){
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem (image: UIImage(systemName: "photo.on.rectangle"), style: .done, target: self, action: #selector(update))
    }
    
}


    //手勢控制的extension
extension ViewController{
    //使用UITapGestureRecognizer來雙擊畫面執行動作
    func doubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(update))
        //設定要點擊2次 , scrollView開啟互動 , scrollView增加手勢動作
        doubleTap.numberOfTapsRequired = 2
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    //使用UITapGestureRecognizer來存圖片到內建相簿
    func swipeDown(){
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(saveimage))
            //滑動方下往下 , scrollView開啟互動 (跟double tap 重複,可以不用寫),scrollView增加手勢動作
            downSwipe.direction = .down
            scrollView.isUserInteractionEnabled = true
            scrollView.addGestureRecognizer(downSwipe)
    }

}



//網路抓照片的功能
extension ViewController {
   @objc func update() {
    // 使用迴圈來連續載入五張不同的圖片
        for imageView in imageViews {
            let str = "https://picsum.photos/455/774" //隨機圖片網址
            if let url = URL(string: str){
                URLSession.shared.dataTask(with: url){ (data , response ,error) in
                    if let data = data {
                        DispatchQueue.main.async {
                                imageView.image = UIImage(data: data)
                            print("update")
                        }
                    }
                }.resume()
            }
        }
    }
}


//把pageController 的function 用extension分出來寫
extension ViewController{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //讓pagePoint可以跟著分頁的改變而改變
        let page = scrollView.contentOffset.x/scrollView.bounds.width
        pageControl.currentPage = Int(page)
        print(scrollView.contentOffset.x)
    }
    //控制pageControl來更變imageView
    @IBAction func tapPage(_ sender: UIPageControl) {
        let point = CGPoint(x: scrollView.bounds.width * CGFloat(sender.currentPage), y: 0)
        scrollView.setContentOffset(point, animated: true)
        //allowsContinuousInteraction 拖曳功能 預設為true
        pageControl.allowsContinuousInteraction = true
    }
}


extension ViewController{
    @objc func saveimage(){
        //抓取滑動畫面的時候的Ｘ位置，除於imageview寬，在使用UIGraphicsImageRenderer存圖片到相簿裡
        let i = Int(scrollView.contentOffset.x / 390)
        let renderer = UIGraphicsImageRenderer(size: imageViews[i].bounds.size)
        let image = renderer.image(actions: { (context) in
            imageViews[i].drawHierarchy(in: imageViews[i].bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
