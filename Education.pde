// Klasse der repræsenterer skabelonen for en bacheloruddannelse i quizsystemet
public class Education {
  private String name; // Navnet på uddannelsen
  private String description; // Kort beskrivelse om uddannelsen
  private String nextEducation; // Hvad man kan studerer efter uddannelsen
  private ArrayList<String> subjects; // Liste over fire relevante fagområder for uddannelsen

  // Konstruktor for education klassen, opretter education-objekt med alle fire informationer
  public Education(String name, String description, String nextEducation, ArrayList<String> subjects) {
    this.name = name;
    this.description = description;
    this.nextEducation = nextEducation;
    this.subjects = subjects;
  }

  // Funktioner til at hente information fra objektet
  public String getName() {
    return name;
  }

  public String getDescription() {
    return description;
  }

  public String getNextEducation() {
    return nextEducation;
  }

  public ArrayList<String> getSubjects() {
    return subjects;
  }
}
