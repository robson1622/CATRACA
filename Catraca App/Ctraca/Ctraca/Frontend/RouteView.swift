//
//  RouteView.swift
//  Ctraca
//
//  Created by Wendell Borges on 22/02/25.

import SwiftUI

struct RouteView: View {
    @Binding var showTrip : Bool
    @Binding var routeResponse : RouteModel?
    let route : RouteModel
    var body: some View {
        VStack(spacing:10){
            ZStack{
                TextModelsViews(text: "Trip", fontType: .title)
                HStack{
                    BackButton(onTap: {
                        showTrip = false
                    })
                    Spacer()
                }
            }
            .padding(.vertical,24)
            
            HStack{
                TextModelsViews(text: "LOCATION",fontType:.divider)
                Spacer()
            }
            HStack(alignment:.bottom){
                Image(systemName: "square.and.arrow.up")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: route.out.local, fontType: .largeTextBold)
                Spacer()
            }
            HStack(alignment:.bottom){
                Image(systemName: "square.and.arrow.down")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: route.finish.local, fontType: .largeTextBold)
                Spacer()
            }
            HStack(alignment:.bottom){
                Image(systemName: "calendar")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: route.date.formatDate(), fontType: .largeTextBold)
                Spacer()
            }
            HStack{
                TextModelsViews(text: "METRICS",fontType:.divider)
                Spacer()
            }
            .padding(.top,24)
            metrics
            Spacer()
            buttons
                .padding(.bottom,60)
        }
        .padding(.horizontal,24)
        .padding(.bottom,24)
    }
    
    var metrics : some View{
        VStack{
            MetricsCard(primary: true, title: "ESTIMATED TIME", value: "\(route.duration.toHMS())", style: .time)
            MetricsCard(primary: false, title: "DISTANCE", value: "\(String(format: "%.0f",route.distance)) m", style: .distance)
        }
    }
    
    var buttons : some View{
        VStack{
            PlayButton(text: "Make this route", onTap: {
                routeResponse = route
                showTrip = false
            })
            DeleteButton(text: "Delete", onTap: {
                
            }, disabled: true)
        }
    }
}

#Preview {
    RouteView(showTrip: .constant(true),routeResponse:.constant(exempleOfRoute),route: exempleOfRoute)
}
