//
//  ViewController.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

let albumsCellId: String = "AlbumCollectionCell"

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout {
    fileprivate lazy var searchVM: SearchAlbumVM = SearchAlbumVM()
    
    // long press (0.5) second can save to photos or add to colletion list.
    fileprivate lazy var longPressGes: UILongPressGestureRecognizer = {
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.saveAlbum(_:)))
        longPressGes.minimumPressDuration = 0.5
        return longPressGes
    }()
    
    @IBOutlet weak var collectionViewBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        searchVM.requestData(keywords: "hulu") {
            self.collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
}

// MARK: - setupUI
extension ViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: albumsCellId, bundle: nil), forCellWithReuseIdentifier: albumsCellId)
        collectionView.addGestureRecognizer(longPressGes)
    }
}


// MARK: - keyboard events
extension ViewController {
    func onKeyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = keyBoardBounds.size.height
        self.collectionViewBottomConstrain.constant = deltaY;
        UIView.animate(withDuration: 0.3, animations: {
            self.view.setNeedsLayout()
        })
    }
    
    func onKeyboardWillHide(note: NSNotification) {
        self.collectionViewBottomConstrain.constant = 0;
        UIView.animate(withDuration: 0.3, animations: {
            self.view.setNeedsLayout()
        })
    }
}

// MARK: - search bar
extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("[ViewController searchBar] searchText: \(searchText)")
        // when it is empty then search "Hulu"
        if searchText == "" {
            searchVM.albumGroup.removeAll()
            self.collectionView.reloadData()
        } else {
            searchVM.albumGroup.removeAll()
            searchVM.requestData(keywords: searchText) {
                self.collectionView.reloadData()
            }
        }
    }
}


// MARK: - delegate & dataSource
extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchVM.albumGroup.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumsCellId, for: indexPath) as! AlbumCollectionCell
        cell.album = searchVM.albumGroup[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2+30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        searchBar.resignFirstResponder()
    }
}

// MARK: -saveAlbum
extension ViewController {
    func saveAlbum(_ gesature: UIGestureRecognizer) {
        if longPressGes.state == .began {
            self.becomeFirstResponder()
            let point: CGPoint = gesature.location(in: collectionView)
            let indexPath: IndexPath = collectionView.indexPathForItem(at: point)!
            let albumData = searchVM.albumGroup[indexPath.item]
            
            
            let alertController = UIAlertController(title: "add to collections", message: nil, preferredStyle: .actionSheet)
            
            let addFavoritesButton = UIAlertAction(title: "Add to favorites", style: .default, handler: { (action) -> Void in
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let item = Album(context: context) // Link Task & Context
                item.name = albumData.name
                let imageUrls: Data = NSKeyedArchiver.archivedData(withRootObject: albumData.images!)
                item.imageUrls = imageUrls as NSData?
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                // fetch data from core data
//                let request: NSFetchRequest<Album> = Album.fetchRequest()
                
            })
            
            let addToPhotosButton = UIAlertAction(title: "Add to photos library", style: .default, handler: { (action) -> Void in
                
                let cell:AlbumCollectionCell = self.collectionView!.cellForItem(at: indexPath) as! AlbumCollectionCell
                UIImageWriteToSavedPhotosAlbum(cell.coverImageView.image!, self, #selector(ViewController.savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
            })

            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            alertController.addAction(addToPhotosButton)
            alertController.addAction(addFavoritesButton)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            // Save Success
        } else {
            // Save Failed
        }
    }

}


