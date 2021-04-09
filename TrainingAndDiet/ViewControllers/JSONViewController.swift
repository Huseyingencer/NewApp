//
//  JSONViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 1.04.2021.
//

import UIKit

class JSONViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.jsonData?.Result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jsonCell") as! JSONTableViewCell
        cell.titleText.text = jsonData!.Result[indexPath.row].title
        cell.contentText.text = jsonData!.Result[indexPath.row].content
        let image = try? Data(contentsOf: URL(string: (jsonData?.Result[indexPath.row].image)!)!)
        cell.imageView?.image = UIImage(data: image!)
        return cell
    }
    
    @IBOutlet weak var jsonTableView: UITableView!
    
    var jsonUrl = URL(string: "http://ahmtkocamn.xyz/id3/api/yemek.json")!
    let decoder = JSONDecoder()
    var session = URLSession.shared
    var jsonData : Entry?
    override func viewDidLoad() {
        super.viewDidLoad()
       
            /*let task : URLSessionDataTask = self.session.dataTask(with: self.jsonUrl, completionHandler: {(data, response, error) in
            if data != nil{
                do{
                    self.jsonData = try self.decoder.decode(Entry.self, from: data!)
                    print(self.jsonData?.ErrorMessage)
                    
                }
                catch{
                    print(error,"dada")
                }
            }
            
        })
        task.resume()*/
        //self.jsonTableView.reloadData()
        getData()
        
        
        
    }
    
    
    func getData() -> Void{
        let task : URLSessionDataTask = self.session.dataTask(with: self.jsonUrl, completionHandler: {(data, response, error) in
        if data != nil{
            do{
                let jsonData = try self.decoder.decode(Entry.self, from: data!)
                self.jsonData = jsonData
                DispatchQueue.main.async {
                    self.jsonTableView.reloadData()
                }
                
            }
            catch{
                print(error,"dada")
            }
        }
        
    })
    task.resume()
        
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
