//
//  Home.swift
//  UI-316 (iOS)
//
//  Created by nyannyan0328 on 2021/09/24.
//

import SwiftUI
import WebKit

struct Home: View {
    @Environment(\.colorScheme) var scheme
    
    @State var tabs : [Tab] = [
    
        .init(tabURL: "https://www.apple.com/jp/?afid=p238%7CsKSMckWTz-dc_mtid_18707vxu38484_pcrid_547417605265_pgrid_13140806301_&cid=aos-jp-kwgo-brand--slid---product--you"),
      .init(tabURL: "https://www.youtube.com")
        
    
    ]
    var body: some View {
        ZStack{
            
            GeometryReader{proxy in
                
                
                let size = proxy.size
                
                Image("BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(0)
                
            }
            .overlay(.ultraThinMaterial)
            .overlay((scheme == .dark ? Color.black : Color.white).opacity(0.03))
            .ignoresSafeArea()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                
                let columns = Array(repeating: GridItem(.flexible(),spacing: 18), count: 2)
                
                
                
                LazyVGrid(columns: columns, spacing:15) {
                    
                    
                    ForEach(tabs){tab in
                        
                        CardView(tab: tab, tabs: $tabs)
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                .padding()
                
                
            }
            .safeAreaInset(edge: .bottom) {
                
                HStack{
                    
                    Button {
                        
                        withAnimation{
                            
                            tabs.append(Tab(tabURL: urls.randomElement() ?? ""))
                            
                        }
                        
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title.bold())
                           
                            
                    }
                    
                    Spacer()
                    
                    
                    Button {
                        
                    } label: {
                        
                        Text("DONE")
                            .fontWeight(.bold)
                          
                        
                        
                    }
                                        
                }
                .overlay(
                
                
                
                    Button(action: {
                        
                    }, label: {
                        
                        HStack{
                            
                            Text("Private")
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.primary)
                        
                        
                    })
                )
                .padding([.horizontal,.top])
                .padding(.bottom,10)
                .background(
                
                    scheme == .dark ? Color.black : Color.white
                
                )
                
                
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}


struct CardView : View{
    
    var tab : Tab
    
    @State var tabTitle = ""
    @Binding var tabs : [Tab]
    
    @State var offset : CGFloat = 0
    @GestureState var isDragging = false
    var body: some View{
        
        VStack(spacing:10){
            
            WebView(tab: tab){title in
                
                self.tabTitle = title
            }
            .frame(height: 250)
            .overlay(Color.black.opacity(0.03))
            .cornerRadius(10)
            .overlay(
            
                Button(action: {
                    
                    withAnimation{
                        
                        offset = -(getRect().width + 250)
                        
                       removeTab()
                    }
                    
                }, label: {
                    
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(.ultraThinMaterial,in: Circle())
                })
                    .padding(10)
                
                ,alignment: .topTrailing
            
            )
        
            
            Text(tabTitle)
                .font(.title3.weight(.thin))
                .foregroundColor(.orange)
                .lineLimit(1)
                .frame(height: 50)
            
            
            
        }
        .contentShape(Rectangle())
        .offset(x: offset)
      
        .gesture(
        
            DragGesture().updating($isDragging, body: { _, out, _ in
                out = true
            })
                .onChanged({ value in
                    
                    if isDragging{
                        
                        let translation = value.translation.width
                        
                        offset = translation > 0 ? translation / 10 : translation
                        
                    }
                    
                })
                .onEnded({ value in
                    
                    let translation = value.translation.width > 0 ? 0 : -value.translation.width
                    
                    if getIndex() % 2 == 0{
                        
                        print("left")
                        withAnimation{
                            
                            
                            if translation > 0 {
                                
                                offset = -(getRect().width + 250)
                                
                                removeTab()
                                
                            }
                            
                            else{
                                
                                offset = 0
                            }
                            
                           
                        }
                    }
                    
                    else{
                        
                        
                      print("Right")
                        
                        
                        if translation > getRect().width - 150{
                            
                            offset = -(getRect().width + 250)
                            
                            removeTab()
                            
                            
                            
                        }
                        
                        else{
                            
                            offset = 0
                        }
                    }
                    
                    
                    
                    
                    
                    
                })
        
        )
        
    }
    
    func getIndex()->Int{
        
        let index = tabs.firstIndex { currentTab in
            
            
            return currentTab.id == tab.id
        } ?? 0
        
        return index
        
        
    }
    
    func removeTab(){
        
        tabs.removeAll { tab in
            return self.tab.id == tab.id
        }
        
        
        
    }
    
    
}


let urls : [String] = [

    "https:www.apple.com",
    "https:www.google.com",
    "https:www.microsoft.com",
    "https:www.kavsoft.dev",
    "https:www.youtube.com/ijustine",
    "https:www.gmail.com",


]

