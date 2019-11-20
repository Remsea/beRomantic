class PartenairesController < ApplicationController

def index
@partenaires = current_user.partenaires
end


def edit
end

def udpate
end

end
