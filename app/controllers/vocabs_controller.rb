class VocabsController < ApplicationController
    def index
      @vocabs = Vocab.all
    end

    def create
    end

    def delete
    end
end
