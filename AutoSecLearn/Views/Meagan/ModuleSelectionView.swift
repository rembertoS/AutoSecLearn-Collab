//
//  ModuleSelectionView.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 4/5/26.
//

import Foundation
import SwiftUI

struct ModuleSelectionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.paddingMedium) {
                
                // Header
                VStack(spacing: 8) {
                    Text("Module Exams")
                        .font(AppTheme.largeTitle)
                        .foregroundStyle(AppTheme.primaryGradient)
                    
                    Text("Select a module to begin")
                        .font(AppTheme.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, AppTheme.paddingLarge)
                .padding(.bottom, AppTheme.paddingSmall)
                
                // Module cards
                ForEach(QuestionStorage.allModules.indices, id: \.self) { index in
                    let module = QuestionStorage.allModules[index]
                    
                    NavigationLink(destination: ExamView(module: module)) {
                        HStack(spacing: AppTheme.paddingMedium) {
                            
                            // Module number badge
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AppTheme.primaryGradient)
                                    .frame(width: 44, height: 44)
                                Text("\(index + 1)")
                                    .font(AppTheme.headline)
                                    .foregroundStyle(.white)
                            }
                            
                            // Module info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(module.name)
                                    .font(AppTheme.headline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Text("\(module.questions.count) questions")
                                    .font(AppTheme.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        .padding(AppTheme.paddingMedium)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, AppTheme.paddingMedium)
            }
            .padding(.bottom, AppTheme.paddingLarge)
        }
        .background(AppTheme.cardBackground.ignoresSafeArea())
        .navigationTitle("Meagan's Section")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ModuleSelectionView()
    }
}
