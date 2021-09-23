//
//  NetworkService.swift
//  MusicJSON
//
//  Created by Дмитрий Рузайкин on 08.09.2021.
//

import Foundation

//В этом файле проиходит только работа с сетью (получение данных)
class NetworkService{
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void){ //@escaping - без него будет ошибка (он не дает развернуть данные)
        guard let url = URL(string: urlString) else {return} //преобразовываем строковую констунту с json файлом + указываем guard, иначе ошибка в URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { //Если медленный интернет, то данные будут подгружаться долго и чтобы пользователь не ждал, загрузка данных должна быть в асинхронном потоке (DispatchQueue.main.async)
                if let error = error{ //Проверка пришла ли ошибка
                    completion(.failure(error)) //Ошибку надо завернуть в completion блок (Где вызвали функцию request прописали SearchResponse(данные из JSON) и error и благодаря competion,если будеи ошибка, то просто передаем ошибку
                    return
                }
                guard let data = data else {return} //Проверяем data на опциональность ("?")
                completion(.success(data)) //тут передаем данные в NetworkDataFetcher() для декодирования
            }
        }.resume() //активация функции, тк без этого функция не буде работать
    }
}

//В URLSession мы запрашиваем данные
//А в do{} мы уже парсим данные
