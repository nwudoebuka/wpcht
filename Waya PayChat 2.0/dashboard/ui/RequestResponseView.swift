//
//  RequestResponseView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/11/21.
//

import SwiftUI

struct RequestResponseView : View {
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
        
    var body: some View{
        
        VStack{
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Image("success-checker-icon")
                .resizable()
                .padding(UIScreen.main.bounds.width * 0.111)
                .background(Color("alice-blue"))
                .clipShape(Circle())
                .frame(width: screenWidth * 0.444, height: screenWidth * 0.444)
            
            Text("Successful")
                .font(Font.custom("Lato-Regular", size: 24))
                .foregroundColor(Color("toolbar-color-secondary"))
                .padding(.top, 28)
            
            
            Text("N40,000 is being sent to")
                .font(Font.custom("Lato-Regular", size: 16))
                .foregroundColor(Color("toolbar-color-secondary"))
                .padding(.top, 22)
            
            Text("Stanley Toju")
                .font(Font.custom("Lato-Regular", size: 24))
                .foregroundColor(Color("toolbar-color-secondary"))
                .padding(.top, 2)
            
        
            
            PrimaryButtonView(title: "Finish", width: screenWidth * 0.83)
                .padding(.bottom, screenHeight * 0.118)
        }
    }
}


struct RequestResponseView_Preview : PreviewProvider{
    
    static var previews: some View{
        
        RequestResponseView()
    }
}
