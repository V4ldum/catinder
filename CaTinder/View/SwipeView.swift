import SwiftUI

struct SwipeView: View {
    
    @State var results = [TaskEntry]()
    @State private var translation: CGSize = .zero
    @State var op: Double = 1
    
    func callApi() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            print("Your api end point is invalid")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([TaskEntry].self, from: data)
                    DispatchQueue.main.async {
                        self.results = response
                    }
                } catch let error{
                    print(error)
                }
            }
        }.resume()
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    ForEach(results, id: \.id) { item in
                        CardView(urlImg: item.url)
                    }
                }
                .offset(x: self.translation.width, y: self.translation.height)
                .opacity(self.op)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            self.op = 1 - Double(abs(value.translation.width) / 100.0)
                        }.onEnded { value in
                            callApi()
                            self.translation = .zero
                            
                        })
                        
                HStack {
                    Button(action: {
                        withAnimation {
                            self.translation = CGSize(width: -100, height:0)
                            self.op = 0
                        }
                        callApi()
                        
                        
                    }) {
                        Image(systemName: "cross.fill").resizable().frame(width: 50, height: 50).foregroundColor(Color.red).rotationEffect(.degrees(45))
                    }.padding(50).cornerRadius(45).shadow(radius: 5)
                    
                    Button(action: {
                        withAnimation {
                            self.translation = CGSize(width: 100, height:0)
                            self.op = 0
                        }
                        callApi()
                    }) {
                        Image(systemName: "heart.fill").resizable().frame(width: 50, height: 50).foregroundColor(Color.green)
                    }.padding(50).shadow(radius: 5 ).cornerRadius(45)
                }
            }.onAppear(perform: {
                callApi()
            }).padding(10)
            .onChange(of: results, perform: { value in
                withAnimation {
                    self.translation = CGSize(width: 0, height:0)
                    self.op = 1
                }
            })
        }
        
        
        
    }


    

}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView()
    }
}
