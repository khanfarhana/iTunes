//
//  ViewController.swift
//  demo
//
//  Created by Farhana Khan on 05/05/21.
//

import UIKit
import Alamofire
import Kingfisher
import Lottie
import AVKit

class ViewController: UIViewController,UISearchBarDelegate {
    var player = AVPlayer()
    
    @IBOutlet weak var actIn: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var CV: UICollectionView!
    var animationV = AnimationView()
    var allData = [NSDictionary]()
    var realData = [NSDictionary]()
    var artistName = String()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIn.hidesWhenStopped = true
        if searchBar.text?.count == 0{        AF.request("https://itunes.apple.com/search?term=term&device_type=ios").responseJSON {(resp) in
            if let data = resp.value as? NSDictionary {
                self.actIn.stopAnimating()
                self.allData = data.value(forKey: "results") as! [NSDictionary]
                self.CV.reloadData()
            }
            else {
                print("error")
            }
        }
        searchApi()
        }
    }
    
    func searchApi()  {
        guard let searchTxt = searchBar.text , searchTxt.count > 0 else {
            //            self.allData.removeAll()
            self.CV.reloadData()
            return
        }
        
        AF.request("https://itunes.apple.com/search?term=\(searchTxt)&device_type=ios").responseJSON {(resp) in
            if let data = resp.value as? NSDictionary {
                self.actIn.stopAnimating()
                self.allData = data.value(forKey: "results") as! [NSDictionary]
                self.CV.reloadData()
            }
            else {
                //                print("error")
            }
        }
    }
    
    func filterRecords() {
        let foundItems = self.realData.filter { (dict) -> Bool in
            if let val = dict.value(forKey: "artistName") as? String{
                return val.contains(searchBar.text!)
            }
            return false
        }
        print("Found count \(foundItems.count)")
    }
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchApi()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as! CustomCVC
        cell.backgroundColor = UIColor.purple
        cell.layer.cornerRadius = 15
        artistName = allData[indexPath.row].value(forKey: "artistName") as? String ?? "Empty"
        cell.artistNameLB.text = "Artist: \(artistName)"
        let collectionName = allData[indexPath.row].value(forKey: "collectionName") as? String ?? "Empty"
        cell.collectionNameLb.text = "Collection: \(collectionName)"
        let trackName = allData[indexPath.row].value(forKey: "trackName") as? String ?? "Empty"
        cell.trackNameLB.text = "Track: \(trackName)"
        let imgg = allData[indexPath.row].value(forKey: "artworkUrl100") as? String ?? "Empty"
        let url = URL(string: "\(imgg)")
        cell.imgV.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(Float(collectionView.frame.size.width/2))-4, height: 330)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let  previewUrl = allData[indexPath.row].value(forKey: "previewUrl") as? String ?? ""
        print(previewUrl)
        player = AVPlayer(url: URL(string: "\(previewUrl)")!)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        player.play()
        present(playerVC, animated: true, completion: nil)
    }
}
