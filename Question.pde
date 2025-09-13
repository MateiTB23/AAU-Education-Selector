// Inspireret af "Belbin" lavet af Matei Tudor Brezoi AATG R22
// klasse der repræsenterer et enkelt spørgsmål i quizzen, som hører til specifikt fagområde
public class Question {
  private String text; // selve spørgsmålet
  private Subject subject; //fagområdet spørgsmålet hører til

  // constructor som opretter spørgsmål med tilhørende fagområde
  public Question(String text, Subject subject) {
    this.text = text;
    this.subject = subject;
  }
  
  // funktion der returnerer spørgsmålet
  public String getText() {
    return text;
  }
  
  // funktion der returnerer fagområdet spørgsmålet hører til
  public Subject getSubject() {
    return subject;
  }
}
