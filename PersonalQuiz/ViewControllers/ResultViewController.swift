//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Анастасия Козлова on 10.06.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet var animalTypeLabel: UILabel!
    @IBOutlet var animalDescriptionLabel: UILabel!
    
    var answersChosen: [Answer]!
    private var animalsChosen: [Animal] {
        answersChosen.map { $0.animal }
    }
    private var animalChosen: Animal {
        getMostFrequentAnimal(in: animalsChosen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalTypeLabel.text = "Вы - \(animalChosen.rawValue)!"
        animalDescriptionLabel.text = animalChosen.definition
    
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    // метод deinit вызывается, когда объект выгружается из памяти. Его прописывать НЕ обзательно
    deinit {
        print("\(type(of: self)) has been deallocated")   // type(of: self) - это сам класс (ResultViewController)
    }
    
    private func getMostFrequentAnimal<Animal: Hashable>(in array: [Animal]) -> Animal {
        let frequency = array.reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
        let sortedFrequency = frequency.sorted { $0.value > $1.value}
        return sortedFrequency.first!.key
    }
}
