//
//  ClearButton.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/29.
//

import SwiftUI

struct ClearButton: View {
    var task: Task
    var viewModel: TaskListViewModel
    @State private var isShowedAlert = false
    
    var body: some View {
        VStack(spacing:4){
            NavigationLink(
                destination: TaskAddEditView(isEditing:true,task:task)
            ){
                Image(systemName:"pencil.circle")
                    .foregroundColor(Color("ButtonColor"))
                    .font(.system(size:48))
            }
            Button {
                print("tap complete button")
                isShowedAlert = true
            } label: {
                Image(systemName:"checkmark.circle.fill")
                    .foregroundColor(Color("ButtonColor"))
                    .font(.system(size:48))
            }
            .alert("このタスクを完了しますか？\n"+task.name, isPresented: $isShowedAlert) {
                Button("キャンセル",role:.cancel) {
                    isShowedAlert = false
                }
                Button("OK") {
                    isShowedAlert = false
                    viewModel.completeTask(task: task)
                }
            } message: {
                Text("設定から復元できます")
            }
        }
    }
}
