//
//  UpdateProfile.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/4/21.
//

import SwiftUI

struct UpdateProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var firstName : String = "Ola"
    @State var profileViewModel = ProfileViewModel()
    
    let userDefault = UserDefaults.standard
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var user: FetchedResults<User>
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Cancel")
                        .font(Font.custom("Lato-Regular", size: 16))
                        .foregroundColor(Color("tab-item-selected-color"))
                })
                
                Spacer()
                
                Text("Upload profile")
                    .font(Font.custom("Lato-Regular", size: 18))
                    .foregroundColor(Color("dark-gray"))
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Save")
                        .font(Font.custom("Lato-Regular", size: 16))
                        .foregroundColor(Color("tab-item-selected-color"))
                })
                
            }.padding(.horizontal, 20) 
            
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    Image("profile-placeholder")
                        .resizable()
                        .frame(width: 80, height: 80
                               , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.top, 32)
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Upload profile Image")
                            .font(Font.custom("Lato-Regular", size: 16))
                            .foregroundColor(Color("dark-gray"))
                    }).padding(.top, 12)

                    
                    Text("Acct Number; 0092112382")
                        .font(Font.custom("Lato-Regular", size: 16))
                        .foregroundColor(Color("dark-gray"))
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading){
                        CustomTextField(placeholder: "First Name", value: $profileViewModel.updateProfileReq.firstName)
                        
                        CustomTextField(placeholder: "Middle Name", value: $profileViewModel.updateProfileReq.middleName) 
                        
                        CustomTextField(placeholder: "Surname", value: $profileViewModel.updateProfileReq.surname) 
                        
                        CustomTextField(placeholder: "Date of Birth", value: $profileViewModel.updateProfileReq.dateOfBirth)  
                        
                        CustomTextField(placeholder: "Gender", value: $profileViewModel.updateProfileReq.gender) 
                        
                        Text("Contact Details")
                            .font(Font.custom("Lato-Regular", size: 18))
                            .foregroundColor(Color("dark-gray"))
                            .padding(.vertical, 20)
                        
                        CustomTextField(placeholder: "Email", value: $profileViewModel.updateProfileReq.email)
                        
                        CustomTextField(placeholder: "Phone Number", value: $profileViewModel.updateProfileReq.phoneNumber) 
                        
                        CustomTextField(placeholder: "District/State", value: $profileViewModel.updateProfileReq.district) 
                        
                        CustomTextField(placeholder: "Address", value: $profileViewModel.updateProfileReq.address)
                        
                    }.padding(.horizontal, 20) 
                    .padding(.top, 24)
                }
            }
        
        }
    }
    
    func preFillData(){
        if(user != nil && user[0] != nil){
            profileViewModel.updateProfileReq.firstName = user[0].name ?? ""
            profileViewModel.updateProfileReq.surname = user[0].userSurname ?? ""
            profileViewModel.updateProfileReq.email = user[0].userEmail ?? ""
            profileViewModel.updateProfileReq.phoneNumber = ""
            
            
            
        }
    }
}

struct UpdateProfile_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}
