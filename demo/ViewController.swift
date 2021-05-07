//
//  ViewController.swift
//  demo
//
//  Created by Farhana Khan on 05/05/21.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var CV: UICollectionView!
    var allData = [NSDictionary]()
    var realData = [NSDictionary]()
    var artistName = String()
    var searchData = String()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api()
    }
    func api()  {
        AF.request("https://itunes.apple.com/search?term=term&device_type=ios").responseJSON {(resp) in
            if let data = resp.value as? NSDictionary {
                self.allData = data.value(forKey: "results") as! [NSDictionary]
                self.realData = self.allData
                self.CV.reloadData()
            }
            else {
                print("error")
            }
        }
    }
    func getdata() {
        api()
        self.CV.reloadData()
    }
    func filterRecords() {
        
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
        searchText.count == 0 ? getdata() : filterRecords()
        self.CV.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as! CustomCVC
        cell.backgroundColor = UIColor.red
        cell.layer.cornerRadius = 15
        artistName = allData[indexPath.row].value(forKey: "artistName") as? String ?? ""
        cell.artistNameLB.text = artistName
        let collectionName = allData[indexPath.row].value(forKey: "collectionName") as? String ?? ""
        cell.collectionNameLb.text = collectionName
        let trackName = allData[indexPath.row].value(forKey: "trackName") as? String ?? ""
        cell.trackNameLB.text = trackName
        let imgg = allData[indexPath.row].value(forKey: "artworkUrl100") as? String ?? ""
        let url = URL(string: "\(imgg)")
        cell.imgV.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(Float(collectionView.frame.size.width/2))-4, height: 300)
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongVC") as! SongVC
        let imgg = allData[indexPath.row].value(forKey: "artworkUrl100") as! String
        let url = URL(string: imgg)!
        let data = try? Data(contentsOf: url)
        vc.img = UIImage(data: data!)!
        let artist = allData[indexPath.row].value(forKey: "artistName") as? String ?? ""
        vc.artistName = artist
        let trackName = allData[indexPath.row].value(forKey: "trackName") as? String ?? ""
        vc.trackName = trackName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
