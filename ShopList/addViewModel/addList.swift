//
//  addList.swift
//  ShopList
//
//  Created by snoopy on 19/07/2021.
//

import SwiftUI

struct addList: View {
    
    @Environment(\.presentationMode) var presentation
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var date = Date()
    
    @State private var inputListName : String = ""
    
    //MARK:-FUNCTION    
    private func AddList(){
        let newList = ListInfo(context: viewContext)
        newList.listName = inputListName
        newList.listDate = date
        do{
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Unresolved error : \(error)")
        }
        presentation.wrappedValue.dismiss()

    }
    
    //MARK:-VIEW
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("List name : ").font(.title3).fontWeight(.bold)){
                    TextField("Enter list name" , text: $inputListName)
                }.textCase(nil)
                Section(header: Text("Date : ").font(.title3).fontWeight(.bold)){
                    HStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill(Color.red)
                                            .frame(width: 30, height: 30)
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 17, height: 17, alignment: .center)
                                .foregroundColor(.white)
                        }
                            
//                            .border(Color.red)
                        DatePicker("List for : ", selection: $date , displayedComponents: .date)
                    }
                    
                }.textCase(nil)
                
            }
            .navigationTitle("Add new item")
            .navigationBarItems(trailing: Button(action : {AddList()}){Text("Add").foregroundColor(.white).frame(width: 60, height: 30, alignment: .center).background(Color.blue).cornerRadius(7.0)})
        }
    }
}


