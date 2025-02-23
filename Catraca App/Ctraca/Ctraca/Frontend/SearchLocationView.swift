//
//  SearchView.swift
//  Ctraca
//
//  Created by Robson Borges on 09/11/24.
//

import SwiftUI

struct SearchLocationView: View {
    @Binding var local : LocationModel?
    @Binding var route : RouteModel?
    @State var searchTextDestination: String = ""
    @State var searchTextMyPosition: String = "My position"
    @State var myPosition : LocationModel?
    
    @Binding var stateOfLoading: StatesOfLoad
    @State var success : Bool? = nil
    @State var showAlert : Bool = false
    
    let textPlaceholder = "Search for a location"
    let textOfError = "Something went wrong, please try again later"
    let textOfSuccess = "Location found"
    var body: some View {
        if route == nil{
            search
        }
        else{
            
        }
    }
    
    var search: some View{
        ScrollView {
            VStack(spacing:14){
                HStack{
                    Text("DESTINATION")
                        .font(.headline)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.gray)
                    TextField(textPlaceholder, text: $searchTextDestination)
                        .foregroundStyle(Color.branco)
                }
                .padding()
                .background(Color.preto3)
                .cornerRadius(16)
                
                HStack{
                    Text("FROM")
                        .font(.headline)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.gray)
                    TextField(textPlaceholder, text: $searchTextMyPosition)
                        .foregroundStyle(Color.branco)
                }
                .padding()
                .background(Color.preto3)
                .cornerRadius(16)
                
                VStack{
                    AlertView(show: $showAlert,text: ( success ?? false)  ? textOfSuccess : textOfError,success: success ?? false)
                }
                
                if success == nil{
                    PlayButton(text: "Calculate route", onTap: {
                        Task{
                            stateOfLoading = .loading
                            await self.calculateRoute()
                        }
                    },disabled: searchTextDestination.isEmpty)
                    .padding(.vertical,24)
                }
                else if success == false{
                    TryAgainButton(text: "Try again", onTap: {
                        Task{
                            stateOfLoading = .loading
                            await self.calculateRoute()
                        }
                    },disabled: searchTextDestination.isEmpty)
                    .padding(.vertical,24)
                }
                else{
                    
                }
                
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func calculateRoute() async{
        success = true
        success = false
    }
}

#Preview {
    //SearchLocationView(local:.constant(exempleLocation),route: .constant(exempleOfRoute),stateOfLoading: .constant("Idle"))
    SearchLocationView(local:.constant(exempleLocation),route: .constant(nil),stateOfLoading: .constant(.loading))
}
