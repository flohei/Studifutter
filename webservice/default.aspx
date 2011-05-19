<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="speiseplan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
<title>Mensa Speiseplan</title> 
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />

 <link rel="stylesheet" href="WebApp/Design/Render.css" /> <script type="text/javascript"  src="WebApp/Action/Logic.js"></script>
 
 
 </head> <body> <div id="WebApp"> <div id="iHeader"> <a href="#" id="waBackButton" style="left: 4px; top: 5px">Back</a> <span id="waHeadTitle">
     Mensateria</span> </div> <div id="iGroup"> <div class="iLayer" id="waHome" title="Home"> 
     
 
 <div class="iList">
			<h2>
                Mensa Speiseplan</h2>
			<ul class="iArrow">
				
                    <asp:Literal ID="litListe" runat="server"></asp:Literal>
                    
                    <li><a href="#_futtern"><em>Wo futtern?</em><small>ER - Mensa Langemarckplatz, ER - Südmensa, N - Insel Schütt, N - Regensburger Straße, N - Mensateria, Eichstätt, Ingolstadt, Ansbach</small></a></li>
                    
                    
                    
                    
                    
                    </ul>
</div>
	
 <div class="iBlock"> <h1>
     &nbsp;</h1> 
  </div> 
  

  
  </div> 
  
   
	
  <div class="iLayer" id="wafuttern" title="Wo futtern?">
  
  
  <div class="iList">
			<h2>
                Mensen</h2>
			<ul class="iArrow">
				
                    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                    
                                    
                    
                    

				                  
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Langemarckplatz+4,+91054+Erlangen&sll=49.454707,11.094432&sspn=0.011996,0.028024&ie=UTF8&ll=49.594773,11.009846&spn=0.011961,0.028024&z=15&iwloc=addrn"><em>Mensa Langemarckplatz Erlangen</em><small>Langemarckplatz 4, 91054 Erlangen</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Erwin-Rommel-Str.+60,+91058+Erlangen&sll=49.594773,11.009846&sspn=0.011961,0.028024&ie=UTF8&ll=49.576995,11.029758&spn=0.011966,0.028024&z=15&iwloc=addr"><em>Südmensa Erlangen</em><small>Erwin-Rommel-Str. 60, 91058 Erlangen</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Andreij-Sacharow-Platz+1,+90403+N%C3%BCrnberg&sll=49.576995,11.029758&sspn=0.011966,0.028024&ie=UTF8&ll=49.455544,11.084003&spn=0.011996,0.028024&z=15&iwloc=addr"><em>Mensa Insel Schütt Nürnberg</em><small>Andreij-Sacharow-Platz 1, 90403 Nürnberg</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Regensburger+Str.+160,+90478+N%C3%BCrnberg&sll=49.455544,11.084003&sspn=0.011996,0.028024&ie=UTF8&ll=49.440562,11.112843&spn=0.011999,0.028024&z=15&iwloc=addr"><em>Mensa Regensburger Straße Nürnberg</em><small>Regensburger Str. 160, 90478 Nürnberg</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Wollentorstr.+4,+90409+N%C3%BCrnberg&sll=51.151786,10.415039&sspn=11.864215,28.696289&ie=UTF8&ll=49.454707,11.094432&spn=0.011996,0.028024&z=15&iwloc=cent"><em>Mensateria Nürnberg</em><small>Wollentorstr. 4, 90409 Nürnberg</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Universit%C3%A4tsallee+2,+85072+Eichst%C3%A4tt&sll=49.440562,11.112843&sspn=0.011999,0.028024&ie=UTF8&ll=48.888649,11.190262&spn=0.012134,0.028024&z=15&iwloc=addr"><em>Eichstätt</em><small>Universitätsallee 2, 85072 Eichstätt</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Esplanade+10,+85049+Ingolstadt&sll=48.888649,11.190262&sspn=0.012134,0.028024&ie=UTF8&ll=48.768438,11.43136&spn=0.012163,0.028024&z=15&iwloc=addr"><em>Ingolstadt</em><small>Esplanade 10, 85049 Ingolstadt</small></a></li>
                    <li><a href="http://maps.google.de/maps?f=q&hl=de&geocode=&q=Residenzstra%C3%9Fe+8,+91522+Ansbach&sll=48.768438,11.43136&sspn=0.012163,0.028024&ie=UTF8&ll=49.306322,10.569792&spn=0.012032,0.028024&z=15&iwloc=addr"><em>Ansbach</em><small>Residenzstraße 8, 91522 Ansbach</small></a></li>
               
                  
                    
                           </ul>
</div>
</div>
  
  
         
             
             
	<asp:Literal ID="litTage" runat="server" ></asp:Literal>&nbsp;<br />
         <div class="iBlock">
             
     © 2008 <a href="mailto:HeidingsfeldeSi35434@ohm-hochschule.de">Simon Heidingsfelder</a>
         </div>
  
   </div> </body> </html> 
