//
//  ApiTests.swift
//  VSEventsProjectTests
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import VSEventsProject

class ShowEventsInteractorTests: QuickSpec {

    enum MockError: Error {
        case error
    }

    class APIProtocolMock: EventAPIProtocol {
        func fetch<T>(completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
            let obj = try! [T].decoder(json: dataMock)
            completion(.success(obj))
        }
    }

    class APIProtocolMockError: EventAPIProtocol {
        func fetch<T>(completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
            completion(.error(MockError.error))
        }
    }

    class PresentationLogicMock: ShowEventsPresentationLogic {
        var result: Result<[Event], SingleButtonAlert>?
        var done: (() -> Void)?
        func displayEvents(result: Result<[Event], SingleButtonAlert>) {
            self.result = result
            done?()
        }
    }

    var sei: ShowEventsInteractor!
    var pre: PresentationLogicMock!

    override func spec() {
        beforeEach {
            self.pre = PresentationLogicMock()
            self.sei = ShowEventsInteractor()
            self.sei.presenter = self.pre
        }
        describe("solicitando listas de eventos") {
            context("a api esta funcionando") {
                it("validar se o request é recebido corretamente") {
                    self.sei.eventAPI = APIProtocolMock()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.fetchEvents()
                    }
                    expect(self.pre.result).notTo(beNil())
                    if let result = self.pre.result, case .success(let evts) = result {
                        expect(evts.count).to(equal(dataMock.count))
                    } else {
                        fail()
                    }
                }
            }

            context("a api NAO esta funcionando") {
                it("validar se o request é recebido corretamente") {
                    self.sei.eventAPI = APIProtocolMockError()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.fetchEvents()
                    }
                    expect(self.pre.result).notTo(beNil())
                    if let result = self.pre.result, case .error(let error) = result {
                        expect(error).to(beAnInstanceOf(SingleButtonAlert.self))
                    } else {
                        fail()
                    }
                }
            }
        }

    }

}

var dataMock: [Any] =
[["id":"1","title":"Feira de adoÃ§Ã£o de animais na RedenÃ§Ã£o","price":29.99,"latitude":"-30.0392981","longitude":"-51.2146267","image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png","description":"O Patas Dadas estarÃ¡ na RedenÃ§Ã£o, nesse domingo, com cÃ£es para adoÃ§Ã£o e produtos Ã  venda!\n\nNa ocasiÃ£o, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarÃ£o prontinhos para ganhar o â™¥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doaÃ§Ã£o:\n- guias e coleiras em bom estado\n- raÃ§Ã£o (as que mais precisamos no momento sÃ£o sÃªnior e filhote)\n- roupinhas \n- cobertas \n- remÃ©dios dentro do prazo de validade","date":1534784400000,"people":[["id":"1","eventId":"1","name":"Alexandre Pires","picture":"https://images.pexels.com/photos/1292306/pexels-photo-1292306.jpeg"],["id":"2","eventId":"1","name":"JÃ©ssica Souza","picture":"https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg"],["id":"6","eventId":"1","name":"Boanerges Oliveira","picture":"https://images.pexels.com/photos/542282/pexels-photo-542282.jpeg"],["id":"7","eventId":"1","name":"Felipe Smith","picture":"https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"],["id":"11","eventId":"1","name":"Paulo Santos","picture":"https://images.pexels.com/photos/1334945/pexels-photo-1334945.jpeg"]],"cupons":[["id":"1","eventId":"1","discount":10]]],["id":"2","title":"DoaÃ§Ã£o de roupas","price":59.99,"latitude":-30.037878,"longitude":-51.2148497,"image":"http://fm103.com.br/wp-content/uploads/2017/07/campanha-do-agasalho-balneario-camboriu-2016.jpg","description":"Vamos ajudar !!\n\nSe vocÃª tem na sua casa roupas que estÃ£o em bom estado de uso e nÃ£o sabemos que fazer, coloque aqui na nossa pÃ¡gina sua cidade e sua doaÃ§Ã£o, concerteza poderÃ¡ ajudar outras pessoas que estÃ£o passando por problemas econÃ´micos no momento!!\n\nAjudar nÃ£o faz mal a ninguÃ©m!!!\n","date":1534784400000,"people":[["id":"12","eventId":"2","name":"Alexandre Pires","picture":"https://images.pexels.com/photos/1292306/pexels-photo-1292306.jpeg"],["id":"21","eventId":"2","name":"JÃ©ssica Souza","picture":"https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg"],["id":"61","eventId":"2","name":"Boanerges Oliveira","picture":"https://images.pexels.com/photos/542282/pexels-photo-542282.jpeg"]],"cupons":[["id":"2","eventId":"2","discount":25]]],["id":"3","title":"Feira de Troca de Livros","price":19.99,"latitude":-30.037878,"longitude":-51.2148497,"image":"http://www.fernaogaivota.com.br/documents/10179/1665610/feira-troca-de-livros.jpg","description":"AtenÃ§Ã£o! Para nosso brique ser o mais organizado possÃ­vel, leia as regras e cumpra-as:\n* Ao publicar seus livros, evite criar Ã¡lbuns (nÃ£o hÃ¡ necessidade de remetÃª-los a nenhum Ã¡lbum);\n* A publicaÃ§Ã£o deverÃ¡ conter o valor desejado;\n* Ã‰ preferÃ­vel publicar uma foto do livro em questÃ£o a fim de mostrar o estado em que se encontra;\n* Respeite a ordem da fila;\n* HorÃ¡rio e local de encontro devem ser combinados inbox;\n* Caso nÃ£o possa comparecer, avise seu comprador/vendedor previamente;\n* Caso seu comprador desista, comente o post com \"disponÃ­vel\";\n* NÃ£o se esqueÃ§a de apagar a publicaÃ§Ã£o se o livro jÃ¡ foi vendido, ou ao menos comente \"vendido\" para que as administradoras possam apagÃ¡-la;\n* Evite discussÃµes e respeite o prÃ³ximo;\n","date":1534784400000,"people":[["id":"71","eventId":"3","name":"Felipe Smith","picture":"https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"],["id":"11","eventId":"3","name":"Paulo Santos","picture":"https://images.pexels.com/photos/1334945/pexels-photo-1334945.jpeg"]],"cupons":[["id":"3","eventId":"3","discount":100]]],["id":"4","title":"Feira de Produtos Naturais e OrgÃ¢nicos","price":19,"latitude":-30.037878,"longitude":-51.2148497,"image":"https://i2.wp.com/assentopublico.com.br/wp-content/uploads/2017/07/Feira-de-alimentos-org%C3%A2nicos-naturais-e-artesanais-ganha-um-novo-espa%C3%A7o-em-Ribeir%C3%A3o.jpg","description":"Toda quarta-feira, das 17h Ã s 22h, encontre a feira mais charmosa de produtos frescos, naturais e orgÃ¢nicos no estacionamento do Shopping. Sintonizado com a tendÃªncia crescente de busca pela alimentaÃ§Ã£o saudÃ¡vel, consumo consciente e qualidade de vida. \n\nAs barracas terÃ£o grande variedade de produtos, como o shiitake cultivado em IbiporÃ£ hÃ¡ mais de 20 anos, um sucesso na mesa dos que nÃ£o abrem mÃ£o do saudÃ¡vel cogumelo na dieta. Ou os laticÃ­nios orgÃ¢nicos da EstÃ¢ncia BaobÃ¡, famosos pelo qualidade e modo de fabricaÃ§Ã£o sustentÃ¡vel na vizinha JaguapitÃ£. TambÃ©m estarÃ£o na feira as conhecidas compotas e patÃªs tradicionais da Pousada MarabÃº, de RolÃ¢ndia.\n\nA feira do CatuaÃ­ Ã© uma nova opÃ§Ã£o de compras de produtos que nÃ£o sÃ£o facilmente encontrados no varejo tradicional, alÃ©m de Ã³tima pedida para o descanso de final de tarde em famÃ­lia e entre amigos. E com o diferencial de ser noturna, facilitando a vida dos consumidores que poderÃ£o sair do trabalho e ir direto para a â€œVila Verdeâ€, onde serÃ¡ possÃ­vel degustar delÃ­cias saudÃ¡veis nos bistrÃ´s, ouvir mÃºsica ao vivo, levar as crianÃ§as para a diversÃ£o em uma estaÃ§Ã£o de brinquedos e relaxar ao ar livre.\n\nEXPOSITORES DA VILA VERDE CATUAÃ\n\nCraft Hamburgueria\nNido PastÃ­ficio\nSabor e SaÃºde\nTerra Planta\nEmpÃ³rio da Papinha\nEmpÃ³rio Sabor da Serra\nBoleria Dom Leonardi\nCoisas que te ajudam a viver\nPatÃªs da Marisa\nMarabÃº\nBaobÃ¡\nAkko\nCervejaria Amadeus\n12 Tribos\nParr Kitchen\nHorta Fazenda SÃ£o VirgÃ­lio\nHorta ChÃ¡cara Santo Antonio\nSur Empanadas\nFit & Sweet\nSK e T Cogumelos\nDos Quintana\n\nLocal: Estacionamento (entrada principal do CatuaÃ­ Shopping Londrina)\n\n\nAcesso Ã  Feira gratuito.","date":1534784400000,"people":[["id":"111","eventId":"4","name":"Alexandre Pires","picture":"https://images.pexels.com/photos/1292306/pexels-photo-1292306.jpeg"],["id":"211","eventId":"4","name":"JÃ©ssica Souza","picture":"https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg"],["id":"611","eventId":"4","name":"Boanerges Oliveira","picture":"https://images.pexels.com/photos/542282/pexels-photo-542282.jpeg"],["id":"711","eventId":"4","name":"Felipe Smith","picture":"https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"],["id":"1111","eventId":"4","name":"Paulo Santos","picture":"https://images.pexels.com/photos/1334945/pexels-photo-1334945.jpeg"]],"cupons":[["id":"4","eventId":"4","discount":70]]],["id":"5","title":"Hackathon Social Woop Sicredi","price":59.99,"latitude":-30.037878,"longitude":-51.2148497,"image":"https://static.wixstatic.com/media/579ac9_81e9766eaa2741a284e7a7f729429022~mv2.png","description":"Uma maratona de programaÃ§Ã£o, na qual estudantes e profissionais das Ã¡reas de DESIGN, PROGRAMAÃ‡ÃƒO e MARKETING se reunirÃ£o para criar projetos com impacto social positivo atravÃ©s dos pilares de EducaÃ§Ã£o Financeira e Colaborar para Transformar.\n\nO evento serÃ¡ realizado por duas empresas que sÃ£o movidas pela transformaÃ§Ã£o: o Woop Sicredi e a Smile Flame.\n\n// Pra ficar esperto:\n\n- 31/08, 01 e 02 de Setembro, na PUCRS;\n- 34 horas de duraÃ§Ã£o;\n- Atividades direcionadas para criaÃ§Ã£o de soluÃ§Ãµes digitais de impacto social;\n- Mentorias para apoiar o desenvolvimento das soluÃ§Ãµes;\n- ConteÃºdo de apoio; \n- AlimentaÃ§Ã£o inclusa;\n\n// ProgramaÃ§Ã£o\n\nSexta-feira - 31/08 - 19h Ã¡s 22h\nSÃ¡bado e Domingo - 01 e 02/09 - 9h do dia 01/09 atÃ© as 18h do dia 02/09.\n\n// RealizaÃ§Ã£o\nWoop Sicredi\nSmile Flame\n\nMaiores infos em: https://www.hackathonsocial.com.br/\nTÃ¡ com dÃºvida? Manda um e-mail pra gabriel@smileflame.com\n\nEaÃ­, ta tÃ£o animado quanto nÃ³s? LetÂ´s hack!","date":1534784400000,"people":[],"cupons":[["id":"5","eventId":"5","discount":0]]]]
