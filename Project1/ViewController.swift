//
//  ViewController.swift
//  Project1
//
//  Created by Luca Hummel on 21/06/21.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var countPicture = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        countPicture = UserDefaults.standard.array(forKey: "countPicture") as? [Int] ?? [Int]()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendsApp))
        
        performSelector(inBackground: #selector(readImages), with: nil)
        tableView.reloadData()
        
    }
    
    @objc func readImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                countPicture.append(0)
            }
        }
        pictures.sort() // metodo para deixar em ordem ascendente
    }
    
    override func viewWillAppear(_ animated: Bool) { // Estava bugando o tap, por isso adicionei aqui para falso
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
        tableView.reloadData()
    }
    
    //this code will be triggered when iOS wants to know how many rows are in the table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    //called when you need to provide a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "\(countPicture[indexPath.row])"
        return cell // retornar uma TableViewCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countPicture[indexPath.row] += 1
        UserDefaults.standard.set(countPicture, forKey: "countPicture")
        
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            //vc.pictures = pictures
            vc.totalPositions = pictures.count
            vc.positionSelected = indexPath.row + 1
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func recommendsApp() {
        let message = "You need to Download this app! With this you can see beautiful photos os storms! Download right now on App Store"
        
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

