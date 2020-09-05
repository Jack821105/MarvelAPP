//
//  MainCollectionViewController.swift
//  MarvelAPP
//
//  Created by 許自翔 on 2020/9/4.
//

import UIKit
import CryptoKit

private let reuseIdentifier = "Cell"
let ts = Date().timeIntervalSinceReferenceDate
let privateKey = "cb2bf8fdc79a6f136e03edcadeab103c2d664f28"
let publicKey = "c0b49697d520bb69f7b1595e96e0280c"
let md5InputData = "\(ts)\(privateKey)\(publicKey)".data(using: .utf8)!
let digest = Insecure.MD5.hash(data: md5InputData)
let hashString = digest.map {
    String(format: "%02x", $0)
}.joined()


class MainCollectionViewController: UICollectionViewController {
   
    
    let address = "https://gateway.marvel.com:443/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hashString)"
    var baseDataFinal:baseData?
    var secondData:secondData?
    var thirdData = [results]()
    var thirdDataFinal:results?
    var heroCount:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        getMarvel()
        
    }

    
    //取得資料
    func getMarvel(){
        if let url = URL(string: address) {
            // GET
            URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .deferredToDate
                    try! decoder.decode(baseData.self, from: data)
                    //宣告物件來接進來的資料
                    if let heroFinal = try? decoder.decode(baseData.self, from: data) {
                        self.baseDataFinal = heroFinal
                        //取得array的數量
                        heroCount = self.baseDataFinal!.data.count
                        //把baseDataFinal裡面的data帶給secondData物件
                        secondData = self.baseDataFinal!.data
                        
                        if let sec = self.secondData {
                            //跑回圈把array的資料個別new出來
                            self.thirdData = sec.results
                            if thirdData != nil {
                                for i in 0..<self.thirdData.count {
                                        thirdDataFinal = thirdData[i]

                                    }
                                }
                        }
                        
                        //重新刷新畫面
                        DispatchQueue.main.async{
                            self.collectionView.reloadData()
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return thirdData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let test = thirdData[indexPath.item]
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(itemCollectionViewCell.self)", for: indexPath) as? itemCollectionViewCell
        //把path型別url轉型為string
        //absoluteString url to string方法
        let testImageView = test.thumbnail.path.absoluteString

        if let urlStr = URL(string: testImageView + "/landscape_xlarge.jpg" ){
            URLSession.shared.dataTask(with: urlStr) { (dataImage, response, error) in
                 if let dataImage = dataImage{
                    print("test")
                    DispatchQueue.main.async{
                        cell?.heroImage.image = UIImage(data: dataImage)
                    }
                }
            }.resume()
        }
        
        if let cell = cell {
            print("1")
            return cell
        }else{
            print("2")
            return UICollectionViewCell()
        }
        
        
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    //把物件傳至第二頁
//    
    @IBSegueAction func goTODetail(_ coder: NSCoder) -> DetailViewController? {
        
        let controller = DetailViewController.init(coder: coder)
        
        if let item = collectionView.indexPathsForSelectedItems?.first?.row {
            controller?.finalHero = thirdData[item]
        }
        
//            collectionView.indexPathsForSelectedItems
        return controller
    }
}
