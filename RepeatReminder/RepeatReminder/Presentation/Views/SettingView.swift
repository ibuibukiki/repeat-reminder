//
//  SettingView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import SwiftUI

struct SettingView: View {
    @State private var isShowedAlert = false
    @ObservedObject var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack(alignment:.top){
            Color("BackgroundColor")
                .ignoresSafeArea(.all)
            VStack(alignment:.leading,spacing:16){
                Text("設定")
                    .foregroundColor(Color("MainColor"))
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width:328,height:56,alignment:.leading)
                NavigationLink(
                    destination: SettingListView(isCompleted:true)
                ){
                    Text("完了したタスクの復元")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }
                NavigationLink(
                    destination: SettingListView(isCompleted:false)
                ){
                    Text("削除したタスクの復元")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }
                Button {
                    print("tap cash button")
                    isShowedAlert = true
                } label: {
                    Text("キャッシュの削除")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }.alert("過去に完了・削除した\nタスクのデータを\n消去しますか？", isPresented: $isShowedAlert) {
                    Button("消去",role:.destructive) {
                        isShowedAlert = false
                    }
                    Button("キャンセル",role:.cancel) {
                        isShowedAlert = false
                    }
                } message: {
                    Text("一度消去すると復元できません")
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
