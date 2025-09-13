// MatchCalculator klasse der beregner hvilke uddannelser der matcher bedst med brugerens svar, baseret på fagområderne og brugernes score til spørgsmålene
public class MatchCalculator {
  private ArrayList<Education> allEducations;

  public MatchCalculator() {     
    // Data bliver indslæst fra uddannelse.json ved hjælp af Dataloader objekt
    DataLoader dataLoader = new DataLoader("uddannelse.json");
  
    // Alle bachelor uddannelserne samles i en af arrayliste af typen Education ved navn allEducations
    allEducations = new ArrayList<Education>();
    allEducations.addAll(dataLoader.getITBachelorEducations());
    allEducations.addAll(dataLoader.getIngenioerBachelorEducations());
    allEducations.addAll(dataLoader.getScienceBachelorEducations());
    allEducations.addAll(dataLoader.getMathBachelorEducations());
  }

  // Der beregenes match-resultater for en arrayliste af uddannelser baseret på brugerens svar på spørgsmålene hørende til fagområderne.
  public ArrayList<MatchResult> calculateMatches(
    ArrayList<Question> questions, // Arrayliste med alle spørgsmål i quizzen (med tilhørende fagområder)
    ArrayList<Integer> answers // Arrayliste med alle brugerens svar på spørgsmålene
    ) {
    ArrayList<MatchResult> results = new ArrayList<>(); // Sorteret liste af MatchResult-objekter med de bedste match uddannelser først
    final float MAX_SCORE = 40.0; // Maks score der kan opnås for en uddannelse i quizzen

    // Hver uddannelse gennemgåes og udregner dens score
    for (Education education : allEducations) {
      int score = 0;

      // For hvert spørgsmål tjekkes der, om uddannelsen matcher fagområdet
      for (int i = 0; i < questions.size(); i++) {
        Question q = questions.get(i); // Spørgsmål nummer ihentes
        int answer = answers.get(i); // Brugerens svar på spørgsmålet hentes
        String subject = q.getSubject().name(); // Fagområdet som spørgsmålet handler om hentes (skrevet i uppercase)

        // Hvis uddannelsen har dette fagområde, tilføj brugerens svar til scoren
        if (education.getSubjects().contains(subject)) {
          score += answer;
        }
      }

      // Udregnes hvor stor en procentdel af max score den givne uddannelse har opnået
      float percentage = (score / MAX_SCORE) * 100; // Score beregnes i procent ift max mulige score
      results.add(new MatchResult(education, score, percentage)); // Resultatet for den givne uddannelse bliver tilføjet til listen
    }
    // Listen af uddannelser sorteres ved bubblesort, så de bedste matches kommer først
    bubbleSort(results);
    return results; // Sorterede liste returneres
  }

  // Bubblesort Funktion der sorterer arraylisten af MatchResult baseret på hvilken der matcher bedst med brugeren
  public void bubbleSort(ArrayList<MatchResult> list) {
    int n = list.size();
    boolean swapped;
    for (int i = 0; i < n - 1; i++) {
      swapped = false;
      for (int j = 0; j < n - i - 1; j++) {
        // Der sorteres i faldende rækkefølge, så man bytter hvis det næste element er større
        if (list.get(j).percentage < list.get(j + 1).percentage) {
          MatchResult temp = list.get(j);
          list.set(j, list.get(j + 1));
          list.set(j + 1, temp);
          swapped = true;
        }
      }

      // Hvis der ikke blev byttet rundt i denne iteration, er listen allerede sorteret
      if (!swapped) break;
    }
  }
}
