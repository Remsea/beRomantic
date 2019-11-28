class PartenairesController < ApplicationController

def index
  @partenaires = current_user.partenaires
  caleventnumber
end


def edit
  @partenaires = Partenaire.edit
end

def update
  @partenaire = Partenaire.find(current_user.partenaires.first.id)
  if params[:partenaire]
    @partenaire.update(params_partenaire)
    redirect_to partenaires_path, notice: "La photo a bien été ajoutée !"
  else
    redirect_to partenaires_path, alert: "L'ajout n'a pas fonctionné."
  end
end

 private

  def params_partenaire
    params.require(:partenaire).permit(:photo)
  end

end
