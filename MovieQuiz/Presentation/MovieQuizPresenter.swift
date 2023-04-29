//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 29.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
} 
