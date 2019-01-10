//
//  ViewController.swift
//  BookingDemo
//
//  Created by Pankaj on 04/01/19.
//  Copyright © 2019 Canarys Automations Pvt Ltd. All rights reserved.
//

import UIKit
import JNSegmentedControl
import  SwiftyJSON


class ViewController: UIViewController {

    @IBOutlet var daySeg: JNSegmentedCollectionView!
    @IBOutlet var numberOfPeopleSeg: JNSegmentedCollectionView!
    @IBOutlet var typeOfLunchSeg: JNSegmentedCollectionView!
    @IBOutlet var timeSeg: JNSegmentedCollectionView!
    
    
    
    var dayDateList = [String]()
    let peopleList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var lunchList = [String]()
    var globalData = JSON()
    var lunchTimeList = [String]()

    // array of Day items
    var attributedStringItems: [NSAttributedString] = []
    var selectedAttributedStringItems: [NSAttributedString] = []
    
    // array of Person items
    var attributedPeopleItems: [NSAttributedString] = []
    var selectedAttributedPeopleItems: [NSAttributedString] = []
    
    // array of LunchType items
    var attributedTypeItems: [NSAttributedString] = []
    var selectedAttributedTypeItems: [NSAttributedString] = []
    
    // array of LunchTime items
    var attributedTimeItems: [NSAttributedString] = []
    var selectedAttributedTimeItems: [NSAttributedString] = []
    
    
    var defaultAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
    
    var selectedAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: CGFloat(0), green: CGFloat(118.0/255.0), blue: CGFloat(192/255.0), alpha: CGFloat(1.0))]
    
    let interval = Int()

    var segmentList: [JNSegmentedCollectionView]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let verticalSeparatorOptions = JNSegmentedCollectionItemVerticalSeparatorOptions(heigthRatio: 0.8, width: 1.0 ,color: UIColor(red: CGFloat(0), green: CGFloat(118.0/255.0), blue: CGFloat(192/255.0), alpha: CGFloat(1.0)))
        
        // define options
        let options = JNSegmentedCollectionOptions(backgroundColor: .white, layoutType: JNSegmentedCollectionLayoutType.dynamic, verticalSeparatorOptions: verticalSeparatorOptions, scrollEnabled: true)
        
        segmentList = [daySeg,numberOfPeopleSeg,typeOfLunchSeg,timeSeg]

        _ =   segmentList?.enumerated().map{(index,element) in

            element.layer.cornerRadius = 5.0
            element.backgroundColor = .lightGray
            element.tag = index
        }

        daySeg.setup(items: self.attributedStringItems, selectedItems: self.selectedAttributedStringItems, options: options)
        numberOfPeopleSeg.setup(items: self.attributedPeopleItems, selectedItems: self.selectedAttributedPeopleItems, options: options)
        typeOfLunchSeg.setup(items: self.attributedTypeItems, selectedItems: self.selectedAttributedTypeItems, options: options)
        timeSeg.setup(items: self.attributedTimeItems, selectedItems: self.selectedAttributedTimeItems, options: options)

       
        
        // setup collection view

        
        
        
        if let path = Bundle.main.path(forResource: "bookResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                let name = jsonObj["data"]
                //globalData = name
                for (key,value) in name{
                    self.dayDateList.append(key)
                    self.lunchList = value.arrayValue.map({$0["service_hour_name"].stringValue})
                    
                    let serviceTimeTo = value.arrayValue.map({$0["service_time_to"].stringValue})
                    let serviceTimeFrom = value.arrayValue.map({$0["service_time_from"].stringValue})
                    
                    let dateFormat = "HH:mm:ss"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormat
                   
                    let startTime = serviceTimeFrom[0]
                    let endTime = serviceTimeTo[0]
                    
                    
                    guard let test1 = dateFormatter.date(from: startTime) else{
                        return
                    }
                    guard let test2 = dateFormatter.date(from: endTime) else {
                        return
                    }
                    
                    
                    
                    
                    
                    let calendar = Calendar.current
                    
                    
                    let unitFlags = Set<Calendar.Component>([.hour])

                    
                    let dateComponents = calendar.dateComponents(unitFlags, from: test1, to: test2)
                    
                    guard let Hours = dateComponents.hour else { return }
                    print("Hours: \(Hours)")
                    
                    let dateofServiceFrom = DateInterval.init(start: test1, end: test2)
                
                    
                    
                    self.lunchTimeList = [serviceTimeFrom[0], serviceTimeTo[0],serviceTimeFrom[1], serviceTimeTo[1]]
                    
                    
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        
        setupTextOnlySegmentedCollectionView()
        setupTextOnlySegmentedForPeople()
        setupTextOnlySegmentedForType()
        setupTextOnlySegmentedForTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        daySeg.valueDidChange = { segmentIndex in
            print(segmentIndex)
            
        }
        
        numberOfPeopleSeg.valueDidChange = { segmentIndex in
            print(segmentIndex)
            
        }
        
        typeOfLunchSeg.valueDidChange = { segmentIndex in
            print(segmentIndex)
            
        }
        
        timeSeg.valueDidChange = { segmentIndex in
            print(segmentIndex)
            
        }
    }
  
    // MARK: - Build Segmented Styles
    private func setupTextOnlySegmentedCollectionView(){
        
        for item in self.dayDateList {
            
            let defaultAttributedString = NSAttributedString(string: item, attributes: defaultAttributes)
            attributedStringItems.append(defaultAttributedString)
            
            let selectedAttributedString = NSAttributedString(string: item, attributes: selectedAttributes)
            selectedAttributedStringItems.append(selectedAttributedString)
            
        }
         self.daySeg.setup(items: self.attributedStringItems, selectedItems: self.selectedAttributedStringItems, options: nil)
       
    }

    func setupTextOnlySegmentedForPeople(){
        
        for item in self.peopleList {
            
            let defaultAttributedString = NSAttributedString(string: "\(item)", attributes: defaultAttributes)
            attributedPeopleItems.append(defaultAttributedString)
            
            let selectedAttributedString = NSAttributedString(string: "\(item)", attributes: selectedAttributes)
            selectedAttributedPeopleItems.append(selectedAttributedString)
        }
        self.numberOfPeopleSeg.setup(items: self.attributedPeopleItems, selectedItems: self.selectedAttributedPeopleItems, options: nil)
        
    }
    
    func setupTextOnlySegmentedForType(){
        
        for item in self.lunchList {
            
            let defaultAttributedString = NSAttributedString(string: item, attributes: defaultAttributes)
            attributedTypeItems.append(defaultAttributedString)
            
            let selectedAttributedString = NSAttributedString(string: item, attributes: selectedAttributes)
            selectedAttributedTypeItems.append(selectedAttributedString)
        }
        self.typeOfLunchSeg.setup(items: self.attributedTypeItems, selectedItems: self.selectedAttributedTypeItems, options: nil)
        
    }
    
    func setupTextOnlySegmentedForTime(){
        
        for item in self.lunchTimeList {
            
            let defaultAttributedString = NSAttributedString(string: item, attributes: defaultAttributes)
            attributedTimeItems.append(defaultAttributedString)
            
            let selectedAttributedString = NSAttributedString(string: item, attributes: selectedAttributes)
            selectedAttributedTimeItems.append(selectedAttributedString)
        }
        self.timeSeg.setup(items: self.attributedTimeItems, selectedItems: self.selectedAttributedTimeItems, options: nil)

    }
    
}


