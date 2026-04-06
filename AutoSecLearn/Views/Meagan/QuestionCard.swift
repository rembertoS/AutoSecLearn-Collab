//
//  QuestionCard.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 4/6/26.
//

import Foundation
import SwiftUI

struct QuestionCard: View {
    let question: Questions
    let qIndex: Int
    @ObservedObject var viewModel: ExamViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.paddingMedium) {
            
            // Question number + text
            HStack(alignment: .top, spacing: AppTheme.paddingSmall) {
                Text("Q\(qIndex + 1)")
                    .font(AppTheme.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.primaryGradient)
                    .clipShape(Capsule())
                
                Text(question.text)
                    .font(AppTheme.headline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Rectangle()
                .fill(AppTheme.border)
                .frame(height: 1)
            
            // Options
            ForEach(question.options.indices, id: \.self) { oIndex in
                let isSelected = viewModel.isSelected(questionIndex: qIndex, optionIndex: oIndex)
                
                Button {
                    viewModel.selectAnswer(questionIndex: qIndex, optionIndex: oIndex)
                } label: {
                    HStack(spacing: AppTheme.paddingSmall) {
                        
                        // Selection indicator circle
                        ZStack {
                            Circle()
                                .strokeBorder(isSelected ? Color.clear : AppTheme.border, lineWidth: 1.5)
                                .background(
                                    Circle().fill(isSelected ? AnyShapeStyle(AppTheme.primaryGradient) : AnyShapeStyle(Color.clear))
                                )
                                .frame(width: 22, height: 22)
                            
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Text(question.options[oIndex].answer)
                            .font(AppTheme.body)
                            .foregroundStyle(isSelected ? AppTheme.primary : .primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(AppTheme.paddingMedium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(isSelected ? AppTheme.primary.opacity(0.08) : Color(.systemBackground))
                            .strokeBorder(isSelected ? AppTheme.primary : Color.clear, lineWidth: 1.5)
                    )
                }
            }
        }
        .padding(AppTheme.paddingMedium)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
}
