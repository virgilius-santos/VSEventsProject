import Foundation

protocol ShowEventsPresentationLogic {
    func displayEvents(result: Swift.Result<[Event], SingleButtonAlert>)
}

protocol ShowEventsBusinessLogic {
    func fetchEvents()
}

@available(*, deprecated, message: "decontinuado, usar a viewModel")
final class ShowEventsInteractor {
    let presenter: ShowEventsPresentationLogic
    let eventAPI: EventAPIProtocol
    
    init(presenter: ShowEventsPresentationLogic, eventAPI: EventAPIProtocol) {
        self.presenter = presenter
        self.eventAPI = eventAPI
    }
}

@available(*, deprecated, message: "decontinuado, usar a viewModel")
extension ShowEventsInteractor: ShowEventsBusinessLogic {
    func fetchEvents() {
        eventAPI.fetchEvents { [weak self] (result: Result<[Event], Error>) in

            switch result {
            case .success(let evt):
                self?.presenter.displayEvents(result: .success(evt))

            case .failure(let error):
                print(error)
                let buttonAlert = SingleButtonAlert(
                    title: "Erro Na Busca dos Dados",
                    message: "Tente novamente",
                    action: AlertAction(
                        buttonTitle: "OK"
                    )
                )
                self?.presenter.displayEvents(result: .failure(buttonAlert))
            }
        }
    }
}

// Exemplo de payload de sucesso com 10 eventos:
/*
 [
    {
       "id":"1",
       "title":"Evento de Tecnologia 1",
       "price":49.99,
       "latitude":-23.55052,
       "longitude":-46.633308,
       "image":"https://picsum.photos/300/200?random=1",
       "description":"Descrição detalhada do evento de tecnologia 1.",
       "date":1739500800,
       "people":[
          {
             "id":"p1",
             "eventId":"1",
             "name":"Participante A",
             "picture":"https://picsum.photos/50?random=101"
          }
       ],
       "cupons":[
          {
             "id":"c1",
             "eventId":"1",
             "discount":10
          }
       ]
    },
    {
       "id":"2",
       "title":"Conferência de Marketing Digital 2",
       "price":79.00,
       "latitude":-23.56137,
       "longitude":-46.65622,
       "image":"https://picsum.photos/300/200?random=2",
       "description":"Uma conferência imperdível sobre as últimas tendências em marketing digital.",
       "date":1739587200,
       "people":[
          
       ],
       "cupons":[
          
       ]
    },
    {
       "id":"3",
       "title":"Workshop de Fotografia 3",
       "price":120.50,
       "latitude":-23.5489,
       "longitude":-46.6388,
       "image":"https://picsum.photos/300/200?random=3",
       "description":"Aprenda técnicas avançadas de fotografia com profissionais renomados.",
       "date":1739760000,
       "people":[
          {
             "id":"p2",
             "eventId":"3",
             "name":"Fotógrafo B",
             "picture":"https://picsum.photos/50?random=102"
          }
       ],
       "cupons":[
          {
             "id":"c2",
             "eventId":"3",
             "discount":15
          }
       ]
    },
    {
       "id":"4",
       "title":"Festival de Música Indie 4",
       "price":30.00,
       "latitude":-23.5558,
       "longitude":-46.6396,
       "image":"https://picsum.photos/300/200?random=4",
       "description":"Curta o melhor da música independente nacional e internacional.",
       "date":1739932800,
       "people":[
          
       ],
       "cupons":[
          
       ]
    },
    {
       "id":"5",
       "title":"Feira Gastronômica Sabores do Mundo 5",
       "price":15.00,
       "latitude":-23.563,
       "longitude":-46.6544,
       "image":"https://picsum.photos/300/200?random=5",
       "description":"Experimente pratos deliciosos de diversas culturas em um só lugar.",
       "date":1740192000,
       "people":[
          {
             "id":"p5",
             "eventId":"5",
             "name":"Chef Visitante",
             "picture":"https://picsum.photos/50?random=105"
          }
       ],
       "cupons":[
          {
             "id":"c3",
             "eventId":"5",
             "discount":5
          }
       ]
    },
    {
       "id":"6",
       "title":"Exposição de Arte Moderna 6",
       "price":25.00,
       "latitude":-23.55,
       "longitude":-46.63,
       "image":"https://picsum.photos/300/200?random=6",
       "description":"Obras impactantes de artistas contemporâneos.",
       "date":1740364800,
       "people":[
          
       ],
       "cupons":[
          
       ]
    },
    {
       "id":"7",
       "title":"Curso de Culinária Italiana 7",
       "price":150.00,
       "latitude":-23.5678,
       "longitude":-46.64,
       "image":"https://picsum.photos/300/200?random=7",
       "description":"Aprenda a fazer massas frescas e molhos autênticos.",
       "date":1740624000,
       "people":[
          {
             "id":"p3",
             "eventId":"7",
             "name":"Chef C",
             "picture":"https://picsum.photos/50?random=103"
          }
       ],
       "cupons":[
          
       ]
    },
    {
       "id":"8",
       "title":"Palestra sobre Inteligência Artificial 8",
       "price":0.00,
       "latitude":-23.54,
       "longitude":-46.62,
       "image":"https://picsum.photos/300/200?random=8",
       "description":"Descubra o futuro da IA e suas aplicações.",
       "date":1740796800,
       "people":[
          
       ],
       "cupons":[
          
       ]
    },
    {
       "id":"9",
       "title":"Show de Stand-up Comedy 9",
       "price":40.00,
       "latitude":-23.57,
       "longitude":-46.65,
       "image":"https://picsum.photos/300/200?random=9",
       "description":"Gargalhadas garantidas com os melhores comediantes.",
       "date":1740969600,
       "people":[
          {
             "id":"p4",
             "eventId":"9",
             "name":"Comediante Z",
             "picture":"https://picsum.photos/50?random=104"
          }
       ],
       "cupons":[
          {
             "id":"c4",
             "eventId":"9",
             "discount":20
          }
       ]
    },
    {
       "id":"10",
       "title":"Corrida de Rua Beneficente 10",
       "price":50.00,
       "latitude":-23.58,
       "longitude":-46.66,
       "image":"https://picsum.photos/300/200?random=10",
       "description":"Participe e ajude uma causa nobre.",
       "date":1741142400,
       "people":[
          
       ],
       "cupons":[
          
       ]
    }
 ]
*/
