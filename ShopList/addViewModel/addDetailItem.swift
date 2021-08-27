//
//  addDetailItem.swift
//  ShopList
//
//  Created by snoopy on 18/07/2021.
//

import SwiftUI

struct addDetailItem: View {
    
    @Environment(\.presentationMode) var presentation
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity : ListInfo.entity() , sortDescriptors: [NSSortDescriptor(keyPath: \ListInfo.listDate, ascending: false)])

    private var lists : FetchedResults<ListInfo>

    @State var list : FetchedResults<ListInfo>.Element
    
    @State private var inputQuantity : String = ""
    @State private var inputItemName : String = ""
    @State private var inputItemPrice : String = ""
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    
    //MARK:- FUNCTION
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private func AddItem(){
            let newItem = ItemInfo(context: viewContext)
            
            newItem.itemStatus = false
            newItem.itemName = inputItemName
            newItem.itemPrice = (!inputItemPrice.isEmpty) ? inputItemPrice : "0"
            newItem.itemQuantity = (!inputQuantity.isEmpty) ? inputQuantity : "1"
            newItem.itemImage = (image != nil) ? inputImage?.jpegData(compressionQuality: 1.0) : nil
            
            self.list.addToItem(newItem)
            do{
                try viewContext.save()
            }catch{
                let error = error as NSError
                fatalError("Unresolved error : \(error)")
            }
            presentation.wrappedValue.dismiss()
    }
    
    
    //MARK:-  View
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    if image == nil{
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50 ,alignment: .center)
                                .cornerRadius(7.0)
                                .onTapGesture {
                                    self.showImagePicker.toggle()
                                }
                        }
                    }
                    else{
                        image!
                            .resizable()
                            .frame(width: 310, height: 270)
                            .cornerRadius(7.0)
                            .onTapGesture {
                                self.showImagePicker.toggle()
                            }
                    }
                    
                }.frame(width: 310, height: 270, alignment: .center)
                Section(header: Text("name : ").font(.title3).fontWeight(.bold)){
                    TextField("Enter item name" , text: $inputItemName)
                }.textCase(nil)
                Section(header: Text("quantity : ").font(.title3).fontWeight(.bold)){
                    TextField("Enter item quantity" , text: $inputQuantity)
                }.textCase(nil)
                Section(header: Text("price : ").font(.title3).fontWeight(.bold)){
                    TextField("Enter item price" , text: $inputItemPrice)
                }.textCase(nil)
                
            }
            .navigationTitle("Add new item")
            .navigationBarItems(trailing: Button(action : {AddItem()}){Text("Add").foregroundColor(.white).frame(width: 60, height: 30, alignment: .center).background(Color.blue).cornerRadius(7.0)})
        }
        .sheet(isPresented: $showImagePicker , onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
    }
}
