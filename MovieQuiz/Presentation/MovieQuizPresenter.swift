//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 29.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
   // weak var viewController: MovieQuizViewController?
     
    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
        
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
    }
    
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
    
    func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = isYes
            if (givenAnswer) { correctAnswers += 1 }
            viewController?.yesButton.isEnabled = false
            viewController?.noButton.isEnabled = false
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
         guard let question = question else {
               return
         }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        viewController?.yesButton.isEnabled = true
        viewController?.noButton.isEnabled = true
        if isLastQuestion() {
            //self.viewController?.showFinalResults()
            viewController?.showFinalResults()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
    }
    
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
    func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
    }
    
} 
