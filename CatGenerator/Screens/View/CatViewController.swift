//
//  CatViewController.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import UIKit
import Combine

class CatViewController: UIViewController {
    
    private let viewModel = CatViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // UI Elements
    @IBOutlet weak var catImageView:CustomImageView!
    @IBOutlet weak var catFactLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIGeasture()
        bindViewModel()
        
        // Call the fetch method
        viewModel.fetchRandomCatData()
    }
    
    private func setupUIGeasture() {
        // Add tap gesture recognizer to the catImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reloadData))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        // Subscribe to catImage updates
        viewModel.$catImage
            .sink { [weak self] imageUrl in
                self?.updateCatImage(with: imageUrl)
            }
            .store(in: &cancellables)
        
        // Subscribe to catFact updates
        viewModel.$catFact
            .sink { [weak self] fact in
                self?.catFactLabel.text = fact
            }
            .store(in: &cancellables)
        
        // Subscribe to errorMessage to show alerts
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateCatImage(with urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            self.catImageView.loadImage(from: url)
        }else {
            // use placeholder after stopping spinner which is loading if image not found
        }
    }
    
    //MARK:- Reload Api on Tap Image
    @objc private func reloadData() {
        viewModel.fetchRandomCatData()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true) {
            // Add bounce effect to the alert
            self.bounceAlert(alert: alert)
        }
    }
}
