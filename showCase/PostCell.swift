//
//  PostCell.swift
//  showCase
//
//  Created by 蔡智斌 on 16/6/7.
//  Copyright © 2016年 NeoChoi. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class PostCell: UITableViewCell {
    

    
    private var _post: Post?
    
    var post: Post! {
        return _post
    }
    var likeRef: Firebase!
    var request: Request? //belone to Alamofire
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText:UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        showcaseImg.clipsToBounds = true
        
    }
    
    func configureCell(post: Post,img: UIImage?){
        self._post = post
        self.showcaseImg.image = nil
        self.likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postkey)

        
//        self.descriptionText.text = post.postDescription
        if let desc = post.postDescription where post.postDescription != "" {
            self.descriptionText.text = desc
        } else {
            self.descriptionText.hidden = true
        }

            
        
        self.likesLbl.text = "\(post.likes)"//每个cell按照相应的firebase单元显示like
        
        if post.imageUrl != nil{
            
            if img != nil{
                self.showcaseImg.image = img
            }else{
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    if err == nil{
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                
                })
            }
            
        }else{
            self.showcaseImg.hidden = true
}
       
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart-empty")
            } else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
        
    }
    func likeTapped(sender: UITapGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if let doesNotExist = snapshot.value as? NSNull{
                //This means we have not liked this specific post
                self.likeRef.setValue(true)
                self.likeImage.image = UIImage(named: "heart-full")
                self.post!.adjustLikes(true)
                
            }else{
                
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post!.adjustLikes(false)
                self.likeRef.removeValue() //只能保持full（如果已经空点击变full，再点击还是full）
                
            }
//            self.likesLbl.text = "\(self.post!.likes)"//删除无影响
          
        })

        
    }
    

    
}
