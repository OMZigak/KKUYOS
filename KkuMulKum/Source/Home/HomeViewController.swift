//
//  HomeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit


class HomeViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = HomeView()


    // MARK: - LifeCycle

    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
