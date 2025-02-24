//
//  TripView.swift
//  Ctraca
//
//  Created by Wendell Borges on 21/02/25.
//

import SwiftUI

struct TripView: View {
    @Binding var showTrip : Bool
    @Binding var routeResponse : RouteModel?
    let trip : TripModel
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
            .padding(24)
            
            HStack{
                TextModelsViews(text: "LOCATION",fontType:.divider)
                Spacer()
            }
            HStack{
                Image(systemName: "square.and.arrow.up")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: trip.startLocal.local, fontType: .largeTextBold)
                Spacer()
            }
            HStack{
                Image(systemName: "square.and.arrow.down")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: trip.endLocal.local, fontType: .largeTextBold)
                Spacer()
            }
            HStack{
                Image(systemName: "calendar")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: trip.startDate.formatDate(), fontType: .largeTextBold)
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
            let duration = trip.endDate.timeIntervalSince(trip.startDate)
            MetricsCard(primary: true, title: "DURATION", value: "\( duration.toHourAndMinuteString())", style: .time)
            MetricsCard(primary: false, title: "DISTANCE", value: "\(trip.distance / 1000) km", style: .distance)
            MetricsCard(primary: false, title: "AVERAGE", value: "\(trip.averageSpeed()) km/h", style: .average)
            MetricsCard(primary: false, title: "MAX SPEED", value: "\(trip.maxSpeed) km/h", style: .maxspeed)
        }
    }
    
    var buttons : some View{
        VStack{
            PlayButton(text: "Make this trip again", onTap: {
                routeResponse = trip.toRoute()
                showTrip = false
            })
            DeleteButton(text: "Delete", onTap: {
                
            }, disabled: true)
        }
    }
}

#Preview {
    TripView(showTrip: .constant(true),routeResponse: .constant(exempleOfRoute),trip: exempleOfTrip)
}
