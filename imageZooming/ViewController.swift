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
    
    //使用UITapGestureRecognizer來雙擊畫面執行動作
    func doubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(update))
        //設定要點擊2次 , scrollView開啟互動 , scrollView增加手勢動作
        doubleTap.numberOfTapsRequired = 2
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    //控制pageControl來更變imageView
    @IBAction func tapPage(_ sender: UIPageControl) {
        let point = CGPoint(x: scrollView.bounds.width * CGFloat(sender.currentPage), y: 0)
        scrollView.setContentOffset(point, animated: true)
        //allowsContinuousInteraction 拖曳功能 預設為true
        pageControl.allowsContinuousInteraction = true
    }
}


//網路抓照片的功能
extension ViewController {
   @objc func update() {
    // 使用迴圈來連續載入五張不同的圖片
        for imageView in imageViews {
            let str = "https://picsum.photos/441/774" //隨機圖片網址
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
}
