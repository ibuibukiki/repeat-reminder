//
//  TaskAddEditView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/14.
//

import SwiftUI

struct TaskAddEditView: View {
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        ZStack(alignment:.top){
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("タスクを追加")
                    .foregroundColor(Color("MainColor"))
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width:328,height:56,alignment:.leading)
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
                    .background(Color("BackgroundColor"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("MainColor"), lineWidth: 4)
                    )
                    .compositingGroup()
                    .shadow(color:.gray,radius:5,x:0,y:8)
                    .padding(.bottom,8)
                Spacer()
                // ボタンを表示
                HStack(spacing:24){
                    Button(action:{
                        self.presentation.wrappedValue.dismiss()
                        print("tap cancel button")
                    }){
                        Text("キャンセル")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(Color("MainColor"))
                            .frame(width:152,height:56)
                            .background(Color("BackgroundColor"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MainColor"), lineWidth: 4)
                            )
                            .compositingGroup()
                            .shadow(color:.gray,radius:5,x:0,y:8)
                    }
                    Button(action:{
                        self.presentation.wrappedValue.dismiss()
                        print("tap add button")
                    }){
                        Text("追 加")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(Color("BackgroundColor"))
                            .frame(width:152,height:56)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                            .compositingGroup()
                            .shadow(color:.gray,radius:5,x:0,y:8)
                    }
                }
                Spacer()
                // 削除ボタン(編集時のみ表示)
                Button(action:{
                    print("tap delete button")
                }){
                    Text("このタスクを削除")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(Color("ButtonColor"))
                        .frame(width:200,height:40)
                }.padding(.bottom,24)
            }.padding(.top,24)
        }
    }
}

#Preview {
    TaskAddEditView()
}
