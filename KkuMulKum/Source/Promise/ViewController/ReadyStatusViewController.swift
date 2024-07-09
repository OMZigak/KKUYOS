//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class ReadyStatusViewController: BaseViewController {
    
    private let readyStatusView: ReadyStatusView = ReadyStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(readyStatusView)
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
