//
//  Detail.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI
import Kingfisher

struct Detail: View {
    var post: Post
    @StateObject var vm : DetailViewModel
    @State var comment : String = ""
    @Environment (\.presentationMode) var presentationMode
    
    init(post: Post){
        self.post = post
        _vm = StateObject(wrappedValue: DetailViewModel(post: post, userUid: post.authorUid))
    }
    
    
    var body: some View {
        ZStack{
            Color("bg").ignoresSafeArea()
            
            VStack(spacing:0){
                
                ScrollView {
                    
                    headerImage
                    VStack(alignment: .leading, spacing: 0){
                        postInfo
                        Text(post.aciklama)
                            .font(.footnote)
                        postDetail
                        comments
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                .padding(.horizontal)
                }
                Spacer()
            }.edgesIgnoringSafeArea(.bottom)
            headerButtons
        }
    }
}

//struct Detail_Previews: PreviewProvider {
//    static var previews: some View {
//        Detail()
//    }
//}


extension Detail{
    
    private var headerButtons: some View {
        ZStack{
            VStack {
                HStack{
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 31, height: 31)
                        .background(Color("main"), in: Circle())
                    Spacer()
                    VStack{
                        Image(systemName: (vm.favlist.firstIndex(where: {$0.id == post.id}) != nil ? "heart.fill" : "heart" ) )
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 31, height: 31)
                            .background(Color("main"), in: Circle())
                            
                    }
                    .onTapGesture {
                        vm.addFavList(post: post)
                    }
                    
                }
                .padding()
                Spacer()
            }

        }
    }
    
    private var headerImage: some View {
        VStack {
            ZStack{
                Circle()
                    .fill(Color("main"))
                    .frame(width: 240, height: 240)
                    .scaleEffect(2)
                    .offset(x: 20,y:-140)
//                            Circle()
//                                .frame(width: 240, height: 240)
//                                .scaleEffect(2)
//                                .offset(y:-150)

                
                KFImage(URL(string: post.imageUrl)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 240)
                    .clipShape(Circle())
                    .scaleEffect(2)
                    .offset(y:-150)


            }
        }.padding(.bottom,20)
    }
    
    private var postInfo: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text(post.ad)
                    .font(.title2.bold())
                Text("\(vm.user?.ad ?? "") \(vm.user?.soyad ?? "") \(post.timeStamp.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .omitted))")
                    .font(.footnote)
                    .foregroundColor(Color("secondary"))

            }
            HStack(spacing:0){
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(Color("star"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)

        }
    }
    
    private var comments: some View {
        VStack(alignment: .leading){
            Text("Yorumlar")
                .font(.headline)
                .fontWeight(.semibold)
            VStack(spacing: 0){
                    TextEditor(text: $comment)
                Divider()
                HStack(alignment: .center){
                        Spacer()
                        Button {
                            vm.addComment(post: post, comment: comment)
                        } label: {
                            Text("Yorum Yap")
                                .foregroundColor(Color("main"))
                        }.padding()
                        .disabled(comment == "")
                    Spacer()
                    }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            VStack{
                ForEach(vm.comments) { comment in
                    VStack(alignment: .leading){
                        Text("Anonim").font(.headline)
                        Text(comment.comment)
                            .font(.caption2).foregroundColor(Color("secondary"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                        Divider()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            
        }.padding(.vertical)

    }
    
    private var postDetail: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 3){
                Text("Malzemeler")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(post.malzeme)
                    .font(.footnote)
                    .foregroundColor(Color("secondary"))
            }.padding(.vertical)
            VStack(alignment: .leading, spacing: 3){
                Text("Tarif")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(post.tarif)
                    .font(.footnote)
                    .foregroundColor(Color("secondary"))
            }.padding(.vertical)
            VStack(alignment: .leading){
                Text("Mutfaklar")
                    .font(.headline)
                    .fontWeight(.semibold)
                HStack{
                    ForEach(post.mutfaklar, id: \.self) { gelen in
                        Text(gelen)
                            .foregroundColor(.white)
                            .frame(width: 85, height: 25)
                            .background(Color("main"), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                    }
                }
            }.padding(.vertical)

        }
    }
}
