// Klasse til at loade og gemme data fra JSON
class DataLoader {
  // Declares et JSON objekt ved navn json, som indeholder alle data
  JSONObject json;

  // Arrays til forskellige slags stem uddannelser
  JSONArray itBachelor, ingenioerBachelor, scienceBachelor, mathBachelor;

  // Constructor til dataloader klassen, hvor data indlæses fra JSON og de fire uddannelsesområder gemmes
  DataLoader(String fileName) {
    json = loadJSONObject(fileName); //Indlæser JSON fil og ggemmer i json

    JSONObject stemUd = json.getJSONObject("STEM_Uddannelser"); // Dannes et JSONObject med stemuddannelserne
    itBachelor = stemUd.getJSONArray("IT_Bachelor"); // It uddannelserne gemmes
    ingenioerBachelor = stemUd.getJSONArray("Ingenioer_Bachelor"); // Ingeniør uddannelserne gemmes
    scienceBachelor = stemUd.getJSONArray("Science_Bachelor"); // Science uddannelserne gemmes
    mathBachelor = stemUd.getJSONArray("Math_Bachelor"); // Matematik uddannelserne gemmes
  }

  // Funktion som der konverterer et JSONArray til en liste af Education-objekter
  ArrayList<Education> loadEducations(JSONArray educations) {
    ArrayList<Education> list = new ArrayList<Education>();

    // For loop til at parse education objekter fra JSON
    for (int i = 0; i < educations.size(); i++) {
      JSONObject education = educations.getJSONObject(i); // Henter en uddannelse og gemmer i JSONObject education
      String name = education.getString("navn"); // Gemmer uddannelsens navn
      String description = education.getString("beskrivelse"); // Gemmer uddannelsens beskrivelse
      // Henter efterfølgende uddannelse, hvis nøglen findes og ikke er tom
      String nextEducation = (education.hasKey("efterfoelgende_uddannelse") && !education.isNull("efterfoelgende_uddannelse"))
        ? education.getString("efterfoelgende_uddannelse").trim() : "";
      // Laver en arraylist over fagområder, hvis de findes
      ArrayList<String> subjects = new ArrayList<String>();
      if (education.hasKey("fagomraader") && !education.isNull("fagomraader")) {
        subjects = parseEducations(education.getString("fagomraader"));
      }// Opretter Education-objekt og tilføjer det til listen af uddannelser
      list.add(new Education(name, description, nextEducation, subjects));
    }
    return list; // Listen returneres
  }

  // Deler en string med fagområder op og formatterer dem
  ArrayList<String> parseEducations(String input) {
    ArrayList<String> result = new ArrayList<String>();
    String[] arr = input.split(","); // Splitter strengen på kommaer
    for (String s : arr) {
      String norm = s.trim();// Fjerner mellemrum før/efter
      // Fjerner punktum, hvis det er der
      if (norm.endsWith(".")) {
        norm = norm.substring(0, norm.length() - 1);
      }
      result.add(norm.toUpperCase()); // Gør alt til store bogstaver
    }
    return result; // Returnerer resultatet
  }

  // Funktioner der returnerer lister af de forskellige uddannelsestyper
  ArrayList<Education> getITBachelorEducations() {
    return loadEducations(itBachelor);
  }

  ArrayList<Education> getIngenioerBachelorEducations() {
    return loadEducations(ingenioerBachelor);
  }

  ArrayList<Education> getScienceBachelorEducations() {
    return loadEducations(scienceBachelor);
  }

  ArrayList<Education> getMathBachelorEducations() {
    return loadEducations(mathBachelor);
  }

  // Udskriver liste af education objekter i konsollen
  void printEducations(ArrayList<Education> educations) {
    for (Education education : educations) {
      println("Navn: " + education.getName());
      println("Beskrivelse: " + education.getDescription());
      println("Efterfølgende uddannelse: " + education.getNextEducation());
      ArrayList<String> subjects = education.getSubjects();
      if (!subjects.isEmpty()) {
        print("Fagområder: ");
        for (String subject : subjects) {
          print(subject + " ");
        }
        println();
      }
      println("-------------");
    }
  }
}
