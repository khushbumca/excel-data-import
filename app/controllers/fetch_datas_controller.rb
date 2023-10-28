class FetchDatasController < ApplicationController
	require 'roo'

    def index
    end

    def upload_data
    	excel = params[:file_data]
	    if excel.present? 
	    	if valid_excel_file?(excel)
		        workbook = Roo::Excelx.new(excel.path)
		        keys = ["first_name", "last_name", "email_id"]
		        
		        @results = {:total_user => 0, :saved => 0, :failed => 0, :errors => []}

		        #Process each spread sheet from Excel file
		        workbook.sheets.each do |sheet|
		            sheet_name = workbook.sheet(sheet)
		            #Iterate each row from spreadsheet
		            for i in 2..sheet_name.last_row do		        
	                    @results[:total_user] += 1 
	                    #Create a hash with keys and row fields
				        record = Hash[[keys, sheet_name.row(i)].transpose]
				        #If row is valid then save to database else collect the errors
				        data = save_record(record)
				        if data[:status] == "success"
				        	@results[:saved] += 1
				        else
				        	@results[:failed] += 1
				        	@results[:errors] << {:sheet => sheet, :rowno => i, :error => data[:errors]}			        	
				        end
				    end
				end  
				render :show
			else
				flash[:error] = 'Please select a valid excel file to upload.'
	        	redirect_to root_path	
	        end
	    else
	    	flash[:error] = 'Please select a file to upload.'
	        redirect_to root_path
	    end
  	end

  	def show
  		redirect_to root_path
  	end

  	private

  	def save_record(record)
  		user = User.new(record)
		if user.save
			{ status: 'success' }
		else
			{ status: 'failed' , errors: user.errors.full_messages.join(", ") }
		end
  	end

    def valid_excel_file?(file)
    	file_extension = File.extname(file.original_filename)
        ['.xls', '.xlsx'].include?(file_extension.downcase)
    end
end
