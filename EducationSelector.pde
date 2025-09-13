import controlP5.*;  // Importerer ControlP5 som er et GUI-bibliotek til sliders, knapper osv

// Declares variabler cp5 af ControlP5 klasse, mc af MatchCalculator klasse og quiz af Quiz klasse
ControlP5 cp5;
Quiz quiz;
MatchCalculator mc;

// Dannes et arraylist som gemmer de bedste matches af typen MatchResult
ArrayList<MatchResult> topResults = new ArrayList<MatchResult>();

void setup() {
  // Størrelse på canvas, ingen kantlinjer og sort baggrund sættes
  size(1200, 700);
  noStroke();
  background(0);

  // Ny cp5 oprettes
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("SansSerif", 12));

  // Der dannes 5 forskellige tabs, fire for spørgsmål og et for resultater
  Tab tab1 = cp5.addTab("Spørgsmål 1");
  Tab tab2 = cp5.addTab("Spørgsmål 2");
  Tab tab3 = cp5.addTab("Spørgsmål 3");
  Tab tab4 = cp5.addTab("Spørgsmål 4");
  cp5.addTab("Resultater");


  // Introduktionstekster til forsiden i form af textlabels
  cp5.addTextlabel("introTitle")
    .setText("Besvar på spørgsmålene for at finde den STEM bachelor uddannelse på AAU der matcher dig bedst!")
    .setFont(createFont("SansSerif", 20))
    .setPosition(width / 7, height / 3)
    .setColor(color(255));

  cp5.addTextlabel("introSubtitle")
    .setText("Besvar alle spørgsmålene på de forskellige tabs, tryk på submit, og gå hen på resultat tab for at finde dit resultat")
    .setFont(createFont("SansSerif", 14))
    .setPosition(width / 5, height / 2.5)
    .setColor(color(200));

  // Quiz objekt med spørgsmål oprettes
  quiz = new Quiz("quiz.json");

  // Der tiljøes sliders til alle spørgsmål
  createQuestionSliders(tab1, tab2, tab3, tab4);

  // Submit knap til at indsende svar
  cp5.addButton("submitAnswers")
    .setLabel("Submit svar")
    .setPosition(50, 600)
    .setSize(120, 30)
    .moveTo(tab4);
}

void draw() {
  background(0); // Baggrund opdateres konstant til sort ved draw
}

// Funktion der håndtærer klik på submit knappen
void controlEvent(ControlEvent theEvent) {
  // Hvis submit knappen er trukket, så samles alle svarene på sliders i en arrayliste af floats ved navn answers
  if (theEvent.getName().equals("submitAnswers")) {
    println("Svar indsendt!");
    ArrayList<Integer> answers = fetchAnswersFromUI();
    topResults = calculateMatches(answers);
    printMatches(topResults); // Funktion til at resultater udskrives i konsollen bliver kaldt
    showTopMatchesGUI(topResults); // Funktion til at top 5 resultater fremvises i gui bliver kaldt
    cp5.getTab("Resultater").bringToFront(); // Skifter tab til resultater tab
  }
}

// Funktion der laver et MatchCalculator objekt og returnerer beregnede matches
private ArrayList<MatchResult> calculateMatches(ArrayList<Integer> answers) {
  // MatchCalculator objekt instanceres
  mc = new MatchCalculator();
  // Resultater sammenlignes med fagområder til de forskellige uddannelse og gemmes i topResults
  topResults = mc.calculateMatches(quiz.getQuestions(), answers);
  return topResults;
}

// Henter alle brugerens slider svar fra GUI og gemmer dem som heltal i en liste
private ArrayList<Integer> fetchAnswersFromUI() {
  ArrayList<Integer> answers = new ArrayList<Integer>();
  for (int i = 0; i < quiz.getQuestions().size(); i++) {
    answers.add((int)(cp5.getController("slider_" + i).getValue()));
  }
  return answers;
}

// Funktion til at udskrive alle resultater i konsollen, hvilket kan give et overblik over ande uddannelser end dem i top 5
private void printMatches(ArrayList<MatchResult> matches) {
  for (MatchResult match : matches) {
    println(match.education.getName() + " → " + nf(match.percentage, 0, 1) + "%");
  }
}

// Funktion til at top 5 resultater fremvises i GUI
void showTopMatchesGUI(ArrayList<MatchResult> matches) {

  // Fjerner tidligere viste resultater (alle TextLabels fra "Resultater" tab)
  java.util.List<ControllerInterface<?>> controls = cp5.getAll();
  for (ControllerInterface<?> control : controls) {
    if (control.getTab() == cp5.getTab("Resultater")) {
      cp5.remove(control.getName());
    }
  }

  // Variabel til hvor mange uddannelser der kan blive vist
  int maxToShow = min(5, matches.size());
  //start y værdi
  int y = 60;

  // For loop for at display uddannelserne der passer en bedst, deres beskrivelse og deres efterfølgende uddannelser
  for (int i = 0; i < maxToShow; i++) {
    MatchResult result = matches.get(i);
    Education education = result.getEducation();

    cp5.addTextlabel("matchTitle_" + i)
      .setText("Uddannelserne der matcher dig bedst er:")
      .setPosition(50, 50)  // Justér placering som du vil
      .setFont(createFont("SansSerif", 20))  // Stor font til titel
      .setColor(color(255))
      .moveTo("Resultater");  // Sørg for den vises i korrekt faneblad

    cp5.addTextlabel("resTitle_" + i)
      .setText((i + 1) + ". " + education.getName() + " (" + nf(result.getPercentage(), 0, 1) + "%)")
      .setPosition(50, y+25)
      .setFont(createFont("SansSerif", 18))
      .setColor(color(255))
      .moveTo("Resultater");

    cp5.addTextlabel("resDesc_" + i)
      .setText("Beskrivelse: " + education.getDescription())
      .setPosition(50, y + 50)
      .setFont(createFont("SansSerif", 12))
      .setColor(color(200))
      .moveTo("Resultater");

    cp5.addTextlabel("resEfter_" + i)
      .setText("Efterfølgende uddannelse: " + education.getNextEducation())
      .setPosition(50, y + 75)
      .setFont(createFont("SansSerif", 12))
      .setColor(color(180))
      .moveTo("Resultater");

    y += 100; // Der ligges 100 til y, og man rykker ned til næste resultat i top 5
  }
}

// Oprettes sliders til spørgsmål, som fordeles på de forskellige tabs
void createQuestionSliders(Tab t1, Tab t2, Tab t3, Tab t4) {
  ArrayList<Question> questions = quiz.getQuestions();
  int total = questions.size();
  int perTab = ceil(total / 4.0);
  int sliderWidth = 200;
  int sliderHeight = 15;
  int startX = 50;
  int startY = 70;
  int gapY = 30;

  for (int i = 0; i < total; i++) {
    Question q = questions.get(i); // Henter det aktuelle spørgsmål
    int idxInTab = i % perTab; // Finder placering inden for fanen
    int y = startY + idxInTab * gapY; // Beregner y-positionen til slideren i fane ift placering

    // Beregnes hvilken fane spørgsmålet skal vises i
    Tab targetTab;
    if (i < perTab) targetTab = t1;
    else if (i < perTab * 2) targetTab = t2;
    else if (i < perTab * 3) targetTab = t3;
    else targetTab = t4;

    // Her customizer man slidersene ved at sætte placering, størrelse, farver og hvilke værdier man kan vælge
    cp5.addSlider("slider_" + i)
      .setPosition(startX, y)
      .setSize(sliderWidth, sliderHeight)
      .setRange(1, 10)  // Værdier fra 1-10
      .setNumberOfTickMarks(10)  // Visuelle markeringer ved hel tal
      .snapToTickMarks(true)     // Alle tal snapper til hel tal
      .setValue(5)  // Oprendelig værdi
      .setLabel(q.getText())
      .setColorForeground(color(45, 87, 57))
      .setColorActive(color(78, 45, 87))
      .setColorBackground(color(87, 45, 45))
      .moveTo(targetTab); // Slider placeres i rigtige tab
  }
}
