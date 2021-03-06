
# fpmFunction is used to create output$ objects in server.R
fpmFunction <- function( FPM.matrix, mainTitle=NULL ) {   
  roundingDigits <- 2 #Let the caller define in the future (especially with observed values that aren't close to 1.0).
  stripSize <- 24  #Let the caller define in the future?
  valuelabelSize <- 7 # the values of the factor loadings
  axisTitleFontSize <- 18
  axisTextFontSize <- 18
  legendTextFontSize <- 18
  
  # Data prep for ggplot
  dsFORp <- reshape2::melt(FPM.matrix, id.vars=rownames(FPM.matrix))  ## id.vars declares MEASURED variables (as opposed to RESPONSE variable)
  dsFORp <- plyr::rename(dsFORp, replace=c(Var1="Variable", Var2="Factor", value="Loading"))
  dsFORp$Positive <- ifelse(dsFORp$Loading >= 0, "Positive", "Negative") #Or see Recipe 10.8
  dsFORp$LoadingAbs <- abs(dsFORp$Loading) # Long form
#   dsFORp$LoadingPretty <- round(abs(dsFORp$Loading), roundingDigits) # Long form
  dsFORp$LoadingPretty <- round(dsFORp$Loading, roundingDigits) # Long form
  
  dsFORp$LoadingPretty <- paste0(ifelse(dsFORp$Loading>=0, "+", "-"), dsFORp$LoadingPretty)
  #   dsFORp$VariablePretty <- gsub(pattern="_", replacement="\n", x=dsFORp$Variable)
  dsFORp$VariablePretty <- gsub(pattern=" ", replacement="\n", x=dsFORp$Variable)
  # colors <- c("FALSE"="darksalmon" ,"TRUE"="lightskyblue") # The colors for negative and positve values of factor loadings for ggplot

  # Colors for fill and font
  {
  # positive Green, negative Purple
  colorsFill <- c("Positive"="#A6DBA0" ,"Negative"="#C2A5CF") # The colors for negative and positve values of factor loadings for ggplot
  colorFont <- c("Positive"="#008837" ,"Negative"="#7B3294") # The colors for negative and positve values of factor loadings for ggplot
  
#   # positive Organge,negative Purple
#   colorsFill <- c("Positive"="#FDB863" ,"Negative"="#B2ABD2") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#E66101" ,"Negative"="#5E3C99") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Teal,Negative Brown
#   colorsFill <- c("Positive"="#80CDC1" ,"Negative"="#DFC27D") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#018571" ,"Negative"="#A6611A") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Teal,Negative Brown
#   colorsFill <- c("Positive"="#80CDC1" ,"Negative"="#DFC27D") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#018571" ,"Negative"="#A6611A") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Blue, Negative Red
#   colorsFill <- c("Positive"="#92C5DE" ,"Negative"="#F4A582") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#0571B0" ,"Negative"="#CA0020") # The colors for negative and positve values of factor loadings for ggplot
  
  
  } # close color theme selection
  
  
  # Graph definition
  pp <- ggplot(dsFORp, aes(x=Factor, y=LoadingAbs, fill=Positive, color=Positive, label=LoadingPretty)) +
    geom_bar(stat="identity", na.rm=T) +
    geom_text(y=0, vjust=-.1,size=valuelabelSize, na.rm=T) +
    scale_color_manual(values=colorFont, guide="none") +
    scale_fill_manual(values=colorsFill) +
    #   scale_fill_discrete(h=c(0,360)+15, c=100, l=65, h.start=0, direction=1, na.value="grey50") + #http://docs.ggplot2.org/0.9.3/scale_hue.html
    scale_y_continuous(limits=c(0,1.1), breaks=c(.5,1), expand=c(0,0)) +
    facet_grid(VariablePretty ~ .) +
    labs(title=mainTitle, x="Weights", y="Loadings (Absolute)", fill=NULL) + 
    theme_bw() +
    theme(panel.grid.minor=element_blank()) + 
    theme(axis.title=element_text(color="gray30", size=axisTitleFontSize)) + #The labels (eg, 'Weights' & 'Loadings') 
    theme(axis.text.x=element_text(color="gray50", size=axisTextFontSize, vjust=1.3)) + #(eg, V1, V2,...)
    theme(axis.text.y=element_text(color="gray50", size=axisTextFontSize)) + #(eg, 0.5, 1.0)
    theme(strip.text.y=element_text(angle=0, size=stripSize)) + 
    theme(legend.position="blank")
#     theme(legend.text=element_text(size=legendTextFontSize))
  
#   if( k < p ) { #If there's space in the lower right corner of the plot area, then use it.
#     pp <- pp + theme(legend.position=c(1, 0), legend.justification=c(1, 0)) 
#     pp <- pp + theme(legend.background=element_rect(fill="gray70"))
#   }
#   else { #Otherwise, put it outside the plot area.
#     pp <- pp + theme(legend.position="left")
#   } 

  return( pp )
}