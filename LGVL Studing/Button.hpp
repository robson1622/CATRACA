
#include "Button.cpp"

enum ButtonType{
    LogOfTrips = 1,
    Configurations = 2,
    NewTrip = 3
};



class ButtonAbstract{
    private:
        //aquí vão os atributos dos botão

    public:
        ButtonAbstract();
};

class ButtonPresentation{
    private:
        ButtonType type;
        void CreateLogOfTripButton();
        void CreateConfigurationsButton();
        void CreateNewTripButton();
    public:
        ButtonPresentation(ButtonType t);
        ButtonType getTypeButton();
        //responsável por desenhar na tela
        //somente Presentation possue essa função
        void drawn();
};

class ButtonController{
    private:
        ButtonAbstract * abstract;
        ButtonPresentation * presentation;
    
    public:
        ButtonController(ButtonAbstract abs, ButtonPresentation pre);
        ButtonController(ButtonAbstract *abs, ButtonPresentation *pre);
};