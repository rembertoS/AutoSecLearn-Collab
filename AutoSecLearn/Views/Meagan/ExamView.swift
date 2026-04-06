//
//  ExamView.swift
//  AutoSecLearn
//
//  Created by meagan alfaro on 4/1/26.
//

import Foundation
import SwiftUI

struct ExamView: View {
    
    let module: Module
    @StateObject private var viewModel: ExamViewModel

    init(module: Module) {
        self.module = module
        _viewModel = StateObject(wrappedValue: ExamViewModel(questions: module.questions))
    }
    
    var body: some View {
        ZStack {
            AppTheme.cardBackground
                .ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: AppTheme.paddingMedium) {
                        
                        Color.clear
                            .frame(height: 0)
                            .id("top")
                        
                        // Progress indicator
                        HStack {
                            Text("\(viewModel.selections.count) of \(viewModel.questions.count) answered")
                                .font(AppTheme.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.paddingSmall)
                        
                        ForEach(viewModel.questions.indices, id: \.self) { qIndex in
                            QuestionCard(
                                question: viewModel.questions[qIndex],
                                qIndex: qIndex,
                                viewModel: viewModel
                            )
                        }
                        
                        Button("Submit") {
                            viewModel.submit()
                        }
                        .font(AppTheme.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.paddingMedium)
                        .background(AppTheme.primaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                        .padding(.horizontal, AppTheme.paddingMedium)
                        .padding(.bottom, AppTheme.paddingLarge)
                    }
                    .padding(AppTheme.paddingMedium)
                }
                .navigationTitle(module.name)
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: viewModel.showScore) { _, isShowing in
                    if !isShowing {
                        withAnimation {
                            proxy.scrollTo("top")
                        }
                    }
                }
            }
            
            if viewModel.showScore {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ScorePopup(
                    score: viewModel.score,
                    total: viewModel.questions.count,
                    onRetake: {
                        viewModel.reset()
                    }
                )
                .padding(AppTheme.paddingLarge)
            }
        }
    }
}

#Preview {
    let sampleModule = Module(
        name: "Sample",
        questions: [
            Questions(
                text: "What is 2 + 2?",
                options: [
                    AnswerOption(answer: "3", isCorrect: false),
                    AnswerOption(answer: "4", isCorrect: true)
                ]
            ),
            Questions(
                text: "Capital of France?",
                options: [
                    AnswerOption(answer: "Berlin", isCorrect: false),
                    AnswerOption(answer: "Paris", isCorrect: true)
                ]
            )
        ]
    )
    NavigationStack {
        ExamView(module: sampleModule)
    }
}
