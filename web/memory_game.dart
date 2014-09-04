import 'dart:html';
import 'dart:async';

const NUM_OF_EACH = 2;
const String CARD_BACK = "images/destinations/00.jpg";

List<String> cardFileNames, cards;
String language = "czech";
int strikes, cardsLeft, trials, numCards = 4 * 4;
ImageElement lastClicked;

/// Translate the user interface
void translate() {
  Map translation = {
    "english": {
      "title_text": "Memory Game",
      "new_game_button": "New Game",
      "strike_text": "Strikes",
      "left_text": "Cards left",
      "info_text": "Start playing by clicking on a card.",
      "difficulty_text": "Difficulty",
      "low_difficulty_text": "low",
      "middle_difficulty_text": "middle",
      "high_difficulty_text": "high",
    },
    "czech": {
      "title_text": "Pexeso",
      "new_game_button": "Nová hra",
      "strike_text": "Pokusů",
      "left_text": "Zbývá karet",
      "info_text": "Začněte hrát kliknutím na některou z karet.",
      "difficulty_text": "Obtížnost",
      "low_difficulty_text": "nízká",
      "middle_difficulty_text": "střední",
      "high_difficulty_text": "vysoká",
    },
    "german": {
      "title_text": "Memory",
      "new_game_button": "Neues Spiel",
      "strike_text": "Schläger",
      "left_text": "Restkarten",
      "info_text": "Fangen Sie an zu spielen, indem Sie auf eine Karte klicken. ",
      "difficulty_text": "Schwierigkeit",
      "low_difficulty_text": "niedrige",
      "middle_difficulty_text": "mittlere",
      "high_difficulty_text": "hohe",
    },
  };

  querySelector('#title_text').text = translation[language]["title_text"];
  querySelector('#new_game_button').text = translation[language]["new_game_button"];
  querySelector('#strike_text').text = translation[language]["strike_text"];
  querySelector('#left_text').text = translation[language]["left_text"];
  querySelector('#info_text').text = translation[language]["info_text"];
  querySelector('#difficulty_text').text = translation[language]["difficulty_text"];
  querySelector('#low_difficulty_text').text = translation[language]["low_difficulty_text"];
  querySelector('#middle_difficulty_text').text = translation[language]["middle_difficulty_text"];
  querySelector('#high_difficulty_text').text = translation[language]["high_difficulty_text"];
}

/// Show the clicked card and its description.
void cardClicked (MouseEvent event) {
  ImageElement clickedCard = event.target;
  
  if (!clickedCard.src.endsWith(CARD_BACK)) {
    return;
  }
  
  Map cardDescriptions = {
    "czech": [
              "Plavba na lodičkách ve Hřensku, foto V. Sojka",
              "Pravčická brána, foto Z. Patzelt",
              "Skalní most Bastei v Saském Švýcarsku, foto Z. Patzelt",
              "Jetřichovické vyhlídky, foto Z. Patzelt",
              "Vyhlídka Belvedér, foto J.Laštůvka",
              "Brtnické ledopády, foto Z. Patzelt",
              "Labský kaňon, foto V. Sojka",
              "Jeskyně víl, foto J. Laštůvka",
              "Tiské stěny a vstup do skalního města, foto Z. Patzelt",
              "Plavba na Lodičkách v soutěskách Křinice, foto V. Sojka",
              "Rozhledna Vlčí hora u Krásné Lípy, foto J. Laštůvka",
              "Rozhledna Děčínský Sněžník, foto J. Laštůvka",
              "Skalní hřib -Tisá, foto Z. Patzelt",
              "Kyjovské údolí, foto V. Sojka",
              "Skalní hrad Šaunštejn, foto V. Sojka",
              "Růžovský vrch, foto M. Rak",
              "Saská stolová hora Lilienstein, foto M. Rak",
              "Rozhledna Jedlová, foto J. Krejčí",
              ],
    "german": [
               "Kamnitzklammen, foto V. Sojka",
               "Prebischtor, foto Z. Patzelt",
               "Bastei, foto Z. Patzelt",
               "Jetřichovice Aussichten, foto Z. Patzelt",
               "Aussichtsplateau Belveder, foto J.Laštůvka",
               "Zeidler Eisfälle, foto Z. Patzelt",
               "Elbtal, foto V. Sojka",
               "Feengrotte, foto J. Laštůvka",
               "Tissaer Wände, foto Z. Patzelt",
               "Kamnitzklammen, foto V. Sojka",
               "Aussichtsturm Wolfsberg, foto J. Laštůvka",
               "Aussichtsturm Hohen Schneeberg, foto J. Laštůvka",
               "Steinpilz - Tisá, foto Z. Patzelt",
               "Khaatal, foto V. Sojka",
               "Schauenstein, foto V. Sojka",
               "Rosenberg, foto M. Rak",
               "Lilienstein, foto M. Rak",
               "Aussichtsturm Tannenberg, foto J. Krejčí",
               ],
    "english": [
                "Kamenice River Canyon, foto V. Sojka",
                "Pravčice Gate, foto Z. Patzelt",
                "Bastei, foto Z. Patzelt",
                "View of Jetřichovice, foto Z. Patzelt",
                "Vantage point Belveder, foto J.Laštůvka",
                "Brtníky icefalls, foto Z. Patzelt",
                "Canyon of the river Labe, foto V. Sojka",
                "Fairy Cave, foto J. Laštůvka",
                "Tisá Cliffs, foto Z. Patzelt",
                "Kamenice River Canyon, foto V. Sojka",
                "Lookout tower Vlčí hora, foto J. Laštůvka",
                "Lookout tower Děčínský Sněžník, foto J. Laštůvka",
                "Mushroom Rock - Tisá, foto Z. Patzelt",
                "Kyjov Valley, foto V. Sojka",
                "Rock Castle Šaunštejn, foto V. Sojka",
                "Růžovský peak, foto M. Rak",
                "Lilienstein, foto M. Rak",
                "Lookout tower Jedlová, foto J. Krejčí",
                ],
  };
  
  int clickedNumber = int.parse(clickedCard.alt);
  clickedCard.src = cards[clickedNumber];
  int cardNumber = int.parse(clickedCard.src.substring(clickedCard.src.length - 6, clickedCard.src.length - 4)) - 1;
  querySelector("#info_text").text = cardDescriptions[language][cardNumber];
  
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
        clickedCard.src = CARD_BACK;
        tempClicked.src = CARD_BACK;
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
    cardFileNames.add("images/destinations/${cardNumber}.jpg");
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
    if (img.id == "card") img.src = CARD_BACK;
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
  reset();
}
