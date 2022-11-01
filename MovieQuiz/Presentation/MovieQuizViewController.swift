import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (
            image: "Deadpool",
            text: "Рейтинг этого фильма выше чем 5?",
            correctAnswer: true),
        QuizQuestion (
            image: "Kill Bill",
            text: "Рейтинг этого фильма ниже чем 7?",
            correctAnswer: false),
        QuizQuestion (
            image: "Old",
            text: "Рейтинг этого фильма выше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "Tesla",
            text: "Рейтинг этого фильма ниже чем 5?",
            correctAnswer: false),
        QuizQuestion (
            image: "The Avengers",
            text: "Рейтинг этого фильма ниже чем 8?",
            correctAnswer: false),
        QuizQuestion (
            image: "The Dark Knight",
            text: "Рейтинг этого фильма выше чем 8?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Godfather",
            text: "Рейтинг этого фильма выше чем 7?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Green Knight",
            text: "Рейтинг этого фильма ниже чем 7?",
            correctAnswer: false),
        QuizQuestion (
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма выше чем 7?",
            correctAnswer: false),
        QuizQuestion (
            image: "Vivarium",
            text: "Рейтинг этого фильма выше чем 5?",
            correctAnswer: true)
    ]
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.questionNumber)/ \(questions.count)"
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            let currentQuestion = self.questions[self.currentQuestionIndex]
            self.show(quiz: self.convert(model: currentQuestion))
            
        })

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
          let text = "Ваш результат: \(correctAnswers) из 10"
          let result = QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: text,
                                            buttonText: "Сыграть еще раз")
          show(quiz: result)
          correctAnswers = 0
      } else {
        currentQuestionIndex += 1
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
      }
    }
    
}
