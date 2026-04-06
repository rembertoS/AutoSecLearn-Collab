//
//  ScorePopup.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 4/1/26.
//

import Foundation
import SwiftUI

struct ScorePopup: View {
    
    let score: Int
    let total: Int
    let onRetake: () -> Void
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(score) / Double(total)) * 100)
    }
    
    private var resultMessage: String {
        switch percentage {
        case 90...100: return "Excellent! 🏆"
        case 70...89:  return "Great job! 🎉"
        case 50...69:  return "Keep practicing! 💪"
        default:       return "Don't give up! 📚"
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.paddingLarge) {
            
            // Result message
            Text(resultMessage)
                .font(AppTheme.title)
                .foregroundStyle(AppTheme.primaryGradient)
            
            // Score circle
            ZStack {
                Circle()
                    .strokeBorder(AppTheme.border, lineWidth: 6)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(AppTheme.primaryGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.8), value: percentage)
                
                VStack(spacing: 2) {
                    Text("\(score)/\(total)")
                        .font(AppTheme.title)
                    Text("\(percentage)%")
                        .font(AppTheme.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Retake button
            Button("Retake") {
                onRetake()
            }
            .font(AppTheme.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.paddingMedium)
            .background(AppTheme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        }
        .padding(AppTheme.paddingLarge)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius + 4))
        .shadow(color: .black.opacity(0.2), radius: 24, x: 0, y: 8)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        ScorePopup(score: 8, total: 10, onRetake: {})
            .padding(32)
    }
}
