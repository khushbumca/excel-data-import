require 'rails_helper'

RSpec.describe FetchDatasController, type: :controller do
  describe 'POST #upload_data' do
    it 'handles an valid file upload' do
      file = fixture_file_upload('valid.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

      post :upload_data, params: { file_data: file }

      expect(response).to render_template(:show)
    end

    it 'handles an invalid file upload' do
      file = fixture_file_upload('invalid.txt', 'text/plain')

      post :upload_data, params: { file_data: file }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Please select a valid excel file to upload.")
    end
    
    # Ensure output containg total user count, valid records count, invalid records count
    # Test excel having 11 records with 6 valid and 5 invalid
    it "handle only valid datas to database" do
      file = fixture_file_upload('valid.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      post :upload_data, params: { file_data: file }
      
      # Total rows are 11 in test excel file(including all spreadsheets).
      expect(assigns(:results)[:total_user]).to eq(11)
      # Valid rows are 6 in test excel file(including all spreadsheets).
      expect(assigns(:results)[:saved]).to eq(6)
      # Invalid rows are 5 in test excel file(including all spreadsheets).
      expect(assigns(:results)[:failed]).to eq(5)
    end

    # Ensure output containg failed records with reasons
    it "handle only valid datas to database" do
      file = fixture_file_upload('valid.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      post :upload_data, params: { file_data: file }

      # check error :- row no 4 in UsersData1 sheet having first name blank
      expect(assigns(:results)[:errors].first[:sheet]).to eq("UsersData1")
      expect(assigns(:results)[:errors].first[:rowno]).to eq(4)
      expect(assigns(:results)[:errors].first[:error]).to eq("First name can't be blank")

      # check error :- row no 3 in UsersData2 sheet having invalid email address
      expect(assigns(:results)[:errors].last[:sheet]).to eq("UsersData2")
      expect(assigns(:results)[:errors].last[:rowno]).to eq(3)
      expect(assigns(:results)[:errors].last[:error]).to eq("Email is invalid")

     
    end

  end
end
