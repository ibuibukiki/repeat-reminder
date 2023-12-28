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
    @State private var isShowedCompletedAlert = false
    @State private var isShowedDeletedAlert = false
    @State private var isShowedAlert = false
    
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
                                                    isShowedCompletedAlert = true
                                                } label: {
                                                    Image(systemName:"checkmark.gobackward")
                                                        .foregroundColor(Color("ButtonColor"))
                                                        .font(.system(size:48))
                                                }
                                                .alert("このタスクを\n完了前に戻しますか？\n"+task.name, isPresented: $isShowedCompletedAlert) {
                                                    Button("キャンセル",role:.cancel) {
                                                        isShowedCompletedAlert = false
                                                    }
                                                    Button("OK") {
                                                        isShowedCompletedAlert = false
                                                        viewModel.notCompletedTask(task: task)
                                                    }
                                                }
                                                : Button {
                                                    print("tap not delete button")
                                                    isShowedDeletedAlert = true
                                                } label: {
                                                    Image(systemName:"trash.slash.circle")
                                                        .foregroundColor(Color("ButtonColor"))
                                                        .font(.system(size:48))
                                                }
                                                .alert("このタスクを\n復元しますか？\n"+task.name, isPresented: $isShowedDeletedAlert) {
                                                    Button("キャンセル",role:.cancel) {
                                                        isShowedDeletedAlert = false
                                                    }
                                                    Button("OK") {
                                                        isShowedDeletedAlert = false
                                                        viewModel.notDeletedTask(task: task)
                                                    }
                                                }
                                    Button {
                                        print("tap completely delete button")
                                        isShowedAlert = true
                                    } label: {
                                        Image(systemName:"trash.circle.fill")
                                            .foregroundColor(Color("ButtonColor"))
                                            .font(.system(size:48))
                                    }.alert("このタスクを\n完全に消去しますか？\n"+task.name, isPresented: $isShowedAlert) {
                                        Button("キャンセル",role:.cancel) {
                                            isShowedAlert = false
                                        }
                                        Button("OK") {
                                            isShowedAlert = false
                                            viewModel.completelydeletedTask(taskId: task.taskId)
                                        }
                                    } message: {
                                        Text("一度消去すると復元できません")
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
