import Foundation

let EventDetailApiResponseMock: Data? = #"""
  {
    "id": "1",
    "title": "Feira de adoção de animais na Redenção",
    "price": 29.99,
    "latitude": "-30.0392981",
    "longitude": "-51.2146267",
    "image": "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png",
    "description": "O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de \"seu\". \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade",
    "date": 1534784400000,
    "people": [
      {
        "id": "1",
        "eventId": "1",
        "name": "Alexandre Pires",
        "picture": "https://images.pexels.com/photos/1292306/pexels-photo-1292306.jpeg"
      },
      {
        "id": "2",
        "eventId": "1",
        "name": "Jéssica Souza",
        "picture": "https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg"
      },
      {
        "id": "6",
        "eventId": "1",
        "name": "Boanerges Oliveira",
        "picture": "https://images.pexels.com/photos/542282/pexels-photo-542282.jpeg"
      },
      {
        "id": "7",
        "eventId": "1",
        "name": "Felipe Smith",
        "picture": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"
      },
      {
        "id": "11",
        "eventId": "1",
        "name": "Paulo Santos",
        "picture": "https://images.pexels.com/photos/1334945/pexels-photo-1334945.jpeg"
      }
    ],
    "cupons": [
      {
        "id": "1",
        "eventId": "1",
        "discount": 10
      }
    ]
  }
"""#.data(using: .utf8)
