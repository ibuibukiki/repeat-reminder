//
//  TaskAddEditView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/14.
//

import SwiftUI

struct TaskAddEditView: View {
    var body: some View {
        ZStack(alignment:.top){
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("タスクを追加")
                    .foregroundColor(Color("MainColor"))
                    .fontWeight(.bold)
                    .font(.title)
                VStack(alignment:.leading,spacing:24){
                    // タスクの情報を表示・入力
                    Text("基本設定")
                        .foregroundColor(Color("MainColor"))
                        .fontWeight(.bold)
                        .font(.title2)
                    HStack{
                        Text("名前")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                    HStack{
                        Text("期限")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                    // 通知関係の情報を表示・入力
                    Text("通知設定")
                        .foregroundColor(Color("MainColor"))
                        .fontWeight(.bold)
                        .font(.title2)
                    HStack{
                        Text("期限通知")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                    HStack{
                        Text("事前通知")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                    HStack{
                        Text("最初の通知")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                    HStack{
                        Text("通知間隔")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                    }.padding(.leading,24)
                }.padding(.top,40)
                    .padding(.bottom,48)
                    .padding(.leading,24)
                    .frame(width:320,height:400,alignment:.leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("MainColor"), lineWidth: 4)
                    )
            }.padding(.top,40)
        }
    }
}

#Preview {
    TaskAddEditView()
}
