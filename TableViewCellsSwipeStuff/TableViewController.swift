//
//  TableViewController.swift
//  TableViewCellsSwipeStuff
//
//  Created by Paul Wallace on 2/22/18.
//  Copyright © 2018 Paul Wallace. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let data = ["a", "b", "c", "d"]
    var gestureDict : [NSValue: Int]  = [:]
    var draggingLeft : Bool = false
    var dragging: Int = 0 // 0 = no drag, -1 = left drag, 1 = right drag
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let rightLeftCell = cell as? RightLeftTableViewCell else {
            return cell
        }
        let drag = UIPanGestureRecognizer(target: self, action: #selector(cellDragged(_:)))
        rightLeftCell.addGestureRecognizer(drag)
        let value = NSValue.init(nonretainedObject: drag)
        gestureDict[value] = indexPath.row
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    @objc func cellDragged(_ gesture: UIPanGestureRecognizer) {
        let key = NSValue.init(nonretainedObject: gesture)
        guard let row = gestureDict[key] else {return}
        //Get the cell
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? RightLeftTableViewCell else {return}
        let translation = gesture.translation(in: cell)
        switch gesture.state {
        case .began:
            //Check which way we are dragging
            if translation.x < 0 {
                dragging = -1
            } else {
                dragging = 1
            }
            fallthrough
        case .changed:
            var constraint : NSLayoutConstraint!
            var finishedString : String!
            var change : CGFloat = 0
            if dragging == 0 {return}
            if dragging == -1 {
                constraint = cell.leftStretchViewWidthConstraints
                finishedString = "Yes!"
                change = translation.x * -1
            }
            if dragging == 1 {
                constraint = cell.rightStretchViewWidthConstraint
                finishedString = "No!"
                change = translation.x
            }
            
            if abs(constraint.constant) + abs(change) >= cell.frame.width && constraint.constant >= cell.frame.width {
                return
            }
            print(constraint.constant)
            constraint.constant += 2.5 * change
            if constraint.constant >= cell.frame.width {
                cell.centerLabel.text = finishedString
                UIView.animate(withDuration: 0.33, animations: {
                    cell.centerLabel.alpha = 1
                }, completion: {
                    val in
                    UIView.animate(withDuration: 0.33, delay: 1.0, options: [.curveEaseIn], animations: {
                        cell.centerLabel.alpha = 0
                    }, completion: nil)
                })
            } else if constraint.constant < 0 {
                constraint.constant = 0
            }
            gesture.setTranslation(CGPoint.zero, in: cell)
        case .ended, .cancelled:
            dragging = 0
            cell.rightStretchViewWidthConstraint.constant = 0
            cell.leftStretchViewWidthConstraints.constant = 0
            UIView.animate(withDuration: 0.33) {
                cell.layoutIfNeeded()
            }
        default: print("wtf are you doing")
        }
    }
}
