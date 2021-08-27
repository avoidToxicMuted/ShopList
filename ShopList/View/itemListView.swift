//
//  itemlistView.swift
//  test3
//
//  Created by snoopy on 22/07/2021.
//

import SwiftUI

struct itemlistView: View {
    @Environment(\.presentationMode) var presentation
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ListInfo.listDate, ascending: false)])

    private var lists : FetchedResults<ListInfo>
    
    @State var list : FetchedResults<ListInfo>.Element
    
    @State private var listDate : String = ""
    
    @State private var inputItemName : String = ""
    
    @State private var buttonClick : Bool = false
    
    @State private var add : Bool = false
    
    @State private var update : Bool = false
    
    
    
    //MARK:-FUNCTION
    private func saveContext(){
        do{
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Unresolved error : \(error)")
        }
    }

    private func addItem(){
        let newItem = ItemInfo(context  : viewContext)
        newItem.itemName = inputItemName
        newItem.itemQuantity = "1"
        newItem.itemPrice = "0"
        
        list.addToItem(newItem)
        saveContext()
        
        inputItemName=""

    }
    
    private func deleteItem(offsets : IndexSet){
        offsets.map {list.itemArray[$0]}.forEach(viewContext.delete)
        saveContext()
        
    }
    
    //MARK:- VIEW
    var body: some View {
        Form{
            HStack{
                TextField("Enter item name" , text : $inputItemName)
                Button(action :{
                    if(!inputItemName.isEmpty){ addItem() }
                    else{ buttonClick = true }
                }){ Image(systemName: "plus") }
            }
            
            Section(header: Text("Date : ").font(.title3).fontWeight(.bold)){
                Text(listDate).foregroundColor(Color(UIColor.lightGray)).fontWeight(.bold)
            }.textCase(nil)
            
            Section(header: Text("Item :").font(.title3).fontWeight(.bold)){
                List{
                    withAnimation{
                        ForEach(list.itemArray) { item in
                            itemCell(item: item , list : list)
                        }.onDelete(perform: deleteItem)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UITableView.selectionDidChangeNotification)) {
                    guard let tableView = $0.object as? UITableView, let selectedRow = tableView.indexPathForSelectedRow else { return }
                    tableView.deselectRow(at: selectedRow, animated: true)
                }
                
            }.textCase(nil)
        }
        
        .onAppear{
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            self.listDate = formatter1.string(from: list.listDate!)
        }
        .navigationTitle(self.list.listName ?? "unknown")
        .navigationBarItems(trailing: Button(action: { self.add.toggle()}) {
            Image(systemName: "folder.badge.plus")
                .resizable()
                .frame(width: 30, height: 23, alignment: .center)
        })
        
        .sheet(isPresented: $add) { addDetailItem(list: list) }
        
        .alert(isPresented: $buttonClick){
            Alert(title: Text("Warning"),
                  message: Text("You did not enter any name on the text field"),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}
