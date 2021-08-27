//
//  ContentView.swift
//  ShopList
//
//  Created by snoopy on 18/07/2021.
//

import SwiftUI
import Network

struct homeView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ListInfo.listDate, ascending: false)])

    private var lists : FetchedResults<ListInfo>
    
    @State private var inputListName = ""
    
    @State private var add :  Bool = false
    
    @State private var cloudStatus : String = ""
    
    //MARK:- FUNCTION
    private func deleteList(offsets : IndexSet){
            
            offsets.map {lists[$0]}.forEach(viewContext.delete)
            
            do{ try viewContext.save() }
            catch{
                let error = error as NSError
                fatalError("Unresolved error : \(error)")
            }
    }
    
    //MARK:-VIEW
    var body: some View {
        NavigationView{
            List{
                Section(header: HStack{
                    Text("iCloud").font(.title3).fontWeight(.bold)
                    Image(systemName: cloudStatus).resizable().frame(width: 25, height: 18, alignment: .center)
                }){
                    withAnimation{

                        ForEach(lists) { List in
                            
                            NavigationLink(destination : itemlistView(list: List)){

                                HStack{
                                    
                                    Image(systemName : "circle")
                                        .resizable()
                                        .frame(width: 16, height: 16, alignment: .center)
                                        
                                    
                                    Text(List.listName ?? "No item name")
                                    
                                }.padding(8)
                                
                            }
                            
                        }.onDelete(perform: deleteList)
                        
                    }
                    
                }.textCase(nil)
            }
            .navigationTitle("Shop List")
            
            .navigationBarItems(trailing: Button(action: { self.add.toggle() }) {
                
                Image(systemName: "text.badge.plus")
                    .resizable()
                    .frame(width: 27, height: 23, alignment: .center)
                
            })
        }
        .sheet(isPresented: $add) { addList() }
        .onAppear(){
            let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
                    let queue = DispatchQueue.global(qos: .background)
                    monitor.start(queue: queue)
                    monitor.pathUpdateHandler = { path in
                        if path.status == .satisfied {
                            cloudStatus = "link.icloud.fill"
                        }else{
                            cloudStatus = "link.icloud"
                        }
                    }
        }
    }
    
}
