//
//  TaskCell.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskCell: View {
    var body: some View {
        HStack{
            // タスクの情報を表示
            HStack{
                Text(" 1")
                    .foregroundColor(Color("BackgroundColor"))
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.top,20)
                    .padding(.bottom,12)
                    .padding(.leading,12)
                Text("日後")
                    .foregroundColor(Color("BackgroundColor"))
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding(.top,24)
                    .padding(.bottom,4)
                VStack(spacing:16){
                    Text("レポート提出")
                    Text("10月10日 14:00")
                }.foregroundColor(Color("TextColor"))
                .frame(width:160,height:88)
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
            }.frame(width:264,height:96)
            .background(Color("MainColor"))
            .cornerRadius(15)
            .compositingGroup()
            .shadow(color:.gray,radius:5,x:0,y:5)
            .padding(.bottom,16)
        }
    }
}

#Preview {
    TaskListView()
}
