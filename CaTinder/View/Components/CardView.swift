import SwiftUI
import UIKit
struct CardView: View {
    
    var urlImg: String
    @State var dataImg: UIImage?
      
    
    
    
    func getImg(urlImg: String) {
        if let url = URL(string: urlImg) {
            let request = URLRequest(url:url)
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    if let tmp = UIImage(data: data) {
                        self.dataImg = tmp
                    } else {
                        print("baduiimage")
                    }
                }
            }.resume()
        } else {
            print("bad url")
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                if let img = dataImg {
                    Image(uiImage: img).renderingMode(.original).resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .clipped()
                }
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Le Chat").foregroundColor(.black).font(.title)
                        Text("Miaouh").foregroundColor(.black).font(.subheadline)
                    }
                }.padding(10)
                
            }.onAppear(perform: {
                getImg(urlImg: urlImg)
            }) .padding(.bottom).background(Color.white).cornerRadius(10).shadow(radius: 5 )
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(urlImg: "https://cdn2.thecatapi.com/images/bli.jpg")
    }
}

