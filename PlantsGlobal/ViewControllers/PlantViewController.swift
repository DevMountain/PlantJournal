//
//  PlantViewController.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/22/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

// Plant detail VC
class PlantViewController: UIViewController {
    // MARK: - Properties
    //hold the ID of the plant we are using so we can retreive it from the API
    var plantID: Int?
    var plant: PlantDetails?
    var plantImages: [UIImage] = []
    var currentIndex: Int = 0
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var informationTextbox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calls add swipe function
        setUpSwipes()
        //makes sure we got a type ID
        guard let plantID = plantID else {return}
        //Calls our API call
        PlantDetailsController.getPlantDetails(plantId: plantID, completion: { (res) in
            //Handles our API calls response
            switch res {
            case .success(let plant):
                self.plant = plant
                let dispatchGroup = DispatchGroup()
                for imageUrl in plant.images {
                    dispatchGroup.enter()
                    PlantDetailsController.fetchImage(urlString: imageUrl.url) { (res) in
                        switch res {
                        case .success(let image):
                            self.plantImages.append(image)
                        case .failure(let err):
                            print("Error: \(err.localizedDescription) -> \(err)")
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.loadData()
                }
            case .failure(let err):
                print("Error: \(err.localizedDescription) -> \(err)")
            }
        })
    }
    //Setting up swipes
    func setUpSwipes() {
        imageView.isUserInteractionEnabled = true
        
        let swipeLeftGesture=UISwipeGestureRecognizer(target: self, action: #selector(SwipeDetected(gestureRecognizer:)))
        imageView.isUserInteractionEnabled=true
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        imageView.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture=UISwipeGestureRecognizer(target: self, action: #selector(SwipeDetected(gestureRecognizer:)))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        imageView.addGestureRecognizer(swipeRightGesture)
    }
    //Handles Swipes
    @objc func SwipeDetected(gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .right {
            if currentIndex >= 1{
                currentIndex -= 1
            }
        } else if gestureRecognizer.direction == .left {
            if currentIndex<plantImages.count-1{
                currentIndex+=1
            }
        } else if gestureRecognizer.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
        imageView.image = plantImages[currentIndex]
    }
    
    func loadData() {
        DispatchQueue.main.async {
            //safely unwrapping plant
            guard let plant = self.plant else {return}
            //Setting out title 
            self.title = plant.commonName
            //Sets our first image
            if !self.plantImages.isEmpty {
                self.imageView.image = self.plantImages[0]
            }
            //setting text to labels
            self.commonNameLabel.text = plant.commonName
            self.scientificNameLabel.text = "Scientific Name: \(plant.scientificName)"
            self.familyNameLabel.text = "Family Name: \(plant.familyCommonName)"
            self.informationTextbox.text = """
            Mature Height: \(plant.specifications.matureHeight.ft) feet
            Toxicity: \(plant.specifications.toxicity)
            Growth Rate: \(plant.specifications.growthRate)
            Growth Period: \(plant.specifications.growthPeriod)
            Growth Habit: \(plant.specifications.growthHabit)
            Growth Form: \(plant.specifications.growthForm)
            """
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
