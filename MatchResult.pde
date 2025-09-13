// MatchResult klasse til resultatet af matchet mellem uddannelserne og brugerens scvar
public class MatchResult {
  private Education education; // Den givne uddannelse
  private int score; // Den samlede score for den givne uddannelse
  private float percentage; // Den procentdel af den maskimale score som uddannelsen fik

  // Constructor til MatchResult klassen, som bruges til at oprette et nyt match-resultat med tilhørende uddannelse og yderligere informationer
  public MatchResult(Education education, int score, float percentage) {
    this.education = education; // Gemmer uddannelsen
    this.score = score; // Gemmer brugerens score på denne uddannelse
    this.percentage = percentage; // Gemmer hvor godt den matcher i procent
  }

  public Education getEducation() {
    return education;
  }

  public int getScore() {
    return score;
  }

  public float getPercentage() {
    return percentage;
  }
}
