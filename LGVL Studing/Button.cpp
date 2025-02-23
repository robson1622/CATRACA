
#include "Button.hpp"


ButtonAbstract::ButtonAbstract(){
    
}



void ButtonPresentation::CreateLogOfTripButton(){

}
void ButtonPresentation::CreateConfigurationsButton(){

}
void ButtonPresentation::CreateNewTripButton(){

}
ButtonPresentation::ButtonPresentation(ButtonType t){
    type = t;
}
ButtonType ButtonPresentation::getTypeButton(){
    return type;
}
//responsável por desenhar na tela
//somente Presentation possue essa função
void ButtonPresentation::drawn(){

}

ButtonController::ButtonController(ButtonAbstract abs, ButtonPresentation pre){
    abstract = new ButtonAbstract();
    presentation = new ButtonPresentation(pre.getTypeButton());
}
ButtonController::ButtonController(ButtonAbstract *abs, ButtonPresentation *pre){
    abstract = abs;
    presentation = pre;
}