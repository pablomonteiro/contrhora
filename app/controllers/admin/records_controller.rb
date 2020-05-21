class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @records = Record.this_month.user_asc.register_desc

        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv, filename: "records-#{Date.today}.csv" }
          end
    end

end