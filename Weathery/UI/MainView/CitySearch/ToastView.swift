//
//  ToastView.swift
//  Weathery
//
//  Created by Anna Filin on 03/03/2025.
//

import SwiftUI

struct ToastView: View {
    var toastText: String
    @Binding var showToast: Bool
    
    var body: some View {
        VStack {
                    if showToast { // ✅ Проверяем перед рендерингом
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 200, height: 50)
                            .overlay(
                                Text(toastText)
                                    .foregroundColor(.white)
                                    .font(.headline)
                            )
                            .transition(.opacity) // 🔥 Анимация появления/исчезновения
                            .animation(.easeInOut(duration: 0.3), value: showToast)
                            .onAppear {
                                print("🎭 ToastView показан: \(toastText)") // 🔎 Лог проверки
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }
                    }
                }
                .opacity(showToast ? 1 : 0) // ✅ Дополнительная защита от мерцаний
    }
}



//#Preview {
//    ToastView()
//}
