//
//  itemView.swift
//  test3
//
//  Created by snoopy on 18/07/2021.
//

import SwiftUI

struct itemView: View {
    @Environment(\.presentationMode) var presentation
    
    var viewContext = PersistenceController.shared.container.viewContext
    
    @State var item : FetchedResults<ItemInfo>.Element
    
    @State var list : FetchedResults<ListInfo>.Element
    
    @State var update : Bool = false
     
    //MARK:-VIEW
    var body: some View {
        Form{
            VStack{
                if(self.item.itemImage == nil){
                    Image("emptyImage")
                        .resizable()
                        .frame(width: 310, height: 270 , alignment: .center)
                }
                else{
                    let image = UIImage(data:self.item.itemImage!)
                    Image(uiImage: image!)
                        .resizable()
                        .cornerRadius(7.0)
                        .frame(width: 310, height: 270 , alignment: .center)
                }
            }
            Section(header: Text("Quantity : \(self.item.itemQuantity)").font(.title3).fontWeight(.bold)){ Text(self.item.itemQuantity) }
            Section(header: Text("Price : RM\(self.item.itemPrice)").font(.title3).fontWeight(.bold)){ Text("RM \(self.item.itemPrice)") }
        }
        .navigationTitle(self.item.itemName ?? "unknown")
        .navigationBarItems(trailing: Button(action: { self.update.toggle() }){ Text("Edit") })
        .sheet(isPresented: $update) { updateItem(item: item , list : list) }
    }
    
}

