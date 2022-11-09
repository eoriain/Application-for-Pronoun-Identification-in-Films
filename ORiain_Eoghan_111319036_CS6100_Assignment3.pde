import controlP5.*;
import rita.*;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.List;
import java.util.ListIterator;
import java.util.stream.Collectors;
import java.awt.Color;
import java.util.ArrayList;
import java.util.Arrays;

ControlP5 cp5;

DropdownList movieDropdown; 
ScrollableList characterDropdown; 
Chart pronounChart, resultTwoChart, pronounTotalChart;
Textlabel pronounText, titleText, subtitleText, stepOneText, stepTwoText, resultText, resultTwoText, resultThreeText, assignmentInfoText;
Object characterIdSelected;

Table titleTable, characterTable, dialogTable;
int movieIdSelectedIndex;
int characterNameSelectedIndex;
String movieIdSelected;
String characterIdSelectedString;
String characterNameSelected;
String selected = null;
ArrayList script;
HashMap movieCharacters, characterDialog;
PImage filmBackground;

void setup() {
  size(771, 969);
  filmBackground = loadImage("Film_Background.jpg");
  clear();
  cp5 = new ControlP5(this);
  
  titleText = cp5.addTextlabel("Title")
                  .setText("Assignment 3 - Movie Personal Pronoun Analysis")
                  .setPosition(100,15)
                  .setSize(100, 30)
                  .setColor(0)
                  .setFont(createFont("Arial",25))
                  ;
  stepOneText = cp5.addTextlabel("Step 1")
                  .setText("Step 1 - Pick A Movie")
                  .setPosition(50,160)
                  .setSize(200, 30)
                  .setColor(0)
                  .setFont(createFont("Arial",20))
                  ;
  stepTwoText = cp5.addTextlabel("Step 2")
                  .setText("Step 2 - Pick A Character")
                  .setPosition(395,160)
                  .setSize(200, 30)
                  .setColor(0)
                  .setFont(createFont("Arial",20))
                  ;
  resultText = cp5.addTextlabel("Results")
                  .setText("The Results:")
                  .setPosition(50,375)
                  .setSize(200, 30)
                  .setColor(0)
                  .setFont(createFont("Arial",20))
                  ;
  pronounText = cp5.addTextlabel("label")
                  .setText("     I          Me        We         Us       You      She       Her        He       Him         It       They     Them")
                  .setPosition(50,585)
                  .setSize(800, 30)
                  .setColor(0)
                  .setFont(createFont("Arial",15))
                  ;
  assignmentInfoText = cp5.addTextlabel("Information")
                  .setText("Module: CS6100 - Authoring\nAssignment No.3\n\nStudent Name: Eoghan Ó Riain\nStudent No.: 111319036\nClass: MScIM 2021/2022")
                  .setPosition(550, 815)
                  .setSize(230, 50)
                  .setColor(0)
                  .setFont(createFont("Arial",12))
                  ; 
  
  titleTable = loadTable("movie_titles_metadata_header(1).csv", "header");
  movieDropdown = cp5.addDropdownList("Movies")
                  .setPosition(50, 190)
                  .setSize(325, 175)
                  .setHeight(190)
                  .setItemHeight(20)
                  .setBarHeight(20)
                  .setColorBackground(color(131, 103, 199))
                  .setColorActive(color(86, 3, 173))
                  ;

  for (TableRow row : titleTable.rows()) {
    //int movieYear = row.getInt("MovieYear");
    String movieName = row.getString("MovieName");
    String movieID = row.getString("MovieID");
    movieDropdown.addItem(movieName, 1);
  }

  characterTable = loadTable("movie_lines_header.csv", "header");          
}

void controlEvent(ControlEvent theEvent) {
     if (theEvent.isController() && movieDropdown.isMouseOver()) {
       println("Selected Movie ID:");
       int filterTitle = int(theEvent.getController().getValue());
       movieIdSelected = titleTable.getString(filterTitle, "MovieID");
       println(movieIdSelected);
       movieIdSelectedIndex = characterTable.findRowIndex(movieIdSelected, "MovieID");
       println(movieIdSelectedIndex);
       
     movieCharacters = new HashMap<String, String>();  
      for (TableRow row : characterTable.findRows(movieIdSelected, "MovieID")) {
         String characterName = row.getString("CharacterName");
         String movieId = row.getString("MovieID");
         String characterId = row.getString("CharacterID");
         if(movieId.equals(movieIdSelected)){
           movieCharacters.put(characterName,characterId);
         } 
       } 
     characterDropdown = cp5.addScrollableList("Characters")
                  .setPosition(400, 190)
                  .setSize(325, 175)
                  .setHeight(190)
                  .setItemHeight(20)
                  .setBarHeight(20)
                  .setColorBackground(color(131, 103, 199))
                  .setColorActive(color(86, 3, 173))
                  .addItems(movieCharacters)
                  ; 
                  print(movieCharacters);
     }

     if (theEvent.isController() && characterDropdown.isMouseOver()) {
       println("Selected Character ID:");
       int filterName = int(theEvent.getController().getValue());
       characterIdSelected = movieCharacters.values().toArray()[filterName];
       characterIdSelectedString = characterIdSelected.toString();
       characterNameSelectedIndex = characterTable.findRowIndex(characterIdSelectedString, "CharacterID");
       characterNameSelected = characterTable.getString(characterNameSelectedIndex, "CharacterName");

       println(characterNameSelected, "From MovieID " + movieIdSelected);

        characterDialog = new HashMap<String, String>();  
        for (TableRow row : characterTable.findRows(characterIdSelectedString, "CharacterID")) {
          String movieLine = row.getString("MovieLine");
          String characterLineId = row.getString("CharacterID");
          characterDialog.put(movieLine, characterLineId);
          String [] characterScript = RiTa.pos(movieLine);
        
          println(movieLine);
          println(characterScript);  
          
          List<String> characterScriptReview = new ArrayList<>();
          for (String marker : characterScript) {
            characterScriptReview.add(marker);
          }
          if (characterScriptReview.contains("prp")) {
            withPronounCount++;
          } else {
            withoutPronounCount++;
          }
        
          if (movieLine.contains("I ")) {
            I_prp++;
          } if (movieLine.contains(" me")){
            me_prp++;
          } if (movieLine.contains(" we")){
            we_prp++;
          } if (movieLine.contains(" us")){
            us_prp++;
          } if (movieLine.contains(" you")){
            you_prp++;
          } if (movieLine.contains(" she")){
            she_prp++;
          } if (movieLine.contains(" her")){
            her_prp++;
          } if (movieLine.contains(" he")){
            he_prp++;
          } if (movieLine.contains(" him")){
            him_prp++;
          } if (movieLine.contains(" it")){
            it_prp++;
          } if (movieLine.contains(" they")){
            they_prp++;
          } if (movieLine.contains(" them")){
            them_prp++;
          }
         }
        }
     
  pronounPercentage = withPronounCount/(withPronounCount+withoutPronounCount)*100;
  print("I=" + I_prp);
  print("Me=" + me_prp);
  print("We=" + we_prp);
  print("Us=" + us_prp);
  print("You=" + you_prp);
  print("She=" + she_prp);
  print("Her=" + her_prp);
  print("He=" + he_prp);
  print("Him=" + him_prp);
  print("It=" + it_prp);
  print("They=" + they_prp);
  print("Them=" + them_prp);
  
  int max1 = max(I_prp, me_prp, we_prp);
  int max2 = max(us_prp, you_prp, she_prp);
  int max3 = max(her_prp, he_prp, him_prp);
  int max4 = max(it_prp, they_prp, them_prp);
  int max5 = max(max1, max2, max3);

  pronounChart = cp5.addChart("Pronoun Chart")
                   .setPosition(50, 410)
                   .setSize(650, 175)
                   .setRange(0, max(max4, max5))
                   .setView(Chart.BAR_CENTERED)
                   ;
  pronounChart.getColor().setBackground(color(255, 1));
  pronounChart.addDataSet("Pronouns");
  pronounChart.setColors("Pronouns", color(220,220,220) , color(86, 3, 173) );
  pronounChart.setData("Pronouns", new float[]{I_prp, me_prp, we_prp, us_prp, you_prp, she_prp, her_prp, he_prp, him_prp, it_prp, they_prp, them_prp});
  
  resultTwoText = cp5.addTextlabel("Result Percentage")
                  .setText(" " + characterNameSelected + " uses a personal pronoun in \n              "+pronounPercentage+"% of their lines.")
                  .setPosition(25, 900)
                  .setSize(230, 50)
                  .setColor(0)
                  .setFont(createFont("Arial",12))
                  ;   
  resultTwoChart = cp5.addChart("Percentage Chart")
                  .setPosition(100, 785)
                  .setSize(100,100)
                  .setRange(0,100)
                  .setView(Chart.PIE)
                  ;
   resultTwoChart.getColor().setBackground(color(255, 1));
   resultTwoChart.addDataSet("Percentage Pronouns");
   resultTwoChart.setColors("Percentage Pronouns", color(220,220,220) , color(86, 3, 173) );
   resultTwoChart.setData("Percentage Pronouns", new float[]{100.0-pronounPercentage, pronounPercentage});               
                  
  resultThreeText = cp5.addTextlabel("Pronoun Result")
                  .setText("Frequency of Personal Pronoun Occurrence\n          (Refer to The Results Section)")
                  .setPosition(273, 900)
                  .setSize(230, 50)
                  .setColor(0)
                  .setFont(createFont("Arial",12))
                  ;  
  pronounTotalChart = cp5.addChart("Pronoun Total")
                  .setPosition(340, 785)
                  .setSize(100,100)
                  .setRange(0,max(max4, max5))
                  .setView(Chart.PIE)
                  ;
   pronounTotalChart.getColor().setBackground(color(255, 1));
   pronounTotalChart.addDataSet("Pronoun Total");
   pronounTotalChart.setColors("Pronoun Total", color(220,220,220) , color(86, 3, 173) );
   pronounTotalChart.setData("Pronoun Total", new float[]{I_prp, me_prp, we_prp, us_prp, you_prp, she_prp, her_prp, he_prp, him_prp, it_prp, they_prp, them_prp});



}
void draw() {
  background(filmBackground);
}
