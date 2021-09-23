//
//  NetworkDataFetcher.swift
//  MusicJSON
//
//  Created by Дмитрий Рузайкин on 08.09.2021.
//

import Foundation

//В этом файле проиходит только декодирование (расшифровка JSON)
class NetworkDataFetcher{
    
    let networkService = NetworkService()
    
    func fetchRequest(urlString: String, response: @escaping (SearchResponse?) -> Void){
        networkService.request(urlString: urlString) { result in //вызываем функцию request созданную в NetworkService()
            switch result{ //Прописываем switch и xcode автоматически поможет его заполнить (через switch смотрим, что вообще происходит)
            case .success(let data): //Если success (все успешно, то...); let data - и есть полученные данные из NetworkService()
                do{
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data) //То парсим данные через JSONDecoder()
                    response(tracks) //Выдаем декодированные данные наружу
                } catch let jsonError{ //Если получили ошибку, то...
                    print("Ошибочка в декодировании", jsonError) //То выводим ошибку
                    response(nil) //Если не получилось, возвращаем nil
                }
            case .failure(let error): //Если случился фейл (failure), то...
                print("Ошибка в .failure в NetworkDataFetcher \(error.localizedDescription)") //То получим ошибку из NetworkService()
                response(nil)
            }
        }
    }
}
