//
//  Cell.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 31/10/23.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        thumbImage.layer.cornerRadius = 8
        thumbImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with urlString: String){
        guard let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.thumbImage.image = image
            }
        }
        task.resume()
    }
    
}
