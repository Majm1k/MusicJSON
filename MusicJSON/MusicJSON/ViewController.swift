//
//  ViewController.swift
//  MusicJSON
//
//  Created by Дмитрий Рузайкин on 03.09.2021.
//

import UIKit

class ViewController: UIViewController {

    private var timer: Timer? //Создаем таймер
    var searchResponse: SearchResponse? = nil //Наследуем модель данных
    
    let networkDataFetcher = NetworkDataFetcher() //Переместили всю работу с декодированием в отдельный файл, а здесь создали экземпляр
    let searchController = UISearchController(searchResultsController: nil) //Свойство для поиска по музыке
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView() //функция отображения tableVIew
        setupSearchBar() //функция отображения строки поиска и вывода в консоль набранный текст
        
        
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController //прописываем, чтобы строка поиска отображалась
        searchController.searchBar.delegate = self //подписываемся на протокол
        
        //Чисто визуальная часть
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView(){ //прописываем делегаты, чтобы подписаться на них
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //регистрация ячейки
    }

}

//Расширение для tableView (все как обычно, чтобы создать ячейки и тд)
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row] //Получаем конкретный трек
        print(track?.artworkUrl60)
        cell.textLabel?.text = track?.trackName //Вписываем выше написанное свойство
        return cell
    }
}

//Расширение для поиска, где в консоль будет выводится выбранный текст, но выше еще прописана обязательная функция + вставили логику парсинга JSON, чтобы корректно работал поиск
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5" //записываем json файл в константу + вместо "jack+johnson" вписываем searchText, чтобы все что вводим в клавиатуру вводилось в ссылку
        
        timer?.invalidate() //Активация таймера (Останавливает повторное срабатывание)
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in //Используем таймер, чтобы запрос на поиск работал только после того, как пользователь что-то ввел, на это хватит таймеру 0,5 сек.
            self.networkDataFetcher.fetchRequest(urlString: urlString) {  searchResponse in //функция для преоброзавания JSON (в функции прописали входные данные и здесь их указали); [weak self] помогает избежать утечки памяти
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
                self.table.reloadData() //Команда, которая обновляет всю таблицу
            }
        })
    }
}

