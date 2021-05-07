//
//  SongVC.swift
//  demo
//
//  Created by Farhana Khan on 05/05/21.
//

import UIKit

class SongVC: UIViewController {

    @IBOutlet weak var trackNameLb: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var artistLb: UILabel!
    
    var trackName = ""
    var img = UIImage()
    var artistName = ""
    var abc = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackNameLb.text = trackName
        print("\(abc)")
        imgV.image = img
        artistLb.text = artistName
    }
}
