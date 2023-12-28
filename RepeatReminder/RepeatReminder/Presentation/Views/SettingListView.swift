//
//  SettingListView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import SwiftUI

struct SettingListView: View {
    let isCompleted: Bool
    
    @ObservedObject var viewModel = SettingListViewModel()
    
    init(isCompleted: Bool){
        self.isCompleted = isCompleted
    }
    
    var body: some View {
        ZStack(alignment:.top){
            Color("BackgroundColor")
                .ignoresSafeArea(.all)
            VStack(alignment:.leading,spacing:16){
                Text(isCompleted ? "過去に完了したタスク" : "過去に削除したタスク")
                    .foregroundColor(Color("MainColor"))
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width:328,height:56,alignment:.leading)
                ScrollView{
                    VStack(spacing:8){
                        ForEach((isCompleted ? viewModel.completedTasks
                                 : viewModel.deletedTasks).indices, id: \.self) { index in
                            let task = isCompleted ? viewModel.completedTasks[index]
                            : viewModel.deletedTasks[index]
                            HStack(spacing:4){
                                // タスクの情報を表示
                                TaskCell(task:task)
                                // ボタンを表示
                                VStack(spacing:4){
                                    isCompleted ? Button {
                                                    print("tap not complete button")
                                                } label: {
                                                    Image(systemName:"checkmark.gobackward")
                                                        .foregroundColor(Color("ButtonColor"))
                                                        .font(.system(size:48))
                                                }
                                                : Button {
                                                    print("tap not delete button")
                                                } label: {
                                                    Image(systemName:"trash.slash.circle")
                                                        .foregroundColor(Color("ButtonColor"))
                                                        .font(.system(size:48))
                                                }
                                    Button {
                                        print("tap completely delete button")
                                    } label: {
                                        Image(systemName:"trash.circle.fill")
                                            .foregroundColor(Color("ButtonColor"))
                                            .font(.system(size:48))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
