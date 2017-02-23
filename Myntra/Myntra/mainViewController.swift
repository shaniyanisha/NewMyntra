//
//  ViewController.swift
//  Myntra
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class mainViewController: UIViewController {
    
    //MARK: variables
    var favouriteIteamsArray = [[IndexPath]]() //2D aaray  of indexpath
    var rowsToHide = [IndexPath]() // empty array of indexpath
    var sectionShowToHide = [Int]() //empty array having  number of sections (Interger)
    var picturesDataList = [[[ImageInformationModel]]]() //3Dimentional array
    var iteamslist = [[IndexPath]]() //
    var categories = ["CATS","DOGS","BIRDS"] //array for storing section
    
    
    // Mark : Outlets
    @IBOutlet weak var categorieTableView: UITableView!
    @IBOutlet weak var favIteamslistBtn: UIButton!
    
    
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        
             super.viewDidLoad()
        
             // Register the tableview cell.
             let tableViewCellObject = UINib(nibName:"TableViewCell", bundle: nil)
             categorieTableView.register(tableViewCellObject , forCellReuseIdentifier: "TableViewCellID")
        
             // Register the header cell.
             let headerObject = UINib(nibName:"HeaderViewCell", bundle: nil)
             categorieTableView.register( headerObject, forHeaderFooterViewReuseIdentifier: "HeaderViewCellID")
        
             // call TableView DataSource and Delegate.
             categorieTableView.delegate = self
             categorieTableView.dataSource = self
        
             FetchDataFromWebService()
        
        }
    //this functiopn fetches the data of images for section , rows and cell
    func FetchDataFromWebService(){
        
        
        for sections in categories.indices{
                    var count = 1

            picturesDataList.append([])
            
            for row in 0...2{
                
                picturesDataList[sections].append([])
                Webservice().fetchDataFromPixabay(withQuery: categories[sections] ,
                                                  page: count ,
                                                  success: { (images : [ImageInformationModel]) in
                                                    
                                                    self.picturesDataList[sections][row] = images
                                                    print("hit !!!!11")
                                                    self.categorieTableView.reloadData()
                                                    
                }){ (error : Error) in
                    
                    let alert = UIAlertController(title: "Alert", message: "No Internet Connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "continue", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    print(error)
                    
                }
                
                count += 1
                
            }
            
        }
    }
    
}

     

  //MARk : Datasource and Delegate for table view
  extension mainViewController : UITableViewDataSource , UITableViewDelegate{
   
    
   // Number of sections in Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
               return picturesDataList.count
        
     }
    
    //Number of Rows in section in Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
                 if sectionShowToHide.contains(section){
            
                return 0
                
                }
                
                else{
                
               return picturesDataList[section].count
                
                }
            
    }
    
    
    //for cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellID"  , for: indexPath) as? TableViewCell else{
                
                fatalError("TableCell Not Found")
                
                }
        
        
               if rowsToHide.contains(indexPath){
            
                tableCell.hideIteamSubCategorie.isSelected = true
                
                }
        

               //setting the borderwidth and color for table view cell
               tableCell.layer.borderWidth = 1.5
               tableCell.layer.borderColor = UIColor.black.cgColor
        
               //Register Collection cell
               let collectionCell = UINib(nibName: "CollectionViewCell", bundle: nil)
               tableCell.iteamSubCategoriesCollectionView.register(collectionCell , forCellWithReuseIdentifier:"CollectionViewCellID")
        
               //Registering the datasourece and delegate
               tableCell.iteamSubCategoriesCollectionView.delegate = self
               tableCell.iteamSubCategoriesCollectionView.dataSource = self
                tableCell.tableIndexPath = indexPath
               //making action for hideIteamSubCategorie button
               tableCell.hideIteamSubCategorie.addTarget(self, action: #selector(showAndHideDetailsBtnTapped), for: .touchUpInside)

        
               return tableCell
        
    }


    //Height of row in tABLE VIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
               if self.rowsToHide.contains(indexPath){
                
                   return 37
                }
                
                else{
                
                return 175
                
                }
            
    }
    
   //Register header cell in table view
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderViewCellID")as?HeaderViewCell else {
                
                fatalError()
                
                }
                //prints each section name on the header of table view
                header.sectionName.text = categories[section]
    
                //making section button target
                header.sectionButton.addTarget(self, action: #selector(sectionShowAndHideDetailsBtnTapped), for: .touchUpInside)
    
                //hiding and showing part of section showToHide
                header.sectionButton.tag = section
                 if sectionShowToHide.contains(section){
                
                header.sectionButton.isSelected = true
                
                }
                
                else{
                
                header.sectionButton.isSelected = false
                
                }
            
               return header
    }

    
  //Hieght of header in tableview
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
                return 30
    }
    
 //for hiding the section of table view
  func sectionShowAndHideDetailsBtnTapped(sectionButton : UIButton) {
    
               if sectionButton.isSelected{
            
               sectionButton.isSelected = false
                sectionShowToHide = sectionShowToHide.filter(){$0 != sectionButton.tag}
            
               }
                
               else{
            
               sectionButton.isSelected = true
               sectionShowToHide.append(sectionButton.tag)
            
               }
        
              categorieTableView.reloadSections([sectionButton.tag], with: .fade)
        
   }

    // for minimize and maximize of row
    func showAndHideDetailsBtnTapped(btn : UIButton){
    
            let cell = UIView.getDesireCell(givenObject: btn, desireView: .UITableViewCell) as! TableViewCell
        
            if btn.isSelected{

              rowsToHide = rowsToHide.filter({(indices:IndexPath)-> Bool in
                    return indices == categorieTableView.indexPath(for: cell)!
            })
                
            }
                
            else{
                
               rowsToHide.append(categorieTableView.indexPath(for: cell)!)
        
               categorieTableView.reloadRows(at: [categorieTableView.indexPath(for: cell)!], with: UITableViewRowAnimation.automatic)
                
                btn.isSelected = true
                
            }
    
        }

   }
    

 //MARk : Datasource and Delegate for table view
 extension mainViewController : UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        let tableViewCell = collectionView.getTableViewCell as! TableViewCell
        
        
        return picturesDataList[tableViewCell.tableIndexPath.section][tableViewCell.tableIndexPath.row].count
        
    }
    
    // for cells in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID",for: indexPath)as? CollectionViewCell else {fatalError()}
        
             // the Collectioncell imageview gets loaded with images present in URL
        
        
                // cell.contentImage.backgroundColor = UIColor.getRandomColor
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 3
        
                //making action  of Favourite Button
                cell.favourite.addTarget(self, action: #selector(favouriteBtnTapped), for: .touchUpInside)
        
                //getting tableviewcell and from that the indexpath for tableview
                  let tableViewCell = collectionView.getTableViewCell as! TableViewCell
        
                //checking favourite button persistency
                if favouriteIteamsArray.contains(where: {(indices:[IndexPath]) -> Bool in
            
                return indices == [tableViewCell.tableIndexPath,indexPath]}){
                cell.favourite.isSelected = true
                    
                }
                    
                else{
                        
                cell.favourite.isSelected = false
                    
                }
        
                //print the indexpath tableview , collection cell
                cell.cellIDNumber.text = "\(tableViewCell.tableIndexPath.section) \(tableViewCell.tableIndexPath.row) \(indexPath.row))"
        
                //fetching the data
                let data = picturesDataList[tableViewCell.tableIndexPath.section][tableViewCell.tableIndexPath.row][indexPath.row]
        
                 //setting the url into image in cell
                 if let url = URL(string: data.previewURL){
            
                  cell.contentImage.af_setImage(withURL : url)
            
                  }

                        return cell
        
    }
 
    
    
    //did select function for selection particular cell with animation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
              _ = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID",for: indexPath)as? CollectionViewCell else {fatalError()
               }
        
              guard let previewImage = self.storyboard?.instantiateViewController(withIdentifier: "imagepreviewVC") as? imagepreviewVC else{
                
                fatalError()
                
              }
    
    
                previewImage.imageURL = URL(string: cell.cellData.webformatURL)
        
                UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                self.navigationController?.pushViewController(previewImage, animated: true)
               //UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
                    
            })
                
    }
    
    
    // gets the  action after tap of favourite button
    func favouriteBtnTapped(btn:UIButton){
    
               guard  let collectionCell = btn.getCollectionViewCell as? CollectionViewCell else{
            
                     fatalError()
    
                }
    
               guard let tableCell = btn.getTableViewCell as? TableViewCell else{
            
                     fatalError()
                
                }
    
               let tableIndexPath = categorieTableView.indexPath(for: tableCell)
               let collectionIndexPath = tableCell.iteamSubCategoriesCollectionView.indexPath(for: collectionCell)
    
               if btn.isSelected{
            
                btn.isSelected = false
                favouriteIteamsArray = favouriteIteamsArray.filter({(indices:[IndexPath]) -> Bool in
            
                return indices != [tableIndexPath!,collectionIndexPath!]})
                
                }
            
               else{
            
               btn.isSelected = true
               self.favouriteIteamsArray.append([tableIndexPath!,collectionIndexPath!])
            
                }
        
              print(self.favouriteIteamsArray)
        
             //collectionCell.cellIDNumber.text = self.favouriteIteamsArray
    
        
        }
    
   }
