//
//  HeightViewController.swift
//  WiTrackApp
//
//  Created by Jamar Brooks on 12/2/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit
import Charts

class HeightViewController: UIViewController {
    
    var userId : Int?
    var token : String?
    
    var currentData = [Position]()
    var allData = [Position]()
    var floorHeight : Double = 0.15
    
    var socket : SocketIOClient?
    
    @IBOutlet weak var chartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chartView.backgroundColor = UIColor.whiteColor()
        currentData.append(Position(x: 1, y: 1, z: 1, personId: 0))
        currentData.append(Position(x: 1, y: 1, z: 2, personId: 1))
        currentData.append(Position(x: 1, y: 1, z: 3, personId: 2))
        currentData.append(Position(x: 1, y: 1, z: 4, personId: 3))
        
        setupChart()
        
        loadChart(currentData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupChart() {
        let floorLine = ChartLimitLine(limit: floorHeight, label: "Floor")
        chartView.leftAxis.addLimitLine(floorLine)
        
        chartView.xAxis.drawGridLinesEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false
        
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.showOnlyMinMaxEnabled = true

        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.showOnlyMinMaxEnabled = true
    }
    
    func loadChart(data : [Position]) {
        
        if data.count == 0 {
            chartView.noDataText = "Device is not detecting any moving objects."
            chartView.noDataTextDescription = ""
            chartView.data = nil
        } else {        
            var dataEntries: [BarChartDataEntry] = []
            var xValues = [Int]()
            
            for i in 0 ..< data.count {
                xValues.append(i)
                let dataEntry = BarChartDataEntry(value: Double(data[i].z!), xIndex: data[i].personId!)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Height (m)")
            let chartData = BarChartData(xVals: xValues, dataSet: chartDataSet)
            chartView.data = chartData
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
