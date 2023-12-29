//
//  SettingButton.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/29.
//

import SwiftUI

struct SettingButton: View {
    var isCompleted: Bool
    var task: Task
    var viewModel: SettingListViewModel
    
    @State private var isShowedCompletedAlert = false
    @State private var isShowedDeletedAlert = false
    @State private var isShowedAlert = false
    
    var body: some View {
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
