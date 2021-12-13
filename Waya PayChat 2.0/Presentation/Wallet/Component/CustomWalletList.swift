//
//  CustomWalletList.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/12/21.
//

import SwiftUI

struct BankList: View {
    
    @Binding var bankRequests : [AddBankRequest]

    
    var body: some View {
        
        VStack{
            ScrollView(.vertical){
                
                VStack{
                    
                    if(bankRequests.count > 0){
                        ForEach(0...bankRequests.count-1, id: \.self){  i in 
                            CustomWalletCell(image: UIImage(), value: "***  " + String(bankRequests[i].accountNumber.dropFirst(5)), date: bankRequests[i].bankCode )
                                .padding(.top, 16)
                        }
                        
                    }
                }
                
            }
        }    }
}

struct CustomWalletList_Previews: PreviewProvider {
    static var previews: some View {
        BankList(bankRequests: .constant([AddBankRequest(accountName: "Dayo", accountNumber: String("2345078901".dropFirst(1)), bankName: "Guaranty", userId: "0", bankCode: "234", rubiesBankCode: "234")]))
    }
}

struct CustomWalletCell : View {
    
    var image : UIImage = UIImage(named: "bank-icon") ?? UIImage()
    var value : String
    var date : String
    
    var body: some View {
        
        HStack{
            
            Image("bank-icon")
                .resizable()
                .frame(width: 48, height: 48)
                .background(Color.white)
                .cornerRadius(10)
                .padding(16)
            
            VStack(alignment: .leading) {
                
                Text(value)
                    .font(Font.custom("Lato-Regular", size: 13))
                    .foregroundColor(Color("dark-gray"))  
                Text(date)
                    .font(Font.custom("Lato-Regular", size: 11))
                    .foregroundColor(Color("color-gray3")) 
                
                
            }
            
            Spacer()
            
            Image("forward-arrow-light")
                .frame(width: 24, height: 24)
                .padding(16)
            
        }
        .background(Color.white)
        .clipShape(Rectangle())
        .cornerRadius(14)
        .padding(.horizontal, 16)
            .shadow(radius: 1)
    }
}
