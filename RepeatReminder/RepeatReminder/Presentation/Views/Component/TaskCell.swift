//
//  TaskCell.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskCell: View {
    var body: some View {
        HStack(spacing:8){
            // タスクの情報を表示
            HStack{
                HStack{
                    Text("1")
                        .font(.largeTitle)
                        .padding(.top,20)
                        .padding(.bottom,12)
                    Text("日後")
                        .font(.title2)
                        .padding(.top,24)
                        .padding(.bottom,4)
                }
                .foregroundColor(Color("BackgroundColor"))
                .fontWeight(.bold)
                .padding(.leading,4)
                .frame(width:96)
                VStack(spacing:16){
                    Text("レポート提出")
                    Text("10月10日 14:00")
                }.foregroundColor(Color("TextColor"))
                    .frame(width:160,height:88)
                    .background(Color("BackgroundColor"))
                    .cornerRadius(10)
            }.frame(width:272,height:96)
                .background(Color("MainColor"))
                .cornerRadius(15)
                .compositingGroup()
                .shadow(color:.gray,radius:5,x:0,y:8)
            // ボタンを表示
            VStack(spacing:4){
                NavigationLink(destination: TaskAddEditView()){
                    Image(systemName:"pencil.circle")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.system(size:48))
                }
                Button(action:{
                    print("tap clear button")
                }){
                    Image(systemName:"checkmark.circle.fill")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.system(size:48))
                }
            }
        }.padding(.bottom,8)
    }
}

#Preview {
    TaskListView()
}
