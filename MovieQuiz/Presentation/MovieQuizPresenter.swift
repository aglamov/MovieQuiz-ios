//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 29.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
        
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        guard let currentQuestion else {
            return
        }
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
} 
