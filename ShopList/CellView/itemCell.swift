//
//  itemCell.swift
//  test3
//
//  Created by snoopy on 13/07/2021.
//

import SwiftUI

struct itemCell: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var item : FetchedResults<ItemInfo>.Element
    
    @State var list : FetchedResults<ListInfo>.Element
    
    @State var statusImage : String = ""
    
    //MARK:- FUNCTION
    private func updateStatus(_ item : FetchedResults<ItemInfo>.Element){
        withAnimation{
            if(item.itemStatus==false){
                item.itemStatus=true
                loadHapticFeedBack(style: .heavy)
            }else{
                item.itemStatus=false
                loadHapticFeedBack(style: .light)
            }
            statusImage = (item.itemStatus) ? "bag" : "emptyBag"
            
            do{
                try viewContext.save()
            }catch{
                let error = error as NSError
                fatalError("Unresolved error : \(error)")
            }

        }
    }
    
    private func loadHapticFeedBack(style : UIImpactFeedbackGenerator.FeedbackStyle){
        let impactHeavy = UIImpactFeedbackGenerator(style: style)
                    impactHeavy.impactOccurred()
    }
    
    //MARK:- VIEW
    var body: some View {
        NavigationLink(destination : itemView(item: item , list: list)){
                HStack{
                    Image(statusImage)
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .clipped()
                        .onTapGesture (count : 1 , perform: {
                            updateStatus(item)
                        })
                    Text(item.itemName ?? "No item name")
                }
                .onAppear{
                    statusImage = (item.itemStatus) ? "bag" : "emptyBag"
                }
                
        }
    }
}

