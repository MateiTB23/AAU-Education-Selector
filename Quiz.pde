// Inspireret af "Belbin" lavet af Matei Tudor Brezoi AATG R22

// Quiz klasse der repræsentere hele quiz systemet med spørgsmål, som bruges til at finde uddannelsen der passer brugeren
public class Quiz {
  private ArrayList<Question> questions; // Liste af alle spørgsmål i quizzen

  public Quiz(String fileName) {
    JSONObject json = loadJSONObject(fileName); // Indlæser quiz JSON fil
    JSONArray questionsArray = json.getJSONArray("questions"); // Indlæser questions array
    
    questions = new ArrayList<Question>();

    // For loop til at parse education objekter fra JSON
    for (int i = 0; i < questionsArray.size(); i++) {
      JSONObject questionObject = questionsArray.getJSONObject(i); // Henter et spørgsmål og gemmer i JSONObject questionObject
      String question = questionObject.getString("spoergsmaal"); // Henter spoergsmål
      String subject = questionObject.getString("fagOmraade"); // Henter fagOmråde
      Subject subjectEnumEntry = Subject.valueOf(subject);
      questions.add(new Question(question, subjectEnumEntry));
    }
  }
  
  // Offentlig funktion der returnerer hele spørgsmålslisten
  public ArrayList<Question> getQuestions() {
    return this.questions;
  }
}
