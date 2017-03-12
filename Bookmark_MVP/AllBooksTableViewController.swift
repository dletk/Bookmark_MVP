//
//  AllBooksTableViewController.swift
//  Bookmark_MVP
//
//  Created by Duc Le on 3/7/17.
//  Copyright © 2017 Team Grant_le_mandel. All rights reserved.
//

import UIKit

class AllBooksTableViewController: UITableViewController {
    
    //Checks sort method — true if alphabetical, false if by date
    private var isAlphabetical = false
    private var books = [Book]()
    
    @IBOutlet weak var allSortType: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Reload the data of table to make it updated with changes in books (if any).
    override func viewWillAppear(_ animated: Bool) {
        books = bookManager.allBooks
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllBooksTableViewCell", for: indexPath) as? AllBooksTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllBookTableViewCell")
        }
        cell.book = books[indexPath.row]
        
        return cell
    }
    
    // Select a book to move to its details page.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AllBookToBookDetailsSegue", sender: self)
    }
    
    // Prepare for the BookDetailView before perform the segue to it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AllBookToBookDetailsSegue"?:
            guard let destination = segue.destination as? BookDetailsViewController else {
                return
            }
            destination.book = books[(tableView.indexPathForSelectedRow?.row)!]
        default:
            return
        }
    }
    
    @IBAction func sortTypeChanged(_ sender: UISegmentedControl) {
        switch allSortType.selectedSegmentIndex
        {
        case 0:
            isAlphabetical = true
            books = books.sorted(by: {makeAlphabetizableTitle(book: $0) < makeAlphabetizableTitle(book: $1)})
        case 1:
            isAlphabetical = false
        default:
            break
        }
        tableView.reloadData()
    }
    
    //(Kelli) function for ignoring "the" substring and case when alphabetizing
    
    private func makeAlphabetizableTitle(book : Book) -> String{
        
        var alphebetizable = book.title.lowercased()
        
        if alphebetizable.characters.count > 4{
            let index = alphebetizable.index(alphebetizable.startIndex, offsetBy: 4)
            let firstThreeLetters = alphebetizable.substring(to: index)
            if firstThreeLetters == "the "{
                alphebetizable = alphebetizable.substring(from: index)
            }
        }
        return alphebetizable
    }
    
    // TODO: The logic for this method should be as follow:
    // If the book is marked as reading, then the tableview should swipe the row back to its position (not implemented) and the BookTableView should appear that book (done)
    // However, find a way for preventing user add a book back multiple times (finished but not fully tested).
    // Delete a book should be just same as BookTableView
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let book = books[indexPath.row]
        
        let unDoneBook = UITableViewRowAction(style: .normal, title: "Mark as Reading", handler: {_,_ in 
            // Check if the book is in the displayed book already.
            bookManager.markAsReading(book: book)
        })
        unDoneBook.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            _,_ in bookManager.delete(book: book)
            self.books = bookManager.allBooks
            tableView.deleteRows(at: [indexPath], with: .fade)})
        delete.backgroundColor = UIColor.red
        
        return [unDoneBook, delete]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
