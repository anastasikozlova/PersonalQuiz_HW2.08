//
//  Question.swift
//  PersonalQuiz
//
//  Created by Анастасия Козлова on 10.06.2024.
//

// сами модели данных определяют, как правило, как структуры, потому что структуры быстрее и производительнее классов. НО если модель данных создается для работы с базой, то нужно будет создавать класс, потому что для работы с базой данных нужно наследоваться от других классов, к-ые завязаны на базу данных
struct Question {
    let title: String
    let type: ResponseType   // св-во type - категория вопросов и ответов
    let answers: [Answer]    // каждый вопрос у нас связан со списком ответов, поэтому answers - это массив
    
    static func getQuestions() -> [Question] {     // static func - это ф-ия, к-ая вызывается не из экземпляра, а из самого объекта; испольуется для структур, хотя и для классов тоже может использоваться. Если у класса есть дочерние объекты, то они static метод наследовать НЕ будут
        [
            Question(
                title: "Какую пищу предпочитаете?",
                type: .single,
                answers: [
                    Answer(title: "Стейк", animal: .dog),
                    Answer(title: "Рыба", animal: .cat),
                    Answer(title: "Морковь", animal: .rabbit),
                    Answer(title: "Кукуруза", animal: .turtle)
                ]
            ),
            Question(
                title: "Что вам нравится больше?",
                type: .multiple,
                answers: [
                    Answer(title: "Плавать", animal: .dog),
                    Answer(title: "Спать", animal: .cat),
                    Answer(title: "Обниматься", animal: .rabbit),
                    Answer(title: "Есть", animal: .turtle)
                ]
            ),
            Question(
                title: "Любите ли вы поездки на машине?",
                type: .ranged,
                answers: [
                    Answer(title: "Ненавижу", animal: .cat),
                    Answer(title: "Нервничаю", animal: .rabbit),
                    Answer(title: "Не замечаю", animal: .turtle),
                    Answer(title: "Обожаю", animal: .dog)
                ]
            ),
         ]
    }
}

enum ResponseType {
    case single    // одиночные ответы (как в вопросе 1)
    case multiple  // множественные ответы (как в вопросе 2)
    case ranged    // ответы из диапазона
}

// Как понять, что нам нужно: структура или перечисление? Если тип данных нам не важен, то перечисление; если важен, то структура
struct Answer {
    let title: String
    let animal: Animal
}

enum Animal: Character {
    case dog = "🐶"
    case cat = "🐱"
    case rabbit = "🐰"
    case turtle = "🐢"
    
    var definition: String { // меняем описание в зависимости от кейса
        switch self {
        case .dog:
            return "Вам нравится быть с друзьями. Вы окружаете себя людьми, которые вам нравятся и готовы помочь."
        case .cat:
            return "Вы себе на уме. Любите гулять сами по себе. Вы цените одиночество."
        case .rabbit:
            return "Вам нравится все мягкое. Вы здоровы и полны энергии."
        case .turtle:
            return "Ваша сила в мудрости. Медленный и вдумчивый выигрывает на больших дистанциях."
        } // передаем в switch само перечисление Animal для сопоставления кейсов с описанием
    }
}
