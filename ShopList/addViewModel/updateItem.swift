//
//  updateItem.swift
//  ShopList
//
//  Created by snoopy on 22/07/2021.
//

import SwiftUI

struct updateItem: View {
    
    @Environment(\.presentationMode) var presentation
    
    var viewContext = PersistenceController.shared.container.viewContext
    
    @State var item : FetchedResults<ItemInfo>.Element
    
    @State var list : FetchedResults<ListInfo>.Element
    
    @State var updatedQuantity : String = ""
    @State var updatedPrice : String = ""
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    
    //MARK:-FUNCTION
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    
    private func updateData(){
        item.itemImage = (image != nil) ? inputImage?.jpegData(compressionQuality: 1.0) : item.itemImage
        item.itemQuantity = (!updatedQuantity.isEmpty) ? updatedQuantity : item.itemQuantity
        item.itemPrice = (!updatedPrice.isEmpty) ? updatedPrice : item.itemPrice
        
        do{
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Unresolved error : \(error)")
        }
        
        presentation.wrappedValue.dismiss()
    }
    
    //MARK:- VIEW
    var body: some View {
        NavigationView{
        Form{
            VStack{
                
                if (image == nil){
                    Button(action: { self.showImagePicker.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .cornerRadius(7.0)
                            .frame(width: 50, height: 50)
                            .onTapGesture { self.showImagePicker.toggle() }
                    }
                }
                else{
                    image!
                        .resizable()
                        .cornerRadius(7.0)
                        .frame(width: 310, height: 270)
                        .onTapGesture { self.showImagePicker.toggle() }
                }
                
            }.frame(width: 310, height: 270, alignment: .center)
            
            Section(header: Text("Quantity : \(self.item.itemQuantity)").font(.title3).fontWeight(.bold)){
                TextField("\(self.item.itemQuantity)" , text : $updatedQuantity)
            }
            Section(header: Text("Price : \(self.item.itemPrice)").font(.title3).fontWeight(.bold)){
                TextField("\(self.item.itemPrice)" , text : $updatedPrice)
            }
            
        }
        .navigationBarTitle(self.item.itemName ?? "unknown" , displayMode: .inline)
        .navigationBarItems(leading: Button(action: { presentation.wrappedValue.dismiss()})
            { Text("Cancel") }, trailing: Button(action: { updateData()}){
                Text("Save") })
        }
        
        .sheet(isPresented: $showImagePicker , onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
    }
}

