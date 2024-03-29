//
//  TaskAddEditView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/14.
//

import SwiftUI

struct TaskAddEditView: View {
    let isEditing: Bool
    
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel = TaskAddEditViewModel()
    @State private var isShowedAlert = false
    @State private var isShowedCheck = false
    
    let nums = [1,2,3,4,5,6,7,8,9,10]
    let ranges = ["時間","日","週間"]
    
    init (isEditing:Bool,task:Task?) {
        self.isEditing = isEditing
        if task != nil {
            viewModel.setTask(task:task!)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment:.top){
                Color("BackgroundColor")
                    .ignoresSafeArea(.all)
                VStack{
                    if isEditing {
                        Text("タスクを編集")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.bold)
                            .font(.title)
                            .frame(width:328,height:56,alignment:.leading)
                    } else {
                        Text("タスクを追加")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.bold)
                            .font(.title)
                            .frame(width:328,height:56,alignment:.leading)
                    }
                    VStack(alignment:.leading,spacing:16){
                        // タスクの情報を表示・入力
                        Text("基本設定")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.bold)
                            .font(.title2)
                            .padding(.top,8)
                        HStack{
                            Text("名前")
                                .foregroundColor(Color("TextColor"))
                                .font(.title3)
                            Spacer()
                            TextField("タスクを入力",text:$viewModel.task.name)
                                .foregroundColor(Color("TextColor"))
                                .frame(width:120,height:4)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                        }.padding(.leading,16)
                            .padding(.trailing,24)
                        HStack{
                            Text("期限")
                                .foregroundColor(Color("TextColor"))
                                .font(.title3)
                            Spacer()
                            DatePicker("deadline",selection:$viewModel.task.deadline)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                                .labelsHidden()
                                .colorInvert()
                                .colorMultiply(Color("TextColor"))
                        }.padding(.leading,16)
                            .padding(.trailing,24)
                        // 通知関係の情報を表示・入力
                        Text("通知設定")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.bold)
                            .font(.title2)
                        HStack{
                            Text("期限通知")
                                .foregroundColor(Color("TextColor"))
                                .font(.title3)
                            Spacer()
                            Toggle("isLimitNotified",isOn:$viewModel.task.isLimitNotified)
                                .toggleStyle(SwitchToggleStyle(tint: Color("ButtonColor")))
                                .labelsHidden()
                        }.padding(.leading,16)
                            .padding(.trailing,32)
                        HStack{
                            Text("事前通知")
                                .foregroundColor(Color("TextColor"))
                                .font(.title3)
                            Spacer()
                            Toggle("isPreNotified",isOn:$viewModel.task.isPreNotified)
                                .toggleStyle(SwitchToggleStyle(tint: Color("ButtonColor")))
                                .labelsHidden()
                        }.padding(.leading,16)
                            .padding(.trailing,32)
                        HStack(spacing:0){
                            Text("最初の通知")
                                .foregroundColor(Color("TextColor")
                                    .opacity(viewModel.task.isPreNotified ? 1.0 : 0.25)
                                )
                                .font(.title3)
                            Spacer()
                            // 数字を選択
                            Picker("firstNotifiedNum",selection:$viewModel.selectedFirstNum,content:{
                                ForEach(nums, id:\.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            })
                            .pickerStyle(.menu)
                                .labelsHidden()
                                .tint(Color("TextColor"))
                                .disabled(!viewModel.task.isPreNotified)
                            // 時間日週を選択
                            Picker("firstNotifiedRange",selection:$viewModel.selectedFirstRange,content:{
                                ForEach(ranges, id:\.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }).pickerStyle(.menu)
                                .labelsHidden()
                                .tint(Color("TextColor"))
                                .disabled(!viewModel.task.isPreNotified)
                                .padding(.trailing,8)
                            Text("前")
                                .foregroundColor(Color("TextColor")
                                    .opacity(viewModel.task.isPreNotified ? 1.0 : 0.25)
                                )
                        }.padding(.leading,16)
                            .padding(.trailing,24)
                        HStack(spacing:0){
                            Text("通知間隔")
                                .foregroundColor(Color("TextColor")
                                    .opacity(viewModel.task.isPreNotified ? 1.0 : 0.25)
                                )
                                .font(.title3)
                            Spacer()
                            // 数字を選択
                            Picker("intervalNotifiedNum",selection:$viewModel.selectedIntervalNum,content:{
                                ForEach(nums, id:\.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }).pickerStyle(.menu)
                                .labelsHidden()
                                .tint(Color("TextColor"))
                                .disabled(!viewModel.task.isPreNotified)
                            // 時間日週を選択
                            Picker("intervalNotifiedRange",selection:$viewModel.selectedIntervalRange,content:{
                                ForEach(ranges, id:\.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }).pickerStyle(.menu)
                                .labelsHidden()
                                .tint(Color("TextColor"))
                                .disabled(!viewModel.task.isPreNotified)
                        }.padding(.leading,16)
                            .padding(.trailing,16)
                    }.padding(.top,40)
                        .padding(.bottom,48)
                        .padding(.leading,16)
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
                            print("tap add or edit button")
                            if viewModel.task.deadline < Date() {
                                isShowedCheck = true
                            } else {
                                self.presentation.wrappedValue.dismiss()
                                if isEditing {
                                    viewModel.updateTask()
                                } else {
                                    viewModel.addTask()
                                }
                            }
                        }){
                            if isEditing {
                                Text("保 存")
                                    .fontWeight(.bold)
                                    .font(.title2)
                                    .foregroundColor(Color("BackgroundColor"))
                                    .frame(width:152,height:56)
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(10)
                                    .compositingGroup()
                                    .shadow(color:.gray,radius:5,x:0,y:8)
                            } else {
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
                    }.alert("期限を過ぎています\nこのまま保存しますか？", isPresented: $isShowedCheck) {
                        Button("保存") {
                            isShowedCheck = false
                            self.presentation.wrappedValue.dismiss()
                            if isEditing {
                                viewModel.updateTask()
                            } else {
                                viewModel.addTask()
                            }
                        }
                        Button("キャンセル",role:.cancel) {
                            isShowedCheck = false
                        }
                    } message: {
                        Text("タスク一覧には表示されます")
                    }
                    Spacer()
                    if isEditing {
                        Button(action:{
                            print("tap delete button")
                            isShowedAlert = true
                        }){
                            Text("このタスクを削除")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(Color("ButtonColor"))
                                .frame(width:200,height:40)
                                .padding(.bottom,24)
                        }.alert("このタスクを削除しますか？", isPresented: $isShowedAlert) {
                            Button("削除",role:.destructive) {
                                isShowedAlert = false
                                viewModel.deleteTask()
                                self.presentation.wrappedValue.dismiss()
                            }
                            Button("キャンセル",role:.cancel) {
                                isShowedAlert = false
                            }
                        } message: {
                            Text("設定から復元できます")
                        }
                    }
                }
            }
        }
    }
}
