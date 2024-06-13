//
//  AddDetailsVC.swift
//  Acme Vendor App
//
//  Created by acme on 13/06/24.
//

import UIKit

class AddDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwAddOptions: UICollectionView!
    //MARK: - Variables
    var arrOptions = ["Add Van", "Add Driver", "Add Helper", "Add Supervisor"]
    typealias tag = (_ tag: Int) -> Void
    var tagDelegate: tag? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}

extension AddDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCVC", for: indexPath) as! OptionsCVC
        cell.lblTitle.text = arrOptions[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collVwAddOptions.frame.size.width/2, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            guard let tagDelegate = self.tagDelegate else { return }
            tagDelegate(indexPath.row)
        }
    }
}
