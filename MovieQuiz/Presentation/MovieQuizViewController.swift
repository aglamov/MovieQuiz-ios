import UIKit

final class MovieQuizViewController: UIViewController {
           
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
   // private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    private var currentRounds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
     //   questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
     //   questionFactory?.loadData()
        alertPresenter = AlertPresenter(viewController: self)
      
     //   questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
        presenter.viewController = self
    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
        
    func showFinalResults() {
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        
        let alertModel = AlertModel(title: "Игра окончена!", message: makeResultMessage(), buttonText: "OK") { [weak self] in
            guard let self else {
                return
            }
            self.presenter.resetQuestionIndex()
            self.presenter.restartGame()            
         //   self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticService, let bestGame = statisticService.bestGame else {
            return ""
        }
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [totalPlaysCountLine, currentGameResultLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
           
      //      self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }

     
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }

//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.presenter.restartGame()
            
         //   self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alertModel: model)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
       
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
   
    
}


