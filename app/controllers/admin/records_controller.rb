class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        user_search = params[:user_id]
        @records = Record.search_by_user(user_search)
        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv(user_search), filename: "records-#{Date.today}.csv" }
        end
    end

end