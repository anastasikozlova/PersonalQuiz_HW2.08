//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Анастасия Козлова on 10.06.2024.
//

import UIKit

final class QuestionsViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    // создаем массив, в к-ый будем сохранять ответы пользователя
    private var answersChosen: [Answer] = []
    private var questionIndex = 0  // когда мы выбираем ответ в вопросе, будем увеличивать этот счетчик на 1; т е ответили на 1й вопрос, индекс стал 1 и тд
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // определяем кол-во ответов в слайдере (вопрос номер 3)
        let answerCount = Float(currentAnswers.count - 1) // слайдер принимает знач-е с типом Float, поэтому мы приводим полученное значение к этому типу
        rangedSlider.maximumValue = answerCount
        rangedSlider.value = answerCount / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else {return}
        resultVC.answersChosen = answersChosen
    }

    // MARK: - IB Actions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else {return} // извлекаем опционал с помощью guard
        let currentAnswer = currentAnswers[buttonIndex] // это ответ, который определил пользователь
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)   // округляем значение Float до целочисленного Int
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
    deinit {
        print("\(type(of: self)) has been deallocated")   // type(of: self) - это сам класс (ResultViewController)
    }

}

// MARK: - Private Methods
private extension QuestionsViewController {   // все методы внутри private extension будут приватными
    func updateUI() {
        // скрываем все три стека (все вопросы и ответы)
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // задаем заголовок
        title = "Вопрос №\(questionIndex + 1) из \(questions.count)"
        
        // отобразим текущий вопрос
        let currentQuestion = questions[questionIndex] // извлекаем из массива questions текущий вопрос; мы берем из этого массива элемент по индексу  questionIndex
        
        // устанавливаем текущий вопрос в лейбле
        questionLabel.text = currentQuestion.title
        
        // рассчитываем прогресс в progress view
        let totalProgress = Float(questionIndex) / Float(questions.count)
        // устанавливаем прогресс для questionProgressView
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // отображаем стек, соответствующий определенной категории ответов
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    
    /// Choice of answers category
    ///
    /// Displaying answers to a question according to the category
    /// 
    /// - Parameter type: Specifies the type of responses
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) { // ф-ия zip позволяет объединять последовательности (например, здесь мы перебираем сразу массив singleButtons и массив answers)
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
        
    }
    
    func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        // проверяем, дошли ли мы до конца вопросов
        if questionIndex < questions.count {
            updateUI()
            return
        }
        // если if не сработал, нам нужно сделать переход по сегвею (программно!!, т к переход по сегвею не привязан ни к какой кнопке, он идет от вью контроллера)
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
