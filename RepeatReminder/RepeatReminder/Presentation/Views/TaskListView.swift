//
//  TaskListView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskListView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            // 今日までのタスクを表示
            VStack{
                VStack{
                    Text("今日までのタスク")
                        .foregroundColor(Color("BackgroundColor"))
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.top,20)
                        .padding(.bottom,8)
                    VStack{
                        Text("・レポート提出")
                            .font(.title3)
                    }.foregroundColor(Color("TextColor"))
                        .padding()
                        .frame(width:296,height:152,alignment:.topLeading)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                }.frame(width:328,height:232,alignment:.top)
                    .background(Color("MainColor"))
                    .cornerRadius(15)
                    .compositingGroup()
                    .shadow(color:.gray,radius:5,x:0,y:10)
            }
        }
    }
}

#Preview {
    TaskListView()
}
