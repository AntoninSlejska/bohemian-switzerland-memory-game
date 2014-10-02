import 'dart:html';
import 'dart:async';
import 'translations.dart';

const NUM_OF_EACH = 2;

List<String> cardFileNames, cards;
String language = "czech", memoryType = "destinations";
String cardBack = "images/$memoryType/00.jpg";
int strikes, cardsLeft, trials, numCards = 4 * 4;
ImageElement lastClicked;

/// Translate the user interface
void translate() {
  querySelector('#title_text').text = userInterface[language]["title_text"];
  querySelector('#new_game_button').text = userInterface[language]["new_game_button"];
  querySelector('#strike_text').text = userInterface[language]["strike_text"];
  querySelector('#left_text').text = userInterface[language]["left_text"];
  querySelector('#info_text').text = userInterface[language]["info_text"];
  querySelector('#difficulty_text').text = userInterface[language]["difficulty_text"];
  querySelector('#low_difficulty_text').text = userInterface[language]["low_difficulty_text"];
  querySelector('#middle_difficulty_text').text = userInterface[language]["middle_difficulty_text"];
  querySelector('#high_difficulty_text').text = userInterface[language]["high_difficulty_text"];
  querySelector('#memory_type_text').text = userInterface[language]["memory_type_text"];
}

/// Show the clicked card and its description.
void cardClicked (MouseEvent event) {
  ImageElement clickedCard = event.target;
  
  if (!clickedCard.src.endsWith(cardBack)) {
    return;
  }
  
  int clickedNumber = int.parse(clickedCard.alt);
  clickedCard.src = cards[clickedNumber];
  int cardNumber = int.parse(clickedCard.src.substring(clickedCard.src.length - 6, clickedCard.src.length - 4)) - 1;
  querySelector("#info_text").text = cardDescriptions[memoryType][language][cardNumber];
  
  if (lastClicked == null) {
    lastClicked = clickedCard;
  } else {
    if (clickedCard.src == lastClicked.src) {
      cardsLeft -= 2;
      querySelector("#num_left").text = cardsLeft.toString();
    } else {
      strikes++;
      querySelector("#num_strikes").text = strikes.toString();
      
      ImageElement tempClicked = lastClicked;
      Timer t = new Timer(const Duration(seconds: 1), () {
        clickedCard.src = cardBack;
        tempClicked.src = cardBack;
      });
    }
    lastClicked = null;
  }
}

/// Find out what function should executed
void clickEvents(MouseEvent event) {
  if (event.target.toString() == "img") {
    ImageElement clickedIcon = event.target;
    switch (clickedIcon.id) {
      case "language_en":
        language = "english";
        translate();
        break;
      case "language_cz":
        language = "czech";
        translate();
        break;
      case "language_de":
        language = "german";
        translate();
        break;
      case "memory_type_destinations":
        memoryType = "destinations";
        cardBack = "images/$memoryType/00.jpg";
        setCards();
        reset();
        break;
      case "memory_type_drawings":
        memoryType = "drawings";
        cardBack = "images/$memoryType/00.jpg";
        setCards();
        reset();
        break;
      case "memory_type_animals":
        memoryType = "animals";
        cardBack = "images/$memoryType/00.jpg";
        setCards();
        reset();
        break;
      case "memory_type_birds":
        memoryType = "birds";
        cardBack = "images/$memoryType/00.jpg";
        setCards();
        reset();
        break;
      default:
        break;
    }
  } else if (event.target.toString() == "input") {
    InputElement clickedRadio = event.target;  
    switch (clickedRadio.id) {
      case "low_difficulty":
        numCards = 4 * 4;
        querySelector("#card_box").style.width = "408px";
        querySelector("#card_box").style.height = "408px";
        break;
      case "middle_difficulty":
        numCards = 6 * 4;
        querySelector("#card_box").style.width = "612px";
        querySelector("#card_box").style.height = "408px";
        break;
      case "high_difficulty":
        numCards = 6 * 6;
        querySelector("#card_box").style.width = "612px";
        querySelector("#card_box").style.height = "612px";
        break;
      default:
        break;
      }
    
    setCards();
    reset();
  } else {  // It has to be the button #new_game_button. In this case: event.target.toString() == "button"
    reset();
  }
}

/// Fill the list cardFileNames with links to images
void setCards() {
  String cardNumber;
  int numberOfCards = numCards ~/ NUM_OF_EACH;
  cardFileNames = [];
  for (int i = 0; i < numberOfCards; i++) {
    if (i < 9) {
      cardNumber = "0${i + 1}";
    } else {
      cardNumber = "${i + 1}";
    }
    cardFileNames.add("images/$memoryType/${cardNumber}.jpg");
  }
}

/// Deal the cards
void reset() {
  strikes = 0;
  trials = 0;
  cardsLeft = numCards;
  
  querySelector("#card_box").nodes.clear();

  for (int i = 0; i < numCards; i++) {
    ImageElement cardImage = new ImageElement(height: 100, width: 100);
    cardImage.onClick.listen(cardClicked);
    cardImage.alt = i.toString();
    cardImage.id = "card";
    querySelector("#card_box").append(cardImage);
  }

  querySelector('#num_strikes').text = strikes.toString();
  querySelector('#num_left').text = cardsLeft.toString();

  for (ImageElement img in querySelectorAll("img")) {
    if (img.id == "card") img.src = cardBack;
  }

  cards = new List();
  for (String cardFileName in cardFileNames) {
    for (int i = 0; i < NUM_OF_EACH; i++) {
      cards.add(cardFileName);
    }
  }
  cards.shuffle();
}

void main() {
  translate();
  setCards();
  querySelector("#new_game_button").onClick.listen(clickEvents);
  querySelector("#language_cz").onClick.listen(clickEvents);
  querySelector("#language_de").onClick.listen(clickEvents);
  querySelector("#language_en").onClick.listen(clickEvents);
  querySelector("#low_difficulty").onClick.listen(clickEvents);
  querySelector("#middle_difficulty").onClick.listen(clickEvents);
  querySelector("#high_difficulty").onClick.listen(clickEvents);
  querySelector("#memory_type_destinations").onClick.listen(clickEvents);
//  querySelector("#memory_type_drawings").onClick.listen(clickEvents);
  querySelector("#memory_type_animals").onClick.listen(clickEvents);
  querySelector("#memory_type_birds").onClick.listen(clickEvents);
  reset();
}
