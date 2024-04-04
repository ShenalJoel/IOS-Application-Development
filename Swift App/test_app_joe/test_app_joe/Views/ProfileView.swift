import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userAuth: UserAuth

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        if !userAuth.isUserLoggedIn {
                            NavigationLink(destination: LoginView()) {
                                Text("SIGN IN / REGISTER >")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                            }
                        } else {
                            Text("Hi, \(userAuth.username)")
                                .font(.system(size: 20))
                                .bold()
                        }

                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(.black)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(20)

                    // My Orders Section
                     MyOrdersView(userAuth: userAuth)
                        .padding(.horizontal)
                    
                    Spacer()

                    // You May Also Like Section
                    YouMayAlsoLikeView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
