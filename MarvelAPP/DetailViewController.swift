//
//  DetailViewController.swift
//  MarvelAPP
//
//  Created by 許自翔 on 2020/9/4.
//

import UIKit

class DetailViewController: UIViewController {
    //宣告區
    var finalHero:results?
    @IBOutlet weak var heriImageView: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    @IBOutlet weak var heroDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getHeroImage()
        heroName.text = finalHero?.name
        heroDescription.text = finalHero?.description
        heroDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    //取得物件的圖片
    func getHeroImage() {
        let testImageView = finalHero?.thumbnail.path.absoluteString
        
        if let urlStr = URL(string: testImageView! + "/landscape_xlarge.jpg"){
            URLSession.shared.dataTask(with: urlStr) { (dataImage, response, error) in
                 if let dataImage = dataImage{
                    print("test")
                    DispatchQueue.main.async{
                        self.heriImageView.image=UIImage(data: dataImage)
                    }
                }
            }.resume()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
