//
//  PhotoCell.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeActionLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var likeTappedAction: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadingIndicator.stopAnimating()
        likeActionLabel.isHidden = false
        thumbnail.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  
    
}
extension PhotoCell {
    private func setup() {
        thumbnail.layer.cornerRadius = 8
        
        userNameLabel.font = .boldSystemFont(ofSize: 16)
        
        likeActionLabel.font = .systemFont(ofSize: 14)
        likeActionLabel.textColor = .green
        
        likesCountLabel.font = .systemFont(ofSize: 14)
        likesCountLabel.textColor = .lightGray
        
        setupGesture()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeActionLabel.addGestureRecognizer(tapGesture)
        likeActionLabel.isUserInteractionEnabled = true
    }
    
    @objc private func likeTapped() {
        likeActionLabel.isHidden = true
        loadingIndicator.startAnimating()
        likeTappedAction?()
    }
    
    func configure(_ photo: ZAPhoto, likeTappedAction: (() -> Void)? = nil) {
        self.likeTappedAction = likeTappedAction
        if let imageUrl = photo.urls?.thumb {
            // Load image
            ImageHelper.downloadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.thumbnail.image = image
                }
            }
        }
        
        if let user = photo.user {
            // Display username
            userNameLabel.text = user.name
        }
        
        likesCountLabel.text = "\(photo.likes ?? 0) likes"
        
        likeActionLabel.text = (photo.likedByUser ?? false) ? "Unlike" : "Like"
    }
}
