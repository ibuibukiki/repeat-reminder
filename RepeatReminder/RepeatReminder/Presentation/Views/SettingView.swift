//
//  SettingView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        ZStack(alignment:.top){
            Color("BackgroundColor")
                .ignoresSafeArea(.all)
            VStack(alignment:.leading,spacing:16){
                Text("設定")
                    .foregroundColor(Color("MainColor"))
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width:328,height:56,alignment:.leading)
                Button {
                    
                } label: {
                    Text("完了したタスクの復元")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }
                Button {
                    
                } label: {
                    Text("削除したタスクの復元")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }
                Button {
                    
                } label: {
                    Text("キャッシュの削除")
                        .frame(width:320,height:48)
                        .foregroundColor(Color("TextColor"))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MainColor"), lineWidth: 4)
                        )
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:4)
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
