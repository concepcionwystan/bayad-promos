//
//  PromoDetailsViewController.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import UIKit
import Alamofire

class PromoDetailsViewController: UIViewController {
    
    // MARK:Variables
    var selectedPromo: Promo!
    private var promoService: PromoNetworkService!
    
    // MARK:Image Views
    @IBOutlet weak var promoImageView: UIImageView!
    
    // MARK:Labels
    @IBOutlet weak var promoNameLabel: UILabel!
    @IBOutlet weak var promoDetailsLabel: UILabel!
    
    // MARK:Views
    @IBOutlet weak var loadingView: UIView!
    
    // MARK:Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Promos"
        promoNameLabel.text = selectedPromo.name
        promoDetailsLabel.text = selectedPromo.details
        promoService = PromoNetworkService.init()
        if(selectedPromo.read == 0){
            callPutPromo()
        }
        fetchImage()
        
    }
    
    // MARK:Helper Methods
    func fetchImage(){
        guard let url = URL(string: selectedPromo.image) else { return }
        UIImage.loadFrom(url: url) { image in
            self.promoImageView.image = image
        }
    }
    
    func callPutPromo(){
        loadingView.isHidden = false
        let putPromoRequest = PUTPromoRequest.init(name: selectedPromo.name, details: selectedPromo.details, image: selectedPromo.image, read: 1)
        promoService.putPromo(viewController: self, id: selectedPromo.id, params: putPromoRequest)
    }
    
    // MARK:Webservice Response
    func handlePutPromoResponse(success: Bool, error: AFError?){
        self.loadingView.isHidden = true
        if let err = error, !success{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops!", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

extension UIImage {
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}


