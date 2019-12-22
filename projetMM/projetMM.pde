import fr.dgac.ivy.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Random;
import java.awt.Point;

private Ivy bus;
String forme = "", commande = "", mvt = "", couleur = "";
String OldForme = "", OldCouleur = "";
//old triangle value
Float old_T1X, old_T1Y, old_T2X, old_T2Y, old_T3X, old_T3Y;
Random rand = new Random(); //<>//
float n1,n2;
int cpt_forme = 0;
boolean validation = false, DoItOnce = false, SecurityForme = true;
Forme tab_forme[] = new Forme[20];
Forme temp; 


void setup() {
  size(700, 700);  
  background(170);
  bus = new Ivy("OverlodMM","OverlordMM on watch", null);
  
  //LANCEMENT SUR LE BUS VROUM VROUM
  try {
    bus.start("127.255.255.255:2010");
  }
  catch (IvyException ie) {
    System.err.println("Error : "+ ie.getMessage());
  }
  
  try {
    bus.sendMsg("OverlordMM Say=On Watch");
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }
  
  //ICAR FORME GESTION
  try {
   bus.bindMsg("^ICAR Gesture=(.*)", new IvyMessageListener() {
  // callback
    public void receive(IvyClient client, String[] args) 
    {
      print(args[0] + "\n");
      forme = args[0];
    }
  }); 
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }
  
  
  //SRA5 MULTI GESTION
  //GESTION ACTION
  try {
   bus.bindMsg("^sra5 Parsed=Action:(initialiser||creer||dessiner||supprimer) Confidence=(.*) NP=(.*) Num_A=(.*)$", new IvyMessageListener() {
  // callback
    public void receive(IvyClient client, String[] args) 
    {
      commande = args[0];
      print(commande + "\n");
    }
  }); 
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }
  
  //GESTION DEPLACEMENT
  try {
   bus.bindMsg("^sra5 Parsed=Action:(.*) Position:(.*) Confidence=(.*) NP=(.*) Num_A=(.*)", new IvyMessageListener() {
  // callback
    public void receive(IvyClient client, String[] args) 
    {
      commande = args[0];
      mvt = args[1];
      print(commande + " " + mvt + "\n");
      DoItOnce = true;
    }
  }); 
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }
  
  //GESTION VALIDATION "ici" "sur le clic"
  try {
   bus.bindMsg("^sra5 Parsed=(Validation) Confidence=(.*) NP=(.*) Num_A=(.*)", new IvyMessageListener() {
  // callback
    public void receive(IvyClient client, String[] args) 
    {
      print("validation\n");
      validation = true;
    }
  }); 
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }
  
  //GESTION COULEUR DE LA FORME
  try {
   bus.bindMsg("^sra5 Parsed=Couleur:(.*) Confidence=(.*) NP=(.*) Num_A=(.*)", new IvyMessageListener() {
  // callback
    public void receive(IvyClient client, String[] args) 
    {
      couleur = args[0];
      print(couleur + "\n");
    }
  }); 
  }
  catch (IvyException ie) {
    System.err.println("Error: "+ ie.getMessage());
  }

}

 

void draw() 
{
    //SI ON A TOUTES LES INFOS ON LANCE LE DESSIN DE LA FORME ET SON STOCKAGE DANS LE TABLEAU (max 20 formes)
    if(validation && !(forme.equals("")))
    {
        
        if(commande.equals("initialiser")|| commande.equals("creer")|| commande.equals("dessiner"))
        {

          
           
          Point p = new Point((int)n1,(int)n2);
          if(forme.equals("Carre"))
          {
            temp = new Rectangle(p);
            
          }
          if(forme.equals("Cercle"))
          {      
            temp = new Cercle(p);
             
          }
          if(forme.equals("Triangle"))
          {
            temp = new Triangle(p);          
          }
          
          if(couleur.equals("bleu"))
          {
            temp.setColor(color(0,0,255));
          }
          if(couleur.equals("rouge"))
          {
            temp.setColor(color(255,0,0));
          }
          if(couleur.equals("vert"))
          {
            temp.setColor(color(0,255,0));
          }
          if(couleur.equals("jaune"))
          {
            temp.setColor(color(255,255,0));
          }
          if(couleur.equals("blanc"))
          {
            temp.setColor(color(255,255,255));
          }
          if(couleur.equals("noir"))
          {
            temp.setColor(color(0,0,0));
          }
          
          tab_forme[cpt_forme] = temp;          
          temp.drawForme();
          
          
          
      }
      validation = false;
      SecurityForme = false;
      couleur = "";
      forme = "";
      n1 = n2 = 0;
      cpt_forme ++;
    }
    
    if(commande.equals("supprimer"))
    {
       background(170); 
       SecurityForme = true;
       cpt_forme = 0;
    }
    
    if(commande.equals("deplacement") && !SecurityForme)
    {
      if(DoItOnce)
      {
         
        background(170); 
        if( cpt_forme > 1);
        {
          for(int i=0; i< cpt_forme - 1;i++)
          {
            tab_forme[i].drawForme();
          }
        }
        
        
       Point temp_p_mov;
       //MVT GAUCHE
       if(mvt.equals("à gauche"))
       {
          temp_p_mov = tab_forme[cpt_forme-1].getLocation();
          tab_forme[cpt_forme-1].setLocation(new Point(temp_p_mov.x-40,temp_p_mov.y));
          tab_forme[cpt_forme-1].drawForme();
       }
       
       //MVT DROITE
       if(mvt.equals("à droite"))
       {
          temp_p_mov = tab_forme[cpt_forme-1].getLocation();
          tab_forme[cpt_forme-1].setLocation(new Point(temp_p_mov.x+40,temp_p_mov.y));
          tab_forme[cpt_forme-1].drawForme();
       }
       
       
       //MVT HAUT
       if(mvt.equals("en haut"))
       {
         temp_p_mov = tab_forme[cpt_forme-1].getLocation();
         tab_forme[cpt_forme-1].setLocation(new Point(temp_p_mov.x,temp_p_mov.y-40));
         tab_forme[cpt_forme-1].drawForme();
       }
       
       //MVT BAS
       if(mvt.equals("en bas"))
       {
        temp_p_mov = tab_forme[cpt_forme-1].getLocation();
        tab_forme[cpt_forme-1].setLocation(new Point(temp_p_mov.x,temp_p_mov.y+40));
        tab_forme[cpt_forme-1].drawForme();
       }
       DoItOnce = false;
    }
  }
}


void mouseClicked()
{
  n1 = mouseX;
  n2 = mouseY;
}
