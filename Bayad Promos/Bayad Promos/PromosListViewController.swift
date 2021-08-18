//
//  ViewController.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import UIKit
import Alamofire

class PromosListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:Variables
    private var promosList: [Promo] = []
    private var promoService: PromoNetworkService!
    var refreshControl: UIRefreshControl?
    
    // MARK:TableView
    @IBOutlet weak var promosTableView: UITableView!
    
    // MARK:Views
    @IBOutlet weak var loadingView: UIView!
    
    // MARK:Labels
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK:Images
    @IBOutlet weak var emptyImageView: UIImageView!
    
    // MARK:Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promosTableView.tableFooterView = UIView()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        promosTableView.addGestureRecognizer(longPress)
        setupDelegates()
        addRefreshControl()
        promoService = PromoNetworkService.init()
        callGetPromos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        callGetPromos()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // MARK:Helper methods
    func setupDelegates(){
        promosTableView.delegate = self
        promosTableView.dataSource = self
    }
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        promosTableView.addSubview(refreshControl!)
    }
    
    func changeLayout(isEmpty: Bool){
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
    }
    
    @objc func refreshList(){
        callGetPromos()
        promosTableView.reloadData()
    }
    
    func callGetPromos(){
        loadingView.isHidden = false
        promoService.getAllPromos(viewController: self)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: promosTableView)
            if let indexPath = promosTableView.indexPathForRow(at: touchPoint) {
                let deletePromo = promosList[indexPath.row]
                let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete \(deletePromo.name ?? "this promo")?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  {action in
                                                self.deletePromo(id: deletePromo.id)
                                          }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func deletePromo(id: String){
        loadingView.isHidden = false
        promoService.deletePromo(viewController: self, id: id)
    }
    
    
    // MARK:Webservice Response
    func handleGetAllPromosResponse(success: Bool, getAllPromosResponse: [Promo]?, error: AFError?){
        if let response = getAllPromosResponse, success {
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.promosList = response
                if(self.promosList.isEmpty){
                    self.changeLayout(isEmpty: true)
                } else {
                    self.changeLayout(isEmpty: false)
                }
                self.refreshControl?.endRefreshing()
                self.promosTableView.reloadData()
            }
        }
        
        if let err = error, !success{
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.changeLayout(isEmpty: true)
                let alert = UIAlertController(title: "Oops!", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func handleDeletePromoResponse(success: Bool, error: AFError?){
        self.loadingView.isHidden = true
        if(success){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success!", message: "Promo has been deleted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
                        self.callGetPromos()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        if let err = error, !success{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops!", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
                                              self.callGetPromos()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let promo = promosList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell") as! PromoTableViewCell
        
        cell.setPromo(promo: promo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promo = promosList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PromoDetailsVCID") as! PromoDetailsViewController
        vc.selectedPromo = promo
        navigationController?.pushViewController(vc, animated: true)
    }


}

